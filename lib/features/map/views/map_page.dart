import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../common/widgets/app_bar_logo.dart';
import '../../../main.dart';
import '../../../utils/constants/colors.dart';
import '../../dealer_details/views/dealer_details_page.dart';
import '../controllers/map_controller.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final MapPageController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MapPageController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarLogo(),
        centerTitle: true,
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refresh(),
            tooltip: tr('refresh'),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  tr('loading'),
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? MyColors.textSecondaryDark : MyColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.isError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: MyColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  tr('error loading data'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness == Brightness.dark ? MyColors.textPrimaryDark : MyColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tr('please try again'),
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? MyColors.textSecondaryDark : MyColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => controller.fetchDealers(),
                  icon: const Icon(Icons.refresh),
                  label: Text(tr('retry')),
                ),
              ],
            ),
          );
        }

        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: MapPageController.initialPosition,
              markers: controller.markers,
              onMapCreated: (GoogleMapController mapController) {
                controller.onMapCreated(mapController);
              },
              myLocationButtonEnabled: true,
              myLocationEnabled: false, // No location permission needed
              zoomControlsEnabled: true,
              mapToolbarEnabled: true,
              compassEnabled: true,
              onTap: (_) {
                // Dismiss any open info windows
              },
              mapType: MapType.normal,
            ),

            // Dealer count badge
            if (controller.dealers.isNotEmpty)
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark ? MyColors.containerDark : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.store,
                        size: 20,
                        color: MyColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${controller.dealers.length} ${tr('dealers')}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).brightness == Brightness.dark ? MyColors.textPrimaryDark : MyColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // No dealers found message
            if (controller.dealers.isEmpty && !controller.isLoading)
              Positioned(
                top: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark ? MyColors.containerDark : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      tr('no data found'),
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark ? MyColors.textSecondaryDark : MyColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        );
      }),

      // Dealer list bottom sheet
      bottomSheet: Obx(() {
        if (controller.dealers.isEmpty || controller.isLoading) {
          return const SizedBox.shrink();
        }

        return DraggableScrollableSheet(
          initialChildSize: 0.15,
          minChildSize: 0.15,
          maxChildSize: 0.6,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? MyColors.surfaceDark : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark ? MyColors.textSecondaryDark : MyColors.textSecondary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.store,
                          color: MyColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          tr('dealers'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).brightness == Brightness.dark ? MyColors.textPrimaryDark : MyColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${controller.dealers.length}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: MyColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Divider(height: 1),

                  // Dealer list
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.dealers.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final dealer = controller.dealers[index];
                        return _buildDealerListItem(dealer);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildDealerListItem(dealer) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DealerDetailsPage(dealer: dealer),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? MyColors.containerDark : MyColors.container,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark ? MyColors.borderDark : MyColors.border,
          ),
        ),
        child: Row(
          children: [
            // Dealer logo
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: MyColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: dealer.logo != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        dealer.logo!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.store,
                            color: MyColors.primary,
                          );
                        },
                      ),
                    )
                  : Icon(
                      Icons.store,
                      color: MyColors.primary,
                    ),
            ),

            const SizedBox(width: 12),

            // Dealer info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dealer.storeName ?? '${dealer.firstName} ${dealer.lastName}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Theme.of(context).brightness == Brightness.dark ? MyColors.textPrimaryDark : MyColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (dealer.address != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Theme.of(context).brightness == Brightness.dark ? MyColors.textSecondaryDark : MyColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            dealer.address!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).brightness == Brightness.dark ? MyColors.textSecondaryDark : MyColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Navigate button
            IconButton(
              icon: Icon(
                Icons.navigation,
                color: MyColors.primary,
              ),
              onPressed: () {
                controller.moveToDealer(dealer);
              },
              tooltip: tr('show on map'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<MapPageController>();
    super.dispose();
  }
}
