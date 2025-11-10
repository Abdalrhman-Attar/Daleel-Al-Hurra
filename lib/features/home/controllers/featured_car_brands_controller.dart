import 'package:get/get.dart';

import '../../../api/cars/cars_apis.dart';
import '../../../model/cars/car_brand/car_brand.dart';

class FeaturedCarBrandsController extends GetxController {
  final RxBool _isLoading = true.obs;
  final RxBool _isError = false.obs;
  final RxBool _isRefreshing = false.obs;
  final RxList<CarBrand> _featuredCarBrands = <CarBrand>[].obs;

  bool get isLoading => _isLoading.value;
  bool get isError => _isError.value;
  bool get isRefreshing => _isRefreshing.value;
  List<CarBrand> get featuredCarBrands => _featuredCarBrands;

  set isLoading(bool value) => _isLoading.value = value;
  set isError(bool value) => _isError.value = value;
  set isRefreshing(bool value) => _isRefreshing.value = value;
  set featuredCarBrands(List<CarBrand> value) =>
      _featuredCarBrands.value = value;
  Future<void> fetchFeaturedCarBrands({
    bool isRefresh = false,
  }) async {
    try {
      isError = false;

      isLoading = true;
      isRefreshing = false;

      final response = await CarsApis().getCarBrands(featured: true);

      if (response.isSuccess) {
        featuredCarBrands = response.data ?? [];
      } else {
        isError = true;
      }
    } catch (e) {
      isError = true;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> refresh() async {
    await fetchFeaturedCarBrands(isRefresh: true);
  }

  void reset() {
    isLoading = true;
    isError = false;
    isRefreshing = false;
    featuredCarBrands.clear();
    featuredCarBrands = [];
  }
}
