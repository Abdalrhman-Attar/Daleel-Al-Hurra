import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/app_bar_logo.dart';
import '../../../common/widgets/shimmer/banner_slider_shimmer.dart';
import '../../../common/widgets/shimmer/shimmer_components.dart';
import '../../../main.dart';
import '../../../module/global_choice_chip.dart';
import '../../../module/global_icon_button.dart';
import '../../../utils/constants/colors.dart';
import '../../favorites/views/favorites_page.dart';
import '../controllers/featured_carS_controller.dart';
import '../controllers/featured_car_body_types_controller.dart';
import '../controllers/featured_car_brands_controller.dart';
import '../controllers/featured_car_categories_controller.dart';
import '../controllers/slider_controller.dart';
import '../widgets/Slider_banner.dart';
import '../widgets/car_brands_grid.dart';
import '../widgets/car_categories_slider.dart';
import '../widgets/car_grid.dart';
import '../widgets/section_title.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FeaturedCarCategoriesController featuredCarCategoriesController =
      Get.put(FeaturedCarCategoriesController());
  final FeaturedCarBrandsController featuredCarBrandsController =
      Get.put(FeaturedCarBrandsController());
  final FeaturedCarBodyTypesController featuredCarBodyTypesController =
      Get.put(FeaturedCarBodyTypesController());
  final FeaturedCarsController featuredCarsController =
      Get.put(FeaturedCarsController());
  final SliderController featuredSliderController = Get.put(SliderController());

  @override
  void initState() {
    super.initState();

    // Use addPostFrameCallback to defer API calls until after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      featuredCarCategoriesController.fetchFeaturedCarCategories();
      featuredCarBrandsController.fetchFeaturedCarBrands();
      featuredCarBodyTypesController.fetchFeaturedCarBodyTypes();
      featuredCarsController.fetchFeaturedCars();
      featuredSliderController.fetchSliders();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarLogo(),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                GlobalIconButton(
                  iconData: Icons.favorite,
                  borderRadius: BorderRadius.circular(50.0),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const FavoritesPage(),
                      ),
                    );
                  },
                  iconColor: MyColors.primary,
                  buttonSize: 35.0,
                  iconSize: 25.0,
                ),
              ],
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          featuredCarCategoriesController.isLoading = true;
          featuredCarBrandsController.isLoading = true;
          featuredCarBodyTypesController.isLoading = true;
          featuredCarsController.isLoading = true;
          await Future.delayed(const Duration(seconds: 2));
          await featuredCarCategoriesController.refresh();
          await featuredCarBrandsController.refresh();
          await featuredCarBodyTypesController.refresh();
          await featuredCarsController.refresh();
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification &&
                notification.metrics.pixels >=
                    notification.metrics.maxScrollExtent - 200) {}
            return false;
          },
          child: ListView(
            padding: const EdgeInsets.only(top: 4),
            children: [
              SectionTitle(tr('car categories')),
              const SizedBox(height: 8),
              Obx(() => featuredCarCategoriesController.isLoading
                  ? const CategorySliderShimmer()
                  : CarCategoriesSlider()),
              const SizedBox(height: 16),
              //? Slider banner
              Obx(() => featuredCarCategoriesController.isLoading
                  ? const BannerSliderShimmer()
                  : SliderBanner()),
              const SizedBox(height: 16),
              SectionTitle(tr('car brands')),
              const SizedBox(height: 8),
              Obx(() => featuredCarBrandsController.isLoading
                  ? const BrandGridShimmer()
                  : featuredCarBrandsController.featuredCarBrands.isEmpty
                      ? Center(child: Text(tr('no data found')))
                      : CarBrandsGrid(
                          brands:
                              featuredCarBrandsController.featuredCarBrands)),
              const SizedBox(height: 8),
              SectionTitle(tr('browse cars')),
              const SizedBox(height: 8),
              Obx(() => featuredCarBodyTypesController.isLoading
                  ? const ChoiceChipsShimmer()
                  : featuredCarBodyTypesController.featuredCarBodyTypes.isEmpty
                      ? Center(child: Text(tr('no data found')))
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Obx(() => GlobalChoiceChip(
                                    label: tr('all'),
                                    selected: featuredCarsController
                                            .selectedCarBodyType ==
                                        null,
                                    onSelected: (_) {
                                      featuredCarsController
                                          .selectedCarBodyType = null;
                                      featuredCarsController
                                          .fetchFeaturedCars();
                                    },
                                    selectedColor: MyColors.primary,
                                    backgroundColor: MyColors.cardBackground,
                                    labelStyle: TextStyle(
                                      color: featuredCarsController
                                                  .selectedCarBodyType ==
                                              null
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )),
                            ),
                            ...featuredCarBodyTypesController
                                .featuredCarBodyTypes
                                .map((bodyType) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Obx(() {
                                  final isSelected = bodyType.id ==
                                      featuredCarsController
                                          .selectedCarBodyType;
                                  return GlobalChoiceChip(
                                    label: bodyType.name ?? tr('all'),
                                    selected: isSelected,
                                    onSelected: (_) {
                                      if (bodyType.id != null) {
                                        featuredCarsController
                                            .selectedCarBodyType = bodyType.id;
                                        featuredCarsController
                                            .fetchFeaturedCars();
                                      }
                                    },
                                    selectedColor: MyColors.primary,
                                    backgroundColor: MyColors.cardBackground,
                                    labelStyle: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                }),
                              );
                            }),
                          ]),
                        )),
              const SizedBox(height: 8),
              Obx(() => featuredCarsController.isLoading
                  ? const CarGridShimmer()
                  : featuredCarsController.featuredCars.isEmpty
                      ? Center(child: Text(tr('no data found')))
                      : CarGrid(
                          filteredCars: featuredCarsController.featuredCars)),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
