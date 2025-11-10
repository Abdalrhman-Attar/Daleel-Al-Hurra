import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/shimmer/shimmer_components.dart';
import '../../../main.dart';
import '../../../model/cars/car_brand/car_brand.dart';
import '../../../module/global_drop_down.dart';
import '../../home/widgets/car_grid.dart';
import '../controllers/brand_models_controller.dart';

class BrandModelsPage extends StatefulWidget {
  const BrandModelsPage({
    super.key,
    required this.brand,
    this.dealerId,
  });

  final CarBrand brand;
  final int? dealerId;

  @override
  State<BrandModelsPage> createState() => _BrandModelsPageState();
}

class _BrandModelsPageState extends State<BrandModelsPage> {
  final BrandModelsController brandModelsController = Get.put(BrandModelsController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      brandModelsController.brandId = widget.brand.id ?? 0;
      brandModelsController.dealerId = widget.dealerId;
      brandModelsController.fetchBrandModels(brandId: widget.brand.id ?? 0);
      brandModelsController.fetchCars();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.brand.name ?? tr('brand models')),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await brandModelsController.refresh();
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
              brandModelsController.loadMoreCars();
            }
            return true;
          },
          child: ListView(
            padding: const EdgeInsets.only(top: 4),
            children: [
              // Brand Models Filter
              Obx(() {
                if (brandModelsController.brandModels.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: GlobalDropdown<String>(
                    label: tr('brand models'),
                    hint: tr('select brand model'),
                    items: [
                      DropdownItem<String>(
                        value: '',
                        label: tr('all models'),
                      ),
                      ...brandModelsController.brandModels.map((model) => DropdownItem<String>(
                            value: model.id.toString(),
                            label: model.name ?? '',
                          )),
                    ],
                    selectedValues: brandModelsController.selectedBrandModelIds,
                    onMultiChanged: (value) {
                      brandModelsController.selectedBrandModelIds = value;
                      brandModelsController.fetchCars();
                    },
                    height: 48,
                    enableSearch: true,
                    multiSelect: true,
                    borderRadius: BorderRadius.circular(8),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                );
              }),

              // Cars Grid
              Obx(() {
                if (brandModelsController.isLoading) {
                  return const CarGridShimmer();
                }

                if (brandModelsController.cars.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.directions_car_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            tr('no cars found'),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    CarGrid(
                      filteredCars: brandModelsController.cars,
                    ),
                    // Loading indicator for pagination
                    if (brandModelsController.isLoadingMore)
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: const Center(
                          child: LoadingShimmer(),
                        ),
                      ),
                    // No more data indicator
                    if (!brandModelsController.hasMorePages && brandModelsController.cars.isNotEmpty)
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
                );
              }),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
