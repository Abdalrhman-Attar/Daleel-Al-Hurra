import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';

import '../../../common/widgets/shimmer/shimmer_components.dart';
import '../../../main.dart';
import '../../../utils/constants/colors.dart';
import '../../home/widgets/car_grid.dart';
import '../controllers/favorites_cars_controller.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with TickerProviderStateMixin {
  final FavoritesCarsController favoritesCarsController =
      Get.put(FavoritesCarsController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      favoritesCarsController.fetchCars();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('favorites'),
          style: TextStyle(color: MyColors.textPrimary),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          favoritesCarsController.isLoading = true;
          await Future.delayed(const Duration(seconds: 2));
          await favoritesCarsController.refresh();
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
                () => favoritesCarsController.isLoading
                    ? const CarGridShimmer()
                    : favoritesCarsController.cars.isEmpty
                        ? Center(child: Text(tr('no data found')))
                        : CarGrid(
                            filteredCars: favoritesCarsController.cars,
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
