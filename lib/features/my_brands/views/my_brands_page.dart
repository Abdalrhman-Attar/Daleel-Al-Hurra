import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/app_bar_logo.dart';
import '../../../common/widgets/shimmer/shimmer_components.dart';
import '../../../main.dart';
import '../controllers/my_brands_controller.dart';
import '../widgets/selectable_brands_grid.dart';

class MyBrandsPage extends StatefulWidget {
  const MyBrandsPage({super.key});

  @override
  State<MyBrandsPage> createState() => _MyBrandsPageState();
}

class _MyBrandsPageState extends State<MyBrandsPage> {
  final MyBrandsController myBrandsController = Get.put(MyBrandsController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      myBrandsController.fetchAllData();
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
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          myBrandsController.isLoading = true;
          await Future.delayed(const Duration(seconds: 2));
          await myBrandsController.refresh();
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
              //       color: MyColors.grey,s
              //     ),
              //   ),
              // ),

              Obx(
                () => myBrandsController.isLoading
                    ? const BrandGridShimmer()
                    : myBrandsController.allBrands.isEmpty
                        ? Center(child: Text(tr('no brands found')))
                        : SelectableBrandsGrid(
                            allBrands: myBrandsController.allBrands,
                            selectedBrands: myBrandsController.myBrands,
                            onBrandTap: (brand) async {
                              if (brand.id == null) return;

                              final isSelected = myBrandsController.myBrands
                                  .any((selectedBrand) =>
                                      selectedBrand.id == brand.id);

                              if (isSelected) {
                                await myBrandsController.removeBrand(
                                    brandId: brand.id!);
                              } else {
                                await myBrandsController.addBrand(
                                    brandId: brand.id!);
                              }
                            },
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
