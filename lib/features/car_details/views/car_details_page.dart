import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' hide Marker;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

import '../../../common/widgets/shimmer/shimmer_components.dart';
import '../../../main.dart';
import '../../../model/cars/car/car.dart';
import '../../../model/cars/car_color/car_color.dart';
import '../../../model/cars/dealer/dealer.dart';
import '../../../module/global_sheet.dart';
import '../../../services/share_service.dart';
import '../../../stores/user_data_store.dart';
import '../../../utils/constants/colors.dart';
import '../../brand_models/views/brand_models_page.dart';
import '../../dealer_details/views/dealer_details_page.dart';
import '../../favorites/controllers/favorites_cars_controller.dart';
import '../../home/widgets/section_title.dart';
import '../../my_cars/view/update_car_page.dart';

class CarDetailsPage extends StatefulWidget {
  const CarDetailsPage({super.key, required this.car, this.isMyCar = false});
  final Car car;
  final bool isMyCar;

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  late final PageController _pageController;
  late final ScrollController _dotsScrollController;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  int _currentIndex = 0;
  late PageController _galleryPageController;
  int _galleryCurrentIndex = 0;

  static const double _expandedHeight = 400;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _dotsScrollController = ScrollController();
    _galleryPageController = PageController();

    // Initialize video player if video URL exists
    if (widget.car.video != null && widget.car.video!.isNotEmpty) {
      _initializeVideoPlayer();
    }

