import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../main.dart';
import '../../../model/cars/car/car.dart';
import '../../../module/global_dialog.dart';
import '../../../module/global_icon_button.dart';
import '../../../stores/user_data_store.dart';
import '../../../utils/constants/colors.dart';
import '../../car_details/views/car_details_page.dart';
import '../../favorites/controllers/favorites_cars_controller.dart';
import '../../my_cars/controllers/my_cars_controller.dart';
import '../../my_cars/widgets/status_toggle_button.dart';

class CarCard extends StatefulWidget {
  const CarCard({
    super.key,
    required this.car,
    this.isMyCars = false,
  });

  final Car car;
  final bool isMyCars;

  @override
  State<CarCard> createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> with TickerProviderStateMixin {
  late Car car;
  Timer? _timer;
  Timer? _priceSwitchTimer;
  int _currentImageIndex = 0;
  bool _isTransitioning = false;
  late AnimationController _fadeController;
  late AnimationController _shimmerController;
  late AnimationController _priceSwitchController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _priceSwitchAnimation;
  final Random _random = Random();

  // Price switching state
  bool _showPrice = true; // true = show price, false = show down payment
  bool _hasPrice = false;
  bool _hasDownPayment = false;

  @override
  void initState() {
    super.initState();
    car = widget.car;

    // Check which prices are available
    _hasPrice = car.price != null;
    _hasDownPayment = car.downPayment != null;

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _priceSwitchController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _shimmerAnimation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));

