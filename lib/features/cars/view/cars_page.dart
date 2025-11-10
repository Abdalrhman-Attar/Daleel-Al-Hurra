import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/shimmer/shimmer_components.dart';
import '../../../main.dart';
import '../../../utils/constants/colors.dart';
import '../../home/widgets/car_grid.dart';
import '../controllers/cars_page_controller.dart';

class CarsPage extends StatefulWidget {
  const CarsPage({
    super.key,
    this.title,
    this.brandId,
    this.brandModelId,
    this.carBodyTypeId,
    this.carCategoryId,
  });

  final String? title;
  final String? brandId;
  final String? brandModelId;
  final String? carBodyTypeId;
  final String? carCategoryId;

  @override
  State<CarsPage> createState() => _CarsPageState();
}

class _CarsPageState extends State<CarsPage> {
  final CarsPageController carsController = Get.put(CarsPageController());
  bool _isAppBarCollapsed = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(_scrollListener);

      carsController.selectedCarCategoryId = widget.carCategoryId != null ? int.parse(widget.carCategoryId!) : null;
      carsController.selectedCarBodyTypeId = widget.carBodyTypeId != null ? int.parse(widget.carBodyTypeId!) : null;
      carsController.selectedBrandId = widget.brandId != null ? int.parse(widget.brandId!) : null;
      carsController.selectedBrandModelId = widget.brandModelId != null ? int.parse(widget.brandModelId!) : null;

      carsController.fetchCars();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() async {
    final currentlyCollapsed = _scrollController.offset > 100;
    if (_isAppBarCollapsed != currentlyCollapsed) {
      setState(() {
        _isAppBarCollapsed = currentlyCollapsed;
      });
    }

    // if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
    //   if (productsController.hasMorePagesCategory.value && !productsController.isLoadingMore.value) {
    //     await productsController.getFeaturedProducts(loadMore: true);
    //   }
    // }
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title ?? 'CARS',
          style: TextStyle(
            color: MyColors.textPrimary,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          carsController.isLoading = true;
          await Future.delayed(const Duration(seconds: 2));
          await carsController.refresh();
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
              carsController.loadMoreCars();
            }
            return true;
          },
          child: ListView(
            padding: const EdgeInsets.only(top: 4),
            children: [
              // GlobalTextFormField(
              //   hint: 'Search',
              //   controller: searchController,
              //   keyboardType: TextInputType.text,
              //   prefixIcon: Padding(
              //     padding: const EdgeInsets.all(12.0),
              //     child: const DynamicIconViewer(
              //       filePath: MyIcons.search,
              //       size: 18,
              //       color: MyColors.grey,
              //     ),
              //   ),
              // ),

              Obx(
                () => carsController.isLoading
                    ? const CarGridShimmer()
                    : carsController.cars.isEmpty
                        ? Center(child: Text(tr('no data found')))
                        : Column(
                            children: [
                              CarGrid(
                                filteredCars: carsController.cars,
                              ),
                              // Loading indicator for pagination
                              if (carsController.isLoadingMore)
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  child: const Center(
                                    child: LoadingShimmer(),
                                  ),
                                ),
                              // No more data indicator
                              if (!carsController.hasMorePages && carsController.cars.isNotEmpty)
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

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
