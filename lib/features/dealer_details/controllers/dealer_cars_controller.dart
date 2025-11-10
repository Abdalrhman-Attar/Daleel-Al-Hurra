import 'package:get/get.dart';

import '../../../api/cars/cars_apis.dart';
import '../../../model/cars/car/car.dart';

class DealerCarsController extends GetxController {
  final RxBool _isLoading = true.obs;
  final RxBool _isError = false.obs;
  final RxBool _isRefreshing = false.obs;
  final Rx<int?> _selectedCarBodyType = Rx<int?>(null);
  final Rx<int?> _dealerId = Rx<int?>(null);
  final RxList<Car> _dealerCars = <Car>[].obs;
  final RxBool _hasMorePages = true.obs;
  final RxBool _isLoadingMore = false.obs;
  final Rx<int?> _page = 1.obs;
  final Rx<int?> _perPage = 10.obs;

  bool get isLoading => _isLoading.value;
  bool get isError => _isError.value;
  bool get isRefreshing => _isRefreshing.value;
  int? get selectedCarBodyType => _selectedCarBodyType.value;
  int? get dealerId => _dealerId.value;
  List<Car> get dealerCars => _dealerCars;
  bool get hasMorePages => _hasMorePages.value;
  bool get isLoadingMore => _isLoadingMore.value;
  int? get page => _page.value;
  int? get perPage => _perPage.value;

  set isLoading(bool value) => _isLoading.value = value;
  set isError(bool value) => _isError.value = value;
  set isRefreshing(bool value) => _isRefreshing.value = value;
  set dealerCars(List<Car> value) => _dealerCars.value = value;
  set selectedCarBodyType(int? value) => _selectedCarBodyType.value = value;
  set dealerId(int? value) => _dealerId.value = value;
  set hasMorePages(bool value) => _hasMorePages.value = value;
  set isLoadingMore(bool value) => _isLoadingMore.value = value;
  set page(int? value) => _page.value = value;
  set perPage(int? value) => _perPage.value = value;

  Future<void> loadMoreCars() async {
    if (!hasMorePages || isLoadingMore) return;

    isLoadingMore = true;
    page = (page ?? 1) + 1;

    try {
      final response = await CarsApis().getCars(
        bodyTypeId: selectedCarBodyType?.toString(),
        dealerId: dealerId?.toString(),
        page: page,
        perPage: perPage,
      );

      if (response.isSuccess) {
        final newCars = response.data ?? [];
        if (newCars.length < (perPage ?? 10)) {
          hasMorePages = false;
        }
        dealerCars.addAll(newCars);
      }
    } catch (e) {
      isError = true;
    } finally {
      isLoadingMore = false;
    }
  }

  Future<void> fetchDealerCars({
    bool isRefresh = false,
  }) async {
    try {
      isError = false;

      if (isRefresh) {
        isRefreshing = true;
        page = 1;
        hasMorePages = true;
        dealerCars.clear();
      } else {
        isLoading = true;
        page = 1;
        hasMorePages = true;
        dealerCars.clear();
      }

      final response = await CarsApis().getCars(
        bodyTypeId: selectedCarBodyType?.toString(),
        dealerId: dealerId?.toString(),
        page: page,
        perPage: perPage,
      );

      if (response.isSuccess) {
        final newCars = response.data ?? [];
        dealerCars = newCars;

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

  @override
  Future<void> refresh() async {
    await fetchDealerCars(isRefresh: true);
  }

  void reset() {
    isLoading = true;
    isError = false;
    isRefreshing = false;
    dealerCars.clear();
    dealerCars = [];
    selectedCarBodyType = null;
    dealerId = null;

    // Reset pagination state
    page = 1;
    hasMorePages = true;
    isLoadingMore = false;
  }
}