    _priceSwitchAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _priceSwitchController,
      curve: Curves.easeInOut,
    ));

    // Start with the first image visible
    _fadeController.value = 1.0;

    // Start with price switch animation at full opacity
    _priceSwitchController.value = 1.0;

    // Start the slideshow if there are multiple images
    if (car.images != null && car.images!.length > 1) {
      _startSlideshow();
    }

    // Start price switching if both price and down payment exist
    if (_hasPrice && _hasDownPayment) {
      _startPriceSwitching();
    }
  }

  void _startSlideshow() {
    // Cancel any existing timer
    _timer?.cancel();

    // Generate random interval between 7-15 seconds
    var randomInterval = 7000 + _random.nextInt(15000);

    _timer = Timer(Duration(milliseconds: randomInterval), () {
      if (mounted &&
          car.images != null &&
          car.images!.isNotEmpty &&
          !_isTransitioning) {
        _transitionToNextImage();
      }
    });
  }

  void _transitionToNextImage() async {
    if (_isTransitioning) return;

    setState(() {
      _isTransitioning = true;
    });

    try {
      // Start fade out
      await _fadeController.reverse();

      // Start shimmer effect
      await _shimmerController.repeat();

      // Wait for shimmer effect
      await Future.delayed(const Duration(milliseconds: 300));

      // Change to next image
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % car.images!.length;
      });

      // Stop shimmer and reset
      _shimmerController.stop();
      _shimmerController.reset();

      // Fade in new image
      await _fadeController.forward();
    } catch (e) {
      // Ensure animations are reset even if there's an error
      _shimmerController.stop();
      _shimmerController.reset();
      _fadeController.value = 1.0;
    } finally {
      // Always ensure transitioning state is reset
      if (mounted) {
        setState(() {
          _isTransitioning = false;
        });
      }
    }

    // Schedule next transition
    _startSlideshow();
  }

  void _startPriceSwitching() {
    // Cancel any existing price switch timer
    _priceSwitchTimer?.cancel();

    _priceSwitchTimer = Timer(const Duration(seconds: 3), () async {
      if (mounted) {
        // Animate out current price
        await _priceSwitchController.reverse();

        // Switch to the other price type
        setState(() {
          _showPrice = !_showPrice;
        });

        // Animate in new price
        await _priceSwitchController.forward();

        // Schedule next switch
        _startPriceSwitching();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _priceSwitchTimer?.cancel();
    _fadeController.dispose();
    _shimmerController.dispose();
    _priceSwitchController.dispose();
    super.dispose();
  }

  String get _currentImageUrl {
    if (car.images != null && car.images!.isNotEmpty) {
      return car.images![_currentImageIndex];
    }
    return car.coverImage ?? 'assets/images/default_car.png';
  }

  Widget _buildPriceDisplay() {
    // Determine what to show based on available data
    if (!_hasPrice && !_hasDownPayment) {
      return const SizedBox.shrink(); // No prices available
    }

    // Get the current price value and icon
    double currentAmount;
    Color backgroundColor;

    if (_showPrice && _hasPrice) {
      // Show price
      currentAmount = car.price!;
      backgroundColor = MyColors.primary;
    } else if (!_showPrice && _hasDownPayment) {
      // Show down payment
      currentAmount = car.downPayment!.toDouble();
      backgroundColor = Colors.orange.shade600;
    } else if (_hasPrice) {
      // Fallback to price if showing down payment but it's not available
      currentAmount = car.price!;
      backgroundColor = MyColors.primary;
    } else {
      // Fallback to down payment if showing price but it's not available
      currentAmount = car.downPayment!.toDouble();
      backgroundColor = Colors.orange.shade600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${tr('JD')} ${currentAmount.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Card(
        color: MyColors.surface,
        surfaceTintColor: MyColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            // Navigate to car details page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CarDetailsPage(car: car, isMyCar: widget.isMyCars),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image section with gradient overlay
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    // Car image with fade transition
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        child: Stack(
                          children: [
                            // Main image
                            CachedNetworkImage(
                              imageUrl: car.coverImage ?? '',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.car_rental, size: 40),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Gradient overlay for better text readability
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Animated Price/Down Payment display
                    Positioned(
                      top: 12,
                      right: 12,
                      child: AnimatedBuilder(
                        animation: _priceSwitchAnimation,
                        builder: (context, child) => FadeTransition(
                          opacity: _priceSwitchAnimation,
                          child: _buildPriceDisplay(),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        height: 32,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CachedNetworkImage(
                          imageUrl: car.brand?.imageUrl ?? '',
                          fit: BoxFit.fill,
                          placeholder: (context, url) => const SizedBox(),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.car_rental,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                    // Status toggle button (only show in My Cars page)
                    if (widget.isMyCars)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Obx(
                          () => StatusToggleButton(
                            isActive: car.isActive ?? false,
                            isLoading: Get.find<MyCarsController>().isLoading,
                            onToggle: () {
                              GlobalDialog.show(
                                context: context,
                                title: tr(
                                    'are you sure you want to toggle the status of this car?'),
                                message:
                                    '${tr('this action will change the status of the car to')} ${tr(car.isActive ?? false ? 'active' : 'inactive')}',
                                onConfirm: () => Get.find<MyCarsController>()
                                    .toggleCarStatus(car),
                                onCancel: () => Get.find<MyCarsController>()
                                    .isLoading = false,
                                confirmText: tr('yes'),
                                cancelText: tr('no'),
                              );
                            },
                          ),
                        ),
                      ),
                    if (widget.isMyCars)
                      Positioned(
                        bottom: 8,
                        right: 54,
                        child: Obx(
                          () => GlobalIconButton(
                            iconData: Icons.delete,
                            iconColor: MyColors.error,
                            backgroundColor:
                                MyColors.error.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(100),
                            iconSize: 20,
                            buttonSize: 36,
                            onPressed: () {
                              GlobalDialog.show(
                                context: context,
                                title: tr(
                                    'are you sure you want to delete this car?'),
                                message: tr(
                                    'this action will delete the car from the database'),
                                onConfirm: () =>
                                    Get.find<MyCarsController>().deleteCar(car),
                                onCancel: () => Get.find<MyCarsController>()
                                    .isLoading = false,
                                confirmText: tr('yes'),
                                cancelText: tr('no'),
                              );
                            },
                          ),
                        ),
                      ),
                    // Favorite button (only show when not in My Cars page)
                    if (!widget.isMyCars)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Obx(
                            () => IconButton(
                              onPressed: () {
                                if (Get.find<UserDataStore>()
                                    .favoriteCars
                                    .contains(car.id)) {
                                  Get.find<UserDataStore>()
                                      .favoriteCars
                                      .remove(car.id);
                                } else {
                                  Get.find<UserDataStore>()
                                      .favoriteCars
                                      .add(car.id ?? 0);
                                }
                                Get.find<FavoritesCarsController>().fetchCars();
                              },
                              icon: Get.find<UserDataStore>()
                                      .favoriteCars
                                      .contains(car.id)
                                  ? Icon(
                                      Icons.favorite,
                                      size: 18,
                                      color: MyColors.primary,
                                    )
                                  : const Icon(
                                      Icons.favorite_border,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Car details section
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Car name and year
                      Text(
                        car.title ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: MyColors.secondary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              car.year.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: MyColors.secondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              '${car.mileageKm ?? 0} ${car.mileageKm?.contains('km') ?? false ? '' : 'km'}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),
                      // Car specifications with modern icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSpecItem(
                            icon: Icons.airline_seat_recline_normal,
                            value: '${car.seats}',
                            label: tr('seats'),
                          ),
                          _buildSpecItem(
                            icon: Icons.door_front_door_outlined,
                            value: '${car.doors}',
                            label: tr('doors'),
                          ),
                          _buildSpecItem(
                            icon: car.fuelType == 'Electric'
                                ? Icons.electric_bolt
                                : Icons.local_gas_station_outlined,
                            value: _getFuelTypeShort(car.fuelType ?? ''),
                            label: tr('fuel'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for specification items
  Widget _buildSpecItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: MyColors.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: MyColors.secondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

// Helper method to get short fuel type
  String _getFuelTypeShort(String fuelType) {
    switch (fuelType.toLowerCase()) {
      case 'gasoline':
        return 'Gas';
      case 'electric':
        return 'Elec';
      case 'diesel':
        return 'Dies';
      case 'hybrid':
        return 'Hyb';
      default:
        return fuelType.length > 4 ? fuelType.substring(0, 4) : fuelType;
    }
  }
}
