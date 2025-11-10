import 'package:get/get.dart';

import '../../../api/cars/cars_apis.dart';
import '../../../model/cars/car_brand/car_brand.dart';

class BrandsController extends GetxController {
  final RxBool _isLoading = true.obs;
  final RxBool _isError = false.obs;
  final RxBool _isRefreshing = false.obs;
  final RxList<CarBrand> _brands = <CarBrand>[].obs;

  bool get isLoading => _isLoading.value;
  bool get isError => _isError.value;
  bool get isRefreshing => _isRefreshing.value;
  List<CarBrand> get brands => _brands;

  set isLoading(bool value) => _isLoading.value = value;
  set isError(bool value) => _isError.value = value;
  set isRefreshing(bool value) => _isRefreshing.value = value;
  set brands(List<CarBrand> value) => _brands.value = value;
  Future<void> fetchBrands({
    bool isRefresh = false,
  }) async {
    try {
      isError = false;

      isLoading = true;
      isRefreshing = false;

      final response = await CarsApis().getCarBrands();

      if (response.isSuccess) {
        brands = response.data ?? [];
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
    await fetchBrands(isRefresh: true);
  }

  void reset() {
    isLoading = true;
    isError = false;
    isRefreshing = false;
    brands.clear();
    brands = [];
  }
}