    // Scroll to active dot after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _scrollToActiveDot(_currentIndex, widget.car.images?.length ?? 1);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _dotsScrollController.dispose();
    _galleryPageController.dispose();
    _disposeVideoPlayer();
    super.dispose();
  }

  Future<void> _initializeVideoPlayer() async {
    if (widget.car.video == null || widget.car.video!.isEmpty) return;

    try {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.car.video!),
      );

      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: false,
        looping: false,
        showControls: true,
        showControlsOnInitialize: true,
        showOptions: true,
        allowFullScreen: true,
        allowMuting: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: MyColors.primary,
          handleColor: MyColors.primary,
          backgroundColor: Colors.grey.shade300,
          bufferedColor: Colors.grey.shade500,
        ),
      );

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error initializing video player: $e');
    }
  }

  void _disposeVideoPlayer() {
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    _chewieController = null;
    _videoPlayerController = null;
  }

  void _showVideoOverlay() {
    if (_chewieController == null) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with close button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    Text(
                      tr('video'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        _videoPlayerController?.pause();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Video player
              Flexible(
                child: Container(
                  color: Colors.black,
                  child: Chewie(controller: _chewieController!),
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((_) {
      _videoPlayerController?.pause();
    });
  }

  void _showGalleryOverlay(int initialIndex) {
    debugPrint('🎯 Gallery overlay opened! Starting at image: $initialIndex');
    final images = widget.car.images?.isNotEmpty == true ? widget.car.images! : [widget.car.coverImage ?? 'assets/images/default_car.png'];
    debugPrint('📸 Total images available: ${images.length}');

    setState(() {
      _galleryCurrentIndex = initialIndex;
      _currentIndex = initialIndex;
    });

    // Initialize gallery page controller with the correct initial page
    _galleryPageController = PageController(initialPage: initialIndex);

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: StatefulBuilder(
          builder: (context, setModalState) => Stack(
            children: [
              // Gallery PageView
              PageView.builder(
                controller: _galleryPageController,
                itemCount: images.length,
                onPageChanged: (index) {
                  setState(() {
                    _galleryCurrentIndex = index;
                    _currentIndex = index;
                  });
                  setModalState(() {
                    // This will trigger a rebuild of the modal content
                    _galleryCurrentIndex = index;
                  });
                  // Update indicator dots when gallery image changes
                  _scrollToActiveDot(index, images.length);
                },
                itemBuilder: (context, index) => InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: CachedNetworkImage(
                    imageUrl: images[index],
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Container(
                      color: Colors.black,
                      child: const Center(
                        child: LoadingShimmer(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.black,
                      child: const Center(
                        child: Icon(
                          Icons.error,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Close button
              Positioned(
                top: 40,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),

              // Image counter
              Positioned(
                top: 40,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${_galleryCurrentIndex + 1} / ${images.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // Navigation arrows (only show if more than 1 image)
              if (images.length > 1) ...[
                // Left arrow
                Positioned.directional(
                  start: 10,
                  textDirection: Directionality.of(context),
                  top: MediaQuery.of(context).size.height / 2 - 25,
                  child: GestureDetector(
                    onTap: () {
                      if (_galleryCurrentIndex > 0) {
                        _galleryPageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Icon(
                        Icons.chevron_left,
                        color: _galleryCurrentIndex > 0 ? Colors.white : Colors.white.withValues(alpha: 0.3),
                        size: 30,
                      ),
                    ),
                  ),
                ),

                // Right arrow
                Positioned.directional(
                  end: 10,
                  textDirection: Directionality.of(context),
                  top: MediaQuery.of(context).size.height / 2 - 25,
                  child: GestureDetector(
                    onTap: () {
                      if (_galleryCurrentIndex < images.length - 1) {
                        _galleryPageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Icon(
                        Icons.chevron_right,
                        color: _galleryCurrentIndex < images.length - 1 ? Colors.white : Colors.white.withValues(alpha: 0.3),
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _scrollToActiveDot(int index, int totalImages) {
    if (!_dotsScrollController.hasClients) return;

    // Calculate the position to scroll to center the active dot
    const dotWidth = 8.0 + 8.0; // dot width + horizontal margin
    const activeDotWidth = 24.0 + 8.0; // active dot width + horizontal margin
    final containerWidth = MediaQuery.of(context).size.width * 0.8;

    // Calculate the target scroll position
    var targetScrollPosition = 0.0;

    if (index == 0) {
      targetScrollPosition = 0.0;
    } else if (index == totalImages - 1) {
      // Scroll to show the last dot
      targetScrollPosition = _dotsScrollController.position.maxScrollExtent;
    } else {
      // Calculate position to center the active dot
      var totalWidthBeforeActive = 0.0;
      for (var i = 0; i < index; i++) {
        totalWidthBeforeActive += (i == index - 1 ? activeDotWidth : dotWidth);
      }

      // Center the active dot in the container
      targetScrollPosition = totalWidthBeforeActive - (containerWidth / 2) + (activeDotWidth / 2);
      targetScrollPosition = targetScrollPosition.clamp(0.0, _dotsScrollController.position.maxScrollExtent);
    }

    _dotsScrollController.animateTo(
      targetScrollPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildSliverAppBarContent() {
    final images = widget.car.images?.isNotEmpty == true ? widget.car.images! : [widget.car.coverImage ?? 'assets/images/default_car.png'];

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1) The carousel itself, fully interactive:
        PageView.builder(
          controller: _pageController,
          itemCount: images.length,
          onPageChanged: (i) {
            setState(() => _currentIndex = i);
            // Scroll to active dot with a slight delay to ensure smooth animation
            Future.delayed(const Duration(milliseconds: 50), () {
              _scrollToActiveDot(i, images.length);
            });
          },
          itemBuilder: (context, i) => GestureDetector(
            onTap: () => _showGalleryOverlay(i),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: images[i],
                      fit: BoxFit.cover,
                      placeholder: (c, u) => Container(
                        color: Colors.grey[200],
                        child: const Center(child: LoadingShimmer()),
                      ),
                      errorWidget: (c, u, e) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.car_rental, size: 60),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.4),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 3) Indicator dots — also ignore touches:
        if (images.length > 1)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6, // Max 80% of screen width
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _dotsScrollController,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: images.asMap().entries.map((e) {
                    final idx = e.key;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: idx == _currentIndex ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: idx == _currentIndex ? MyColors.primary : Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          if (idx == _currentIndex)
                            BoxShadow(
                              color: MyColors.primary.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        if (widget.car.video != null && widget.car.video!.isNotEmpty)
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: _showVideoOverlay,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.play_arrow_rounded,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: _expandedHeight,
            backgroundColor: MyColors.background,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DealerDetailsPage(dealer: widget.car.dealer!),
                    ),
                  ),
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: widget.car.dealer!.logo!,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: LoadingShimmer(),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Text(
                          widget.car.dealer!.storeName ?? 'Unknown Dealer',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: MyColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BrandModelsPage(brand: widget.car.brand!),
                    ),
                  ),
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.car.brand!.imageUrl!,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => const SizedBox(),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.car_rental,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: MyColors.grey600,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.background,
                shape: const CircleBorder(),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              if (!widget.isMyCar)
                Obx(
                  () => IconButton(
                    onPressed: () {
                      if (Get.find<UserDataStore>().favoriteCars.contains(widget.car.id)) {
                        Get.find<UserDataStore>().favoriteCars.remove(widget.car.id);
                      } else {
                        Get.find<UserDataStore>().favoriteCars.add(widget.car.id ?? 0);
                      }
                      Get.find<FavoritesCarsController>().fetchCars();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.background,
                      shape: const CircleBorder(),
                    ),
                    icon: Get.find<UserDataStore>().favoriteCars.contains(widget.car.id)
                        ? Icon(
                            Icons.favorite,
                            size: 18,
                            color: MyColors.primary,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            size: 18,
                            color: Colors.redAccent,
                          ),
                    padding: EdgeInsets.zero,
                  ),
                )
              else
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateCarPage(car: widget.car),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.background,
                    shape: const CircleBorder(),
                  ),
                  icon: Icon(
                    Icons.edit,
                    size: 18,
                    color: MyColors.primary,
                  ),
                  padding: EdgeInsets.zero,
                ),
              IconButton(
                icon: Icon(
                  Icons.share_rounded,
                  color: MyColors.grey600,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.background,
                  shape: const CircleBorder(),
                ),
                onPressed: () => ShareService.shareCar(
                  carId: widget.car.id ?? 0,
                  carName: widget.car.title ?? 'Unknown Car',
                  carImage: widget.car.coverImage,
                  dealerName: widget.car.dealer?.storeName,
                  price: widget.car.price,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _buildSliverAppBarContent(),
              collapseMode: CollapseMode.pin,
            ),
            surfaceTintColor: MyColors.background,
          ),
          SliverToBoxAdapter(
            child: _DetailSection(car: widget.car),
          ),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.car});
  final Car car;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: MyColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  car.title ?? 'Unknown Car',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: MyColors.black),
                ),
                const SizedBox(height: 16),
                _PriceDisplay(car: car, currencyCode: tr('JD'), animationDuration: const Duration(milliseconds: 300)),
              ],
            ),
          ),
          SectionTitle(tr('brand and model')),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
            child: _BrandAndModel(car: car),
          ),
          SectionTitle(tr('specifications')),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
            child: _SpecsList(car: car),
          ),
          SectionTitle(tr('available colors')),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: _ColorOptions(colors: car.colors),
          ),
          SectionTitle(tr('description')),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
            child: car.description?.isNotEmpty == true
                ? Html(
                    data: car.description!.replaceAll('\n', '<br>'),
                    style: {
                      'body': Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                        fontSize: FontSize(16.0),
                        lineHeight: const LineHeight(1.5),
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      'p': Style(
                        margin: Margins(bottom: Margin(12.0)),
                        padding: HtmlPaddings.zero,
                      ),
                      'div': Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                      'br': Style(
                        display: Display.block,
                      ),
                    },
                    onLinkTap: (url, attributes, element) async {
                      if (url != null) {
                        // Handle link taps if needed
                      }
                    },
                    onCssParseError: (css, messages) {
                      // Handle CSS parsing errors
                      debugPrint('CSS parsing error: $css');
                      return null;
                    },
                  )
                : Text(
                    tr('no_description_available'),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
          ),
          SectionTitle(tr('dealer information')),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 16),
            child: _DealerInfoCard(dealer: car.dealer!),
          ),
          const SizedBox(height: 65),
        ],
      ),
    );
  }
}

// @freezed
// class Color with _$Color {
//   const factory Color({
//     int? id,
//     String? name,
//     @JsonKey(name: 'color_code') String? colorCode,
//   }) = _Color;

//   factory Color.fromJson(Map<String, dynamic> json) => _$ColorFromJson(json);
// }

// @freezed
// class CarColor with _$CarColor {
//   const factory CarColor({
//     int? id,
//     Color? color,
//     String? type,
//     @JsonKey(fromJson: imageUrlsFromJson) List<String>? images,
//   }) = _CarColor;

//   factory CarColor.fromJson(Map<String, dynamic> json) => _$CarColorFromJson(json);
// }

class _ColorOptions extends StatefulWidget {
  const _ColorOptions({this.colors});
  final List<CarColor>? colors;

  @override
  State<_ColorOptions> createState() => _ColorOptionsState();
}

class _ColorOptionsState extends State<_ColorOptions> {
  String _selectedType = 'exterior';
  CarColor? _selectedColor;

  List<CarColor> get _exteriorColors => widget.colors?.where((c) => c.type?.toLowerCase() == 'exterior').toList() ?? [];
  List<CarColor> get _interiorColors => widget.colors?.where((c) => c.type?.toLowerCase() == 'interior').toList() ?? [];

  void _showColorGallery(CarColor color) {
    if (color.images == null || color.images!.isEmpty) return;
    GlobalBottomSheet.show(
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(int.parse(color.color!.colorCode!.replaceAll('#', ''), radix: 16) + 0xFF000000),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${color.color!.name} (${color.type})',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Container(
        decoration: BoxDecoration(
          color: MyColors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 500,
              child: PageView.builder(
                controller: PageController(
                  viewportFraction: 0.9,
                ),
                itemCount: color.images!.length,
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: color.images![index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(child: LoadingShimmer()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      enableDrag: false,
      enableResize: true,
    );
    // showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true,
    //   backgroundColor: Colors.transparent,
    //   builder: (context) => DraggableScrollableSheet(
    //     initialChildSize: 0.9,
    //     maxChildSize: 0.9,
    //     minChildSize: 0.5,
    //     builder: (context, scrollController) =>   ),
    // );
  }

  Widget _buildColorItem(CarColor colorItem, bool isLeft) {
    final colorCode = Color(int.parse(colorItem.color!.colorCode!.replaceAll('#', ''), radix: 16) + 0xFF000000);
    final isSelected = _selectedColor == colorItem;

    final textWidget = Text(
      colorItem.color!.name!,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: colorCode.computeLuminance() > 0.5 ? Colors.black87 : Colors.white,
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
        letterSpacing: 0.2,
      ),
    );

    return GestureDetector(
      onTap: () {
        setState(() => _selectedColor = colorItem);
        if (colorItem.images?.isNotEmpty == true) {
          _showColorGallery(colorItem);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 8.0,
          left: isLeft ? 20 : 0,
          right: isLeft ? 0 : 20,
        ),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: colorCode,
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(isLeft ? 100 : 0),
              right: Radius.circular(isLeft ? 0 : 100),
            ),
            border: Border.all(
              color: isSelected ? MyColors.primary : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: MyColors.primary.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(left: isLeft ? 12 : 0, right: isLeft ? 0 : 12),
                child: Align(
                  alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      textWidget,
                      if (colorItem.images?.isNotEmpty == true) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.photo_library,
                          size: 16,
                          color: colorCode.computeLuminance() > 0.5 ? Colors.black54 : Colors.white70,
                        ),
                      ],
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

  @override
  Widget build(BuildContext context) {
    if (widget.colors == null || widget.colors!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          tr('no colors available'),
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return Column(
      children: [
        // Color type selector
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _selectedType = 'exterior';
                      _selectedColor = null;
                    }),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedType == 'exterior' ? MyColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Center(
                        child: Text(
                          '${tr('exterior')} (${_exteriorColors.length})',
                          style: TextStyle(
                            color: _selectedType == 'exterior' ? Colors.black : MyColors.grey600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _selectedType = 'interior';
                      _selectedColor = null;
                    }),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedType == 'interior' ? MyColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Center(
                        child: Text(
                          '${tr('interior')} (${_interiorColors.length})',
                          style: TextStyle(
                            color: _selectedType == 'interior' ? Colors.black : MyColors.grey600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Color list
        ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _selectedType == 'exterior' ? _exteriorColors.length : _interiorColors.length,
          itemBuilder: (context, index) {
            final colorItem = _selectedType == 'exterior' ? _exteriorColors[index] : _interiorColors[index];
            return _buildColorItem(colorItem, index % 2 == 0);
          },
        ),
      ],
    );
  }
}

class _BrandAndModel extends StatelessWidget {
  const _BrandAndModel({required this.car});
  final Car car;

  @override
  Widget build(BuildContext context) {
    final brandAndModel = [
      _SpecData(
        icon: Icons.car_repair,
        title: tr('brand'),
        value: car.brand!.name ?? '-',
      ),
      _SpecData(
        icon: Icons.model_training,
        title: tr('model'),
        value: car.brandModel!.name ?? '-',
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _SpecGridItem(spec: brandAndModel[0]),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SpecGridItem(spec: brandAndModel[1]),
        ),
      ],
    );
  }
}

class _SpecsList extends StatelessWidget {
  const _SpecsList({required this.car});
  final Car car;

  @override
  Widget build(BuildContext context) {
    final basicSpecs = [
      _SpecData(
        icon: Icons.calendar_today,
        title: tr('year'),
        value: car.year.toString(),
      ),
      _SpecData(
        icon: Icons.speed,
        title: tr('mileage'),
        value: '${car.mileageKm ?? 0} ${car.mileageKm?.contains('km') ?? false ? '' : 'km'}',
      ),
      _SpecData(
        icon: car.fuelType?.toLowerCase() == 'electric' ? Icons.electric_bolt : Icons.local_gas_station,
        title: tr('fuel type'),
        value: car.fuelType ?? '-',
      ),
      _SpecData(
        icon: Icons.door_front_door,
        title: tr('doors'),
        value: '${car.doors ?? 0} ${tr('doors')}',
      ),
    ];

    final detailedSpecs = [
      _SpecData(
        icon: Icons.settings,
        title: tr('transmission'),
        value: (car.transmission ?? '-').toUpperCase(),
      ),
      _SpecData(
        icon: Icons.all_inclusive,
        title: tr('drivetrain'),
        value: (car.drivetrain ?? '-').toUpperCase(),
      ),
      _SpecData(
        icon: Icons.power,
        title: tr('horsepower'),
        value: '${car.horsepower ?? 0} HP',
      ),
      _SpecData(
        icon: Icons.event_seat,
        title: tr('seats'),
        value: '${car.seats ?? 0} seats',
      ),
      _SpecData(
        icon: Icons.car_repair,
        title: tr('condition'),
        value: (car.condition ?? '-').toUpperCase(),
      ),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Basic Specs
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _SpecGridItem(spec: basicSpecs[0]),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SpecGridItem(spec: basicSpecs[1]),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _SpecGridItem(spec: basicSpecs[2]),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SpecGridItem(spec: basicSpecs[3]),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Detailed Specs Title
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            tr('additional specifications'),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),

        // Detailed Specs Grid
        for (int i = 0; i < detailedSpecs.length; i += 2) ...[
          if (i > 0) const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _SpecGridItem(spec: detailedSpecs[i]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: i + 1 < detailedSpecs.length ? _SpecGridItem(spec: detailedSpecs[i + 1]) : const SizedBox(), // Empty container for odd number of items
              ),
            ],
          ),
        ],
      ],
    );
    // GridView.builder(
    //   shrinkWrap: true,
    //   physics: const NeverScrollableScrollPhysics(),
    //   padding: const EdgeInsets.all(0),
    //   itemCount: specs.length,
    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 2,
    //     mainAxisSpacing: 12,
    //     crossAxisSpacing: 12,
    //     childAspectRatio: 3.5,
    //   ),
    //   itemBuilder: (context, index) {
    //     final spec = specs[index];
    //     return _SpecGridItem(spec: spec);
    //   },
    // );
  }
}

class _SpecData {
  final IconData icon;
  final String title;
  final String value;
  _SpecData({required this.icon, required this.title, required this.value});
}

class _SpecGridItem extends StatelessWidget {
  final _SpecData spec;
  const _SpecGridItem({required this.spec});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: MyColors.secondary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(
            spec.icon,
            color: MyColors.primary,
            size: 28,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              spec.value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(
              spec.title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}

class _DealerInfoCard extends StatelessWidget {
  final Dealer dealer;
  const _DealerInfoCard({required this.dealer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: MyColors.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: MyColors.grey.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Card(
        color: MyColors.background,
        surfaceTintColor: MyColors.background,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(0),
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DealerDetailsPage(dealer: dealer),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Enhanced Avatar with gradient and shadow
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: MyColors.shadow.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 38,
                    backgroundColor: MyColors.grey.withValues(alpha: 0.2),
                    backgroundImage: dealer.logo != null ? NetworkImage(dealer.logo!) : null,
                    child: dealer.logo == null
                        ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Colors.blue.shade400, Colors.blue.shade600],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 32,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 20),

                // Enhanced Info Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dealer Name with better typography
                      Text(
                        dealer.storeName ?? 'Unknown Dealer',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: MyColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Contact Information with improved styling
                      if (dealer.phoneNumber != null) ...[
                        _ContactRow(
                          icon: Icons.phone_rounded,
                          text: dealer.phoneNumber!,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 10),
                      ],

                      if (dealer.email != null) ...[
                        _ContactRow(
                          icon: Icons.email_rounded,
                          text: dealer.email!,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 10),
                      ],

                      if (dealer.address != null) ...[
                        _ContactRow(
                          icon: Icons.location_on_rounded,
                          text: dealer.address!,
                          color: Colors.orange,
                        ),
                      ],
                    ],
                  ),
                ),
                // Options Menu Button
                // Options Menu Button
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Helper widget for contact information rows
class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _ContactRow({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 22,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: MyColors.grey700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// Widget for displaying price and down payment conditionally

class _PriceDisplay extends StatelessWidget {
  final Car car;
  final String currencyCode; // e.g., 'USD', 'EUR'
  final Duration animationDuration;

  const _PriceDisplay({
    required this.car,
    required this.currencyCode,
    required this.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasPrice = car.price != null && car.price! >= 0;
    final hasDownPayment = car.downPayment != null && car.downPayment! >= 0;

    // Fallback UI when no price or down payment is available
    if (!hasPrice && !hasDownPayment) {
      return _buildNoPriceContainer(context, theme);
    }

    // Single price or down payment
    if (hasPrice && !hasDownPayment) {
      return _buildPriceItem(
        context,
        theme,
        label: tr('price'),
        amount: car.price!,
        isPrimary: true,
      );
    }

    if (!hasPrice && hasDownPayment) {
      return _buildPriceItem(
        context,
        theme,
        label: tr('down_payment'),
        amount: car.downPayment!.toDouble(),
        isPrimary: true,
      );
    }

    // Both price and down payment
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPriceItem(
          context,
          theme,
          label: tr('full price'),
          amount: car.price!,
          isPrimary: true,
        ),
        const SizedBox(height: 12),
        _buildPriceItem(
          context,
          theme,
          label: tr('down payment'),
          amount: car.downPayment!.toDouble(),
          isPrimary: false,
        ),
      ],
    );
  }

  // Fallback UI for no price/down payment
  Widget _buildNoPriceContainer(BuildContext context, ThemeData theme) {
    return AnimatedContainer(
      duration: animationDuration,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Semantics(
        label: tr('price not available'),
        child: Text(
          tr('price not available'),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  // Reusable price item widget
  Widget _buildPriceItem(
    BuildContext context,
    ThemeData theme, {
    required String label,
    required double amount,
    required bool isPrimary,
  }) {
    final formatter = NumberFormat.currency(
      locale: Localizations.localeOf(context).toString(),
      symbol: tr('JD'),
    );

    return AnimatedOpacity(
      opacity: 1.0,
      duration: animationDuration,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isPrimary ? theme.colorScheme.primaryContainer.withValues(alpha: 0.1) : theme.colorScheme.surface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPrimary ? theme.colorScheme.primary.withValues(alpha: 0.3) : theme.colorScheme.onSurface.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: isPrimary ? FontWeight.w700 : FontWeight.w500,
                color: isPrimary ? Colors.black : theme.colorScheme.onSurface,
              ),
            ),
            Text(
              formatter.format(amount),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: isPrimary ? FontWeight.w700 : FontWeight.w500,
                color: isPrimary ? Colors.black : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// // Individual price item widget
// class _PriceItem extends StatelessWidget {
//   final String label;
//   final double amount;
//   final bool isPrimary;

//   const _PriceItem({
//     required this.label,
//     required this.amount,
//     required this.isPrimary,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         // Label
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//           decoration: BoxDecoration(
//             color: isPrimary ? MyColors.primary.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//               color: isPrimary ? MyColors.primary.withValues(alpha: 0.3) : Colors.orange.withValues(alpha: 0.3),
//               width: 1,
//             ),
//           ),
//           child: Text(
//             label.toUpperCase(),
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w700,
//               color: isPrimary ? MyColors.primary : Colors.orange.shade700,
//               letterSpacing: 0.5,
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         // Amount
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           decoration: BoxDecoration(
//             color: isPrimary ? MyColors.primary.withValues(alpha: 0.08) : Colors.orange.withValues(alpha: 0.08),
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(
//               color: isPrimary ? MyColors.primary.withValues(alpha: 0.2) : Colors.orange.withValues(alpha: 0.2),
//               width: 1.5,
//             ),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 tr('JD'),
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: isPrimary ? MyColors.primary : Colors.orange.shade700,
//                 ),
//               ),
//               const SizedBox(width: 4),
//               Text(
//                 amount.toStringAsFixed(0),
//                 style: TextStyle(
//                   fontSize: isPrimary ? 18 : 16,
//                   fontWeight: FontWeight.bold,
//                   color: isPrimary ? MyColors.primary : Colors.orange.shade700,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
