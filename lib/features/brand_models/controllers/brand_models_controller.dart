import 'package:get/get.dart';

import '../../../api/cars/cars_apis.dart';
import '../../../model/cars/brand_model/brand_model.dart';
import '../../../model/cars/car/car.dart';

class BrandModelsController extends GetxController {
  final RxBool _isLoading = true.obs;
  final RxBool _isError = false.obs;
  final RxBool _isRefreshing = false.obs;
  final RxBool _isLoadingMore = false.obs;
  final RxBool _hasMorePages = true.obs;
  final RxInt _brandId = 0.obs;
  final Rx<int?> _dealerId = Rx<int?>(null);
  final RxList<BrandModel> _brandModels = <BrandModel>[].obs;
  final RxList<Car> _cars = <Car>[].obs;
  final Rx<List<String>?> _selectedBrandModelIds = Rx<List<String>?>(null);
  final Rx<int?> _page = 1.obs;
  final Rx<int?> _perPage = 10.obs;

  bool get isLoading => _isLoading.value;
  bool get isError => _isError.value;
  bool get isRefreshing => _isRefreshing.value;
  bool get isLoadingMore => _isLoadingMore.value;
  bool get hasMorePages => _hasMorePages.value;
  int get brandId => _brandId.value;
  int? get dealerId => _dealerId.value;
  List<BrandModel> get brandModels => _brandModels;
  List<Car> get cars => _cars;
  List<String>? get selectedBrandModelIds => _selectedBrandModelIds.value;
  int? get page => _page.value;
  int? get perPage => _perPage.value;

  set isLoading(bool value) => _isLoading.value = value;
  set isError(bool value) => _isError.value = value;
  set isRefreshing(bool value) => _isRefreshing.value = value;
  set isLoadingMore(bool value) => _isLoadingMore.value = value;
  set hasMorePages(bool value) => _hasMorePages.value = value;
  set brandId(int value) => _brandId.value = value;
  set dealerId(int? value) => _dealerId.value = value;
  set brandModels(List<BrandModel> value) => _brandModels.value = value;
  set cars(List<Car> value) => _cars.value = value;
  set selectedBrandModelIds(List<String>? value) =>
      _selectedBrandModelIds.value = value;
  set page(int? value) => _page.value = value;
  set perPage(int? value) => _perPage.value = value;
  Future<void> fetchBrandModels({
    bool isRefresh = false,
    required int brandId,
  }) async {
    try {
      isError = false;

      isLoading = true;
      isRefreshing = false;

      final response =
          await CarsApis().getBrandModels(brandId: brandId.toString());

      if (response.isSuccess) {
        brandModels = response.data ?? [];
      } else {
        isError = true;
      }
    } catch (e) {
      isError = true;
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchCars({
    bool isRefresh = false,
  }) async {
    try {
      isError = false;

      if (isRefresh) {
        isRefreshing = true;
        page = 1;
        hasMorePages = true;
        cars.clear();
      } else {
        isLoading = true;
        page = 1;
        hasMorePages = true;
        cars.clear();
      }

      final response = await CarsApis().getCars(
        brandId: brandId.toString(),
        brandModelId: selectedBrandModelIds?.isEmpty ?? true
            ? null
            : selectedBrandModelIds?.join(','),
        dealerId: dealerId?.toString(),
        page: page,
        perPage: perPage,
      );

      if (response.isSuccess) {
        final newCars = response.data ?? [];
        cars = newCars;

        // Check if we have more pages
        if (newCars.length < (perPage ?? 10)) {
          hasMorePages = false;
        }
      } else {
        isError = true;
      }
    } catch (e) {
      isError = true;
    } finally {
      isLoading = false;
      isRefreshing = false;
    }
  }

  Future<void> loadMoreCars() async {
    if (!hasMorePages || isLoadingMore) return;

    isLoadingMore = true;
    page = (page ?? 1) + 1;

    try {
      final response = await CarsApis().getCars(
        brandId: brandId.toString(),
        brandModelId: selectedBrandModelIds?.isEmpty ?? true
            ? null
            : selectedBrandModelIds?.join(','),
        dealerId: dealerId?.toString(),
        page: page,
        perPage: perPage,
      );

      if (response.isSuccess) {
        final newCars = response.data ?? [];
        if (newCars.length < (perPage ?? 10)) {
          hasMorePages = false;
        }
        cars.addAll(newCars);
      }
    } catch (e) {
      isError = true;
    } finally {
      isLoadingMore = false;
    }
  }

  @override
  Future<void> refresh() async {
    await fetchBrandModels(isRefresh: true, brandId: brandId);
    await fetchCars(isRefresh: true);
  }

  void reset() {
    isLoading = true;
    isError = false;
    isRefreshing = false;
    brandModels.clear();
    brandModels = [];
    cars.clear();
    selectedBrandModelIds = [];
    page = 1;
    hasMorePages = true;
    isLoadingMore = false;
  }
}
