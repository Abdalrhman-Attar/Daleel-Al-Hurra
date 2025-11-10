import 'package:get/get.dart';

import '../../../api/cars/cars_apis.dart';
import '../../../model/cars/car_category/car_category.dart';

class FeaturedCarCategoriesController extends GetxController {
  final RxBool _isLoading = true.obs;
  final RxBool _isError = false.obs;
  final RxBool _isRefreshing = false.obs;
  final RxList<CarCategory> _featuredCarCategories = <CarCategory>[].obs;

  bool get isLoading => _isLoading.value;
  bool get isError => _isError.value;
  bool get isRefreshing => _isRefreshing.value;
  List<CarCategory> get featuredCarCategories => _featuredCarCategories;

  set isLoading(bool value) => _isLoading.value = value;
  set isError(bool value) => _isError.value = value;
  set isRefreshing(bool value) => _isRefreshing.value = value;
  set featuredCarCategories(List<CarCategory> value) =>
      _featuredCarCategories.value = value;
  Future<void> fetchFeaturedCarCategories({
    bool isRefresh = false,
  }) async {
    try {
      isError = false;

      isLoading = true;
      isRefreshing = false;

      final response = await CarsApis().getCarCategories(featured: true);

      if (response.isSuccess) {
        featuredCarCategories = response.data ?? [];
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
    await fetchFeaturedCarCategories(isRefresh: true);
  }

  void reset() {
    isLoading = true;
    isError = false;
    isRefreshing = false;
    featuredCarCategories.clear();
    featuredCarCategories = [];
  }
}
