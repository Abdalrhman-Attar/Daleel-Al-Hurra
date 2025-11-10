import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import '../../../common/widgets/shimmer/shimmer_components.dart';
import '../../../main.dart';
import '../../../model/cars/dealer/dealer.dart';
import '../../../module/global_choice_chip.dart';
import '../../../module/toast.dart';
import '../../../services/share_service.dart';
import '../../../utils/constants/colors.dart';
import '../../home/widgets/car_brands_grid.dart';
import '../../home/widgets/car_grid.dart';
import '../../home/widgets/section_title.dart';
import '../controllers/car_body_types_controller.dart';
import '../controllers/dealer_cars_controller.dart';

class DealerDetailsPage extends StatefulWidget {
  final Dealer dealer;
  const DealerDetailsPage({super.key, required this.dealer});
  @override
  State<DealerDetailsPage> createState() => _DealerDetailsPageState();
}

class _DealerDetailsPageState extends State<DealerDetailsPage> {
  late Dealer dealer;

  final CarBodyTypesController carBodyTypesController = Get.put(CarBodyTypesController());
  final DealerCarsController dealerCarsController = Get.put(DealerCarsController());
  @override
  void initState() {
    super.initState();
    dealer = widget.dealer;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      carBodyTypesController.fetchFeaturedCarBodyTypes();
      dealerCarsController.dealerId = dealer.id;
      dealerCarsController.fetchDealerCars();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
            dealerCarsController.loadMoreCars();
          }
          return true;
        },
        child: CustomScrollView(
          slivers: [
            // Enhanced App Bar with gradient
            SliverAppBar(
              expandedHeight: 280,
              floating: false,
              pinned: true,
              backgroundColor: MyColors.background,
              surfaceTintColor: MyColors.background,
              elevation: 0,
              // title: Text(
              //   dealer.storeName ?? 'Unknown Dealer',
              //   style: const TextStyle(
              //     fontSize: 24,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.black,
              //   ),
              // ),
              // centerTitle: true,

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
                IconButton(
                  icon: Icon(
                    Icons.share_rounded,
                    color: MyColors.grey600,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.background,
                    shape: const CircleBorder(),
                  ),
                  onPressed: () => ShareService.shareDealer(
                    dealerId: dealer.id ?? 0,
                    dealerName: dealer.storeName ?? 'Unknown Dealer',
                    dealerLogo: dealer.logo,
                    dealerAddress: dealer.address,
                    dealerPhone: dealer.phoneNumber,
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        MyColors.primary.withValues(alpha: 0.9),
                        MyColors.primary.withValues(alpha: 0.9),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),

                      // Enhanced Profile Picture
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: MyColors.white,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: dealer.logo != null ? CachedNetworkImageProvider(dealer.logo!) : null,
                            backgroundColor: Colors.grey.shade200,
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
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Dealer Name
                      Text(
                        dealer.storeName ?? 'Unknown Dealer',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Verified Dealer',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.verified_user_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Content Section
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  SectionTitle(tr('contact information')),

                  // Enhanced Info Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16.0),
                    child: Column(
                      children: [
                        _EnhancedInfoCard(
                          icon: Icons.phone_rounded,
                          title: tr('Phone Number'),
                          value: dealer.phoneNumber ?? tr('Not Available'),
                          color: Colors.green,
                          onTap: dealer.phoneNumber != null ? () => _launchPhoneCall(dealer.phoneNumber!) : null,
                        ),
                        const SizedBox(height: 12),
                        _EnhancedInfoCard(
                          icon: Icons.chat_rounded,
                          title: tr('Whatsapp'),
                          value: dealer.phoneNumber ?? tr('Not Available'),
                          color: Colors.green,
                          onTap: dealer.phoneNumber != null ? () => _launchWhatsApp(dealer.phoneNumber!) : null,
                        ),
                        const SizedBox(height: 12),
                        _EnhancedInfoCard(
                          icon: Icons.location_on_rounded,
                          title: tr('Address'),
                          value: dealer.address ?? tr('Not Available'),
                          color: Colors.orange,
                          onTap: dealer.address != null ? () => _launchMaps(dealer.address!) : null,
                        ),
                      ],
                    ),
                  ),
                  SectionTitle(tr('associated brands')),
                  dealer.brands == null
                      ? const BrandGridShimmer()
                      : dealer.brands!.isEmpty
                          ? Center(child: Text(tr('no data found')))
                          : CarBrandsGrid(brands: dealer.brands ?? [], dealerId: dealer.id),
                  SectionTitle(tr('inventory')),
                  const SizedBox(height: 8),
                  Obx(() => carBodyTypesController.isLoading
                      ? const ChoiceChipsShimmer()
                      : carBodyTypesController.featuredCarBodyTypes.isEmpty
                          ? Center(child: Text(tr('no data found')))
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Obx(() => GlobalChoiceChip(
                                        label: tr('all'),
                                        selected: dealerCarsController.selectedCarBodyType == null,
                                        onSelected: (_) {
                                          dealerCarsController.selectedCarBodyType = null;
                                          dealerCarsController.fetchDealerCars();
                                        },
                                        selectedColor: MyColors.primary,
                                        backgroundColor: MyColors.cardBackground,
                                        labelStyle: TextStyle(
                                          color: dealerCarsController.selectedCarBodyType == null ? Colors.white : Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )),
                                ),
                                ...carBodyTypesController.featuredCarBodyTypes.map((bodyType) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Obx(() {
                                      final isSelected = bodyType.id == dealerCarsController.selectedCarBodyType;
                                      return GlobalChoiceChip(
                                        label: bodyType.name ?? tr('all'),
                                        selected: isSelected,
                                        onSelected: (_) {
                                          if (bodyType.id != null) {
                                            dealerCarsController.selectedCarBodyType = bodyType.id;
                                            dealerCarsController.fetchDealerCars();
                                          }
                                        },
                                        selectedColor: MyColors.primary,
                                        backgroundColor: MyColors.cardBackground,
                                        labelStyle: TextStyle(
                                          color: isSelected ? Colors.white : Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      );
                                    }),
                                  );
                                }),
                              ]),
                            )),
                  Obx(
                    () => dealerCarsController.isLoading
                        ? const CarGridShimmer()
                        : dealerCarsController.dealerCars.isEmpty
                            ? Center(child: Text(tr('no data found')))
                            : Column(
                                children: [
                                  CarGrid(filteredCars: dealerCarsController.dealerCars),
                                  // Loading indicator for pagination
                                  if (dealerCarsController.isLoadingMore)
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      child: const Center(
                                        child: LoadingShimmer(),
                                      ),
                                    ),
                                  // No more data indicator
                                  if (!dealerCarsController.hasMorePages && dealerCarsController.dealerCars.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      child: Center(
                                        child: Text(
                                          'No more cars to load',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void _handleViewInventory(BuildContext context) {
  //   // Navigate to inventory page
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Navigating to inventory...')),
  //   );
  // }

  // void _handleShare(BuildContext context) {
  //   // Implement share functionality
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Sharing dealer information...')),
  //   );
  // }

  Future<void> _launchWhatsApp(String phoneNumber) async {
    debugPrint('📱 Launching WhatsApp for: $phoneNumber');

    try {
      // Clean phone number and format for Jordan
      var cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
      debugPrint('🧹 Cleaned number: $cleanNumber');

      // Format Jordanian phone number
      var formattedNumber = _formatJordanianNumber(cleanNumber);
      debugPrint('🇯🇴 Formatted Jordanian number: $formattedNumber');

      // For Android, try direct launch first (bypass canLaunchUrl check)
      try {
        debugPrint('🚀 Trying direct WhatsApp launch...');
        final whatsappUri = Uri.parse('whatsapp://send?phone=$formattedNumber');
        await url_launcher.launchUrl(whatsappUri, mode: url_launcher.LaunchMode.externalApplication);
        debugPrint('✅ WhatsApp launched directly!');
        return;
      } catch (e) {
        debugPrint('💥 Direct launch failed, trying other methods...');
      }

      // Try different WhatsApp URL formats
      var whatsappUrls = <String>[
        'whatsapp://send?phone=$formattedNumber', // WhatsApp URI with formatted number
        'https://wa.me/$formattedNumber', // Web format with formatted number
      ];

      for (var url in whatsappUrls) {
        try {
          final uri = Uri.parse(url);
          debugPrint('🔗 Trying WhatsApp URL: $url');

          // For Android, sometimes canLaunchUrl returns false even when the app can handle it
          // So we'll try to launch and catch any exceptions
          await url_launcher.launchUrl(uri, mode: url_launcher.LaunchMode.externalApplication);
          debugPrint('🚀 WhatsApp launched with URL: $url');
          return;
        } catch (e) {
          debugPrint('💥 Error with URL $url: $e');
          continue;
        }
      }

      // If all WhatsApp URLs fail, try to open WhatsApp app directly
      debugPrint('📱 Trying to open WhatsApp app directly...');
      try {
        final whatsappAppUri = Uri.parse('whatsapp://');
        await url_launcher.launchUrl(whatsappAppUri, mode: url_launcher.LaunchMode.externalApplication);
        Toast.i('WhatsApp opened. Please search for the contact manually.');
        return;
      } catch (e) {
        debugPrint('💥 WhatsApp app direct launch failed: $e');
      }

      // If WhatsApp is not installed, suggest installing it
      debugPrint('📱 WhatsApp not found, trying to open Play Store...');
      try {
        final playStoreUri = Uri.parse('market://details?id=com.whatsapp');
        await url_launcher.launchUrl(playStoreUri, mode: url_launcher.LaunchMode.externalApplication);
        Toast.i('Please install WhatsApp to chat with this number');
        return;
      } catch (e) {
        debugPrint('💥 Play Store launch failed: $e');
      }

      // Last resort: regular phone call
      debugPrint('📞 Falling back to phone call...');
      try {
        final telUri = Uri.parse('tel:$phoneNumber');
        await url_launcher.launchUrl(telUri, mode: url_launcher.LaunchMode.externalApplication);
        Toast.i('WhatsApp not available, calling instead');
        return;
      } catch (e) {
        debugPrint('💥 Phone call fallback failed: $e');
      }

      // If everything fails
      Toast.e('Could not open WhatsApp. Please make sure it\'s installed and try again.');
    } catch (e) {
      debugPrint('💥 Error launching WhatsApp: $e');
      Toast.e('Error opening WhatsApp');
    }
  }

  String _formatJordanianNumber(String phoneNumber) {
    debugPrint('🔢 Formatting number: $phoneNumber');

    // Remove any existing country codes or prefixes
    var clean = phoneNumber.replaceAll(RegExp(r'^(\+962|962|00962)'), '');

    // Remove any non-digit characters
    clean = clean.replaceAll(RegExp(r'[^\d]'), '');

    debugPrint('🧹 Cleaned number: $clean');

    // Check the length and format accordingly
    if (clean.length == 9) {
      // Jordanian mobile numbers are 9 digits (without country code)
      // Format: +962XXXXXXXXX
      var formatted = '+962$clean';
      debugPrint('🇯🇴 Formatted 9-digit number: $formatted');
      return formatted;
    } else if (clean.length == 10 && clean.startsWith('0')) {
      // Numbers that start with 0 (like 0799741516)
      // Remove the leading 0 and add country code
      var formatted = '+962${clean.substring(1)}';
      debugPrint('🇯🇴 Formatted 10-digit number (with 0): $formatted');
      return formatted;
    } else if (clean.length == 12 && clean.startsWith('962')) {
      // Numbers that already have 962 prefix
      var formatted = '+$clean';
      debugPrint('🇯🇴 Formatted 12-digit number (with 962): $formatted');
      return formatted;
    } else if (clean.length == 13 && clean.startsWith('+962')) {
      // Numbers that already have +962 prefix
      debugPrint('🇯🇴 Number already properly formatted: $clean');
      return clean;
    } else {
      // For any other format, assume it's a Jordanian number and add +962
      var formatted = '+962$clean';
      debugPrint('🇯🇴 Default formatting (added +962): $formatted');
      return formatted;
    }
  }

  Future<void> _launchPhoneCall(String phoneNumber) async {
    debugPrint('📞 Launching phone call for: $phoneNumber');

    try {
      // Format the number for calling (don't add + prefix for tel: URLs)
      var cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
      var formattedNumber = _formatPhoneNumberForCall(cleanNumber);
      debugPrint('📱 Formatted number for call: $formattedNumber');

      final telUri = Uri.parse('tel:$formattedNumber');
      await url_launcher.launchUrl(telUri, mode: url_launcher.LaunchMode.externalApplication);
      debugPrint('✅ Phone call launched successfully!');
    } catch (e) {
      debugPrint('💥 Error launching phone call: $e');
      Toast.e('Could not make phone call');
    }
  }

  String _formatPhoneNumberForCall(String phoneNumber) {
    // For phone calls, we want the number in international format without the +
    var clean = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    if (clean.length == 9) {
      // 9 digits - add Jordan country code
      return '962$clean';
    } else if (clean.length == 10 && clean.startsWith('0')) {
      // 10 digits starting with 0 - replace 0 with 962
      return '962${clean.substring(1)}';
    } else if (clean.length == 12 && clean.startsWith('962')) {
      // Already has 962 prefix
      return clean;
    } else if (clean.length == 13 && clean.startsWith('962')) {
      // Has +962 but we remove the + for tel URLs
      return clean;
    } else {
      // Default: assume it's Jordanian and add 962
      return '962$clean';
    }
  }

  Future<void> _launchMaps(String address) async {
    debugPrint('🗺️ Launching maps for: $address');

    try {
      // URL encode the address for proper handling
      var encodedAddress = Uri.encodeComponent(address);
      debugPrint('📍 Encoded address: $encodedAddress');

      // Try different maps URL formats
      var mapsUrls = <String>[
        'https://maps.google.com/?q=$encodedAddress', // Standard Google Maps
        'geo:0,0?q=$encodedAddress', // Android geo intent
        'maps://maps.google.com/?q=$encodedAddress', // iOS maps
      ];

      for (var url in mapsUrls) {
        try {
          final uri = Uri.parse(url);
          debugPrint('🔗 Trying maps URL: $url');

          await url_launcher.launchUrl(uri, mode: url_launcher.LaunchMode.externalApplication);
          debugPrint('✅ Maps launched successfully!');
          return;
        } catch (e) {
          debugPrint('💥 Maps URL failed: $url - $e');
          continue;
        }
      }

      // If all fail
      Toast.e('Could not open maps application');
    } catch (e) {
      debugPrint('💥 Error launching maps: $e');
      Toast.e('Error opening maps');
    }
  }
}

// Quick Action Button Widget
// class _QuickActionButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final Color color;
//   final VoidCallback onTap;

//   const _QuickActionButton({
//     required this.icon,
//     required this.label,
//     required this.color,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//         decoration: BoxDecoration(
//           color: color.withValues(alpha: 0.1),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: color.withValues(alpha: 0.3)),
//         ),
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: color,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(
//                 icon,
//                 color: Colors.white,
//                 size: 24,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: color,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Enhanced Info Card Widget
class _EnhancedInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  const _EnhancedInfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = value != 'Not Available';

    return InkWell(
      onTap: isAvailable ? onTap : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isAvailable ? color.withValues(alpha: 0.2) : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isAvailable ? color.withValues(alpha: 0.1) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isAvailable ? color : Colors.grey.shade400,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isAvailable ? Colors.black87 : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
