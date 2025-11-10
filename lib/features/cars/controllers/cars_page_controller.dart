import 'package:get/get.dart';

import '../../../api/cars/cars_apis.dart';
import '../../../model/cars/car/car.dart';

class CarsPageController extends GetxController {
  final RxBool _isLoading = true.obs;
  final RxBool _isError = false.obs;
  final RxBool _isRefreshing = false.obs;
  final Rx<int?> _selectedCarCategoryId = Rx<int?>(null);
  final Rx<int?> _selectedCarBodyTypeId = Rx<int?>(null);
  final Rx<int?> _selectedBrandId = Rx<int?>(null);
  final Rx<int?> _selectedBrandModelId = Rx<int?>(null);
  final RxList<Car> _cars = <Car>[].obs;
  final RxBool _hasMorePages = true.obs;
  final RxBool _isLoadingMore = false.obs;
  final Rx<int?> _page = 1.obs;
  final Rx<int?> _perPage = 10.obs;

  bool get isLoading => _isLoading.value;
  bool get isError => _isError.value;
  bool get isRefreshing => _isRefreshing.value;
  int? get selectedCarCategoryId => _selectedCarCategoryId.value;
  int? get selectedCarBodyTypeId => _selectedCarBodyTypeId.value;
  int? get selectedBrandId => _selectedBrandId.value;
  int? get selectedBrandModelId => _selectedBrandModelId.value;
  List<Car> get cars => _cars;
  bool get hasMorePages => _hasMorePages.value;
  bool get isLoadingMore => _isLoadingMore.value;
  int? get page => _page.value;
  int? get perPage => _perPage.value;

  set isLoading(bool value) => _isLoading.value = value;
  set isError(bool value) => _isError.value = value;
  set isRefreshing(bool value) => _isRefreshing.value = value;
  set cars(List<Car> value) => _cars.value = value;
  set selectedCarCategoryId(int? value) => _selectedCarCategoryId.value = value;
  set selectedCarBodyTypeId(int? value) => _selectedCarBodyTypeId.value = value;
  set selectedBrandId(int? value) => _selectedBrandId.value = value;
  set selectedBrandModelId(int? value) => _selectedBrandModelId.value = value;
  set hasMorePages(bool value) => _hasMorePages.value = value;
  set isLoadingMore(bool value) => _isLoadingMore.value = value;
  set page(int? value) => _page.value = value;
  set perPage(int? value) => _perPage.value = value;
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
        bodyTypeId: selectedCarBodyTypeId?.toString(),
        categoryId: selectedCarCategoryId?.toString(),
        brandId: selectedBrandId?.toString(),
        brandModelId: selectedBrandModelId?.toString(),
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
        bodyTypeId: selectedCarBodyTypeId?.toString(),
        categoryId: selectedCarCategoryId?.toString(),
        brandId: selectedBrandId?.toString(),
        brandModelId: selectedBrandModelId?.toString(),
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
    await fetchCars(isRefresh: true);
  }

  void reset() {
    isLoading = true;
    isError = false;
    isRefreshing = false;
    selectedCarCategoryId = null;
    selectedCarBodyTypeId = null;
    selectedBrandId = null;
    selectedBrandModelId = null;
    cars.clear();
    cars = [];

    // Reset pagination state
    page = 1;
    hasMorePages = true;
    isLoadingMore = false;
  }
}
