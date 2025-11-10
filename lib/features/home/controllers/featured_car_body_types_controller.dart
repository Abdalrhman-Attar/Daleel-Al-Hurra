import 'package:get/get.dart';

import '../../../api/cars/cars_apis.dart';
import '../../../model/cars/car_body_type/car_body_type.dart';

class FeaturedCarBodyTypesController extends GetxController {
  final RxBool _isLoading = true.obs;
  final RxBool _isError = false.obs;
  final RxBool _isRefreshing = false.obs;
  final RxList<CarBodyType> _featuredCarBodyTypes = <CarBodyType>[].obs;

  bool get isLoading => _isLoading.value;
  bool get isError => _isError.value;
  bool get isRefreshing => _isRefreshing.value;
  List<CarBodyType> get featuredCarBodyTypes => _featuredCarBodyTypes;

  set isLoading(bool value) => _isLoading.value = value;
  set isError(bool value) => _isError.value = value;
  set isRefreshing(bool value) => _isRefreshing.value = value;
  set featuredCarBodyTypes(List<CarBodyType> value) =>
      _featuredCarBodyTypes.value = value;
  Future<void> fetchFeaturedCarBodyTypes({
    bool isRefresh = false,
  }) async {
    try {
      isError = false;

      isLoading = true;
      isRefreshing = false;

      final response = await CarsApis().getCarBodyTypes(featured: true);

      if (response.isSuccess) {
        featuredCarBodyTypes = response.data ?? [];
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
    await fetchFeaturedCarBodyTypes(isRefresh: true);
  }

  void reset() {
    isLoading = true;
    isError = false;
    isRefreshing = false;
    featuredCarBodyTypes.clear();
    featuredCarBodyTypes = [];
  }
}
