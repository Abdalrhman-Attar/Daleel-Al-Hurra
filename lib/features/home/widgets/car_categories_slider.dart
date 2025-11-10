import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../main.dart';

import '../../../module/global_image.dart';
import '../../../utils/constants/enums.dart';
import '../../cars/view/cars_page.dart';
import '../controllers/featured_car_categories_controller.dart';

class CarCategoriesSlider extends StatelessWidget {
  CarCategoriesSlider({super.key});
  final FeaturedCarCategoriesController featuredCarCategoriesController =
      Get.put(FeaturedCarCategoriesController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => featuredCarCategoriesController.featuredCarCategories.isEmpty &&
              !featuredCarCategoriesController.isLoading
          ? Center(child: Text(tr('no data found')))
          : CarouselSlider.builder(
              itemCount:
                  featuredCarCategoriesController.featuredCarCategories.isEmpty
                      ? 4
                      : featuredCarCategoriesController
                          .featuredCarCategories.length,
              options: CarouselOptions(
                height: 180,
                enlargeCenterPage: true,
                enlargeFactor: 0.25,
                viewportFraction: 0.425,
                autoPlay: !featuredCarCategoriesController.isLoading,
                autoPlayInterval: const Duration(seconds: 3),
                enableInfiniteScroll:
                    !featuredCarCategoriesController.isLoading,
                scrollPhysics: const BouncingScrollPhysics(),
              ),
              itemBuilder: (context, index, realIdx) {
                if (featuredCarCategoriesController
                    .featuredCarCategories.isEmpty) {
                  // Show skeleton for loading state
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 80,
                          height: 18,
                          color: Colors.grey[200],
                        ),
                      ],
                    ),
                  );
                }

                final carCategory = featuredCarCategoriesController
                    .featuredCarCategories[index];
                return InkWell(
                  onTap: () {
                    // Handle tap on car type
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CarsPage(carCategoryId: carCategory.id.toString()),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        clipBehavior: Clip.none,
                        child: Center(
                          child: Column(
                            children: [
                              Flexible(
                                child: GlobalImage(
                                  type: ImageType.network,
                                  url: carCategory.imageUrl ?? '',
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height:
                                      MediaQuery.of(context).size.width * 0.4,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Text(
                                carCategory.name ?? '',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
