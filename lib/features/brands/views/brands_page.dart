import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/app_bar_logo.dart';
import '../../../common/widgets/shimmer/shimmer_components.dart';
import '../../../main.dart';
import '../controllers/brands_controller.dart';
import '../widgets/brands_grid.dart';

class BrandsPage extends StatefulWidget {
  const BrandsPage({super.key});

  @override
  State<BrandsPage> createState() => _BrandsPageState();
}

class _BrandsPageState extends State<BrandsPage> {
  final BrandsController brandsController = Get.put(BrandsController());
  bool _isAppBarCollapsed = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(_scrollListener);
      brandsController.fetchBrands();
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
        title: const AppBarLogo(),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          brandsController.isLoading = true;
          await Future.delayed(const Duration(seconds: 2));
          await brandsController.refresh();
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification && notification.metrics.pixels >= notification.metrics.maxScrollExtent - 200) {}
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
                () => brandsController.isLoading
                    ? const BrandGridShimmer()
                    : brandsController.brands.isEmpty
                        ? Center(child: Text(tr('no data found')))
                        : BrandsGrid(brands: brandsController.brands),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
