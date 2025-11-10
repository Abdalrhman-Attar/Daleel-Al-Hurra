import 'package:get/get.dart';

import '../../../api/cars/cars_apis.dart';
import '../../../api/dealers/dealer_apis.dart';
import '../../../model/cars/car_brand/car_brand.dart';

class MyBrandsController extends GetxController {
  final RxBool _isLoading = true.obs;
  final RxBool _isError = false.obs;
  final RxBool _isRefreshing = false.obs;
  final RxList<CarBrand> _myBrands = <CarBrand>[].obs;
  final RxList<CarBrand> _allBrands = <CarBrand>[].obs;

  bool get isLoading => _isLoading.value;
  bool get isError => _isError.value;
  bool get isRefreshing => _isRefreshing.value;
  List<CarBrand> get myBrands => _myBrands;
  List<CarBrand> get allBrands => _allBrands;

  set isLoading(bool value) => _isLoading.value = value;
  set isError(bool value) => _isError.value = value;
  set isRefreshing(bool value) => _isRefreshing.value = value;
  set myBrands(List<CarBrand> value) => _myBrands.value = value;
  set allBrands(List<CarBrand> value) => _allBrands.value = value;
  Future<void> fetchAllData({
    bool isRefresh = false,
  }) async {
    try {
      isError = false;
      isLoading = true;
      isRefreshing = false;

      // Fetch both all brands and user's brands in parallel
      final futures = await Future.wait([
        CarsApis().getCarBrands(),
        DealerApis().getDealerBrands(),
      ]);

      final allBrandsResponse = futures[0];
      final myBrandsResponse = futures[1];

      if (allBrandsResponse.isSuccess && myBrandsResponse.isSuccess) {
        allBrands = allBrandsResponse.data ?? [];
        myBrands = myBrandsResponse.data ?? [];
      } else {
        isError = true;
      }
    } catch (e) {
      isError = true;
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchMyBrands({
    bool isRefresh = false,
  }) async {
    try {
      isError = false;
      isLoading = true;
      isRefreshing = false;

      final response = await DealerApis().getDealerBrands();

      if (response.isSuccess) {
        myBrands = response.data ?? [];
      } else {
        isError = true;
      }
    } catch (e) {
      isError = true;
    } finally {
      isLoading = false;
    }
  }

  Future<void> addBrand({
    required int brandId,
  }) async {
    try {
      isError = false;

      isLoading = true;
      isRefreshing = false;

      final response =
          await DealerApis().addDealerBrand(brandId: brandId.toString());

      if (response.isSuccess) {
        await fetchAllData(isRefresh: true);
      } else {
        isError = true;
      }
    } catch (e) {
      isError = true;
    } finally {
      isLoading = false;
    }
  }

  Future<void> removeBrand({
    required int brandId,
  }) async {
    try {
      isError = false;

      isLoading = true;
      isRefreshing = false;

      final response =
          await DealerApis().removeDealerBrand(brandId: brandId.toString());

      if (response.isSuccess) {
        await fetchAllData(isRefresh: true);
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
    await fetchAllData(isRefresh: true);
  }

  void reset() {
    isLoading = true;
    isError = false;
    isRefreshing = false;
    myBrands.clear();
    myBrands = [];
  }
}
