import 'package:get/get.dart';

import '../../../api/cars/cars_apis.dart';
import '../../../model/cars/car/car.dart';

class FeaturedCarsController extends GetxController {
  final RxBool _isLoading = true.obs;
  final RxBool _isError = false.obs;
  final RxBool _isRefreshing = false.obs;
  final Rx<int?> _selectedCarBodyType = Rx<int?>(null);
  final RxList<Car> _featuredCars = <Car>[].obs;

  bool get isLoading => _isLoading.value;
  bool get isError => _isError.value;
  bool get isRefreshing => _isRefreshing.value;
  int? get selectedCarBodyType => _selectedCarBodyType.value;
  List<Car> get featuredCars => _featuredCars;

  set isLoading(bool value) => _isLoading.value = value;
  set isError(bool value) => _isError.value = value;
  set isRefreshing(bool value) => _isRefreshing.value = value;
  set featuredCars(List<Car> value) => _featuredCars.value = value;
  set selectedCarBodyType(int? value) => _selectedCarBodyType.value = value;
  Future<void> fetchFeaturedCars({
    bool isRefresh = false,
  }) async {
    try {
      isError = false;

      isLoading = true;
      isRefreshing = false;

      final response = await CarsApis().getCars(
        featured: true,
        bodyTypeId: selectedCarBodyType?.toString(),
        perPage: 30,
        page: 1,
      );

      if (response.isSuccess) {
        featuredCars = response.data ?? [];
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
    await fetchFeaturedCars(isRefresh: true);
  }

  void reset() {
    isLoading = true;
    isError = false;
    isRefreshing = false;
    featuredCars.clear();
    featuredCars = [];
  }
}
