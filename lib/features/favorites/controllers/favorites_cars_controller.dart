import 'package:get/get.dart';

import '../../../api/cars/cars_apis.dart';
import '../../../model/cars/car/car.dart';
import '../../../stores/user_data_store.dart';

class FavoritesCarsController extends GetxController {
  final RxBool _isLoading = true.obs;
  final RxBool _isError = false.obs;
  final RxBool _isRefreshing = false.obs;
  final RxList<Car> _cars = <Car>[].obs;

  bool get isLoading => _isLoading.value;
  bool get isError => _isError.value;
  bool get isRefreshing => _isRefreshing.value;
  List<Car> get cars => _cars;

  set isLoading(bool value) => _isLoading.value = value;
  set isError(bool value) => _isError.value = value;
  set isRefreshing(bool value) => _isRefreshing.value = value;
  set cars(List<Car> value) => _cars.value = value;
  Future<void> fetchCars({
    bool isRefresh = false,
  }) async {
    try {
      isError = false;

      isLoading = true;
      isRefreshing = false;

      final favoriteCars = Get.find<UserDataStore>().favoriteCars;

      final response = await CarsApis().getCars();

      if (response.isSuccess) {
        if (favoriteCars.isNotEmpty) {
          cars = response.data
                  ?.where((car) => favoriteCars.contains(car.id))
                  .toList() ??
              [];
        } else {
          cars = [];
        }
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
    await fetchCars(isRefresh: true);
  }

  void reset() {
    isLoading = true;
    isError = false;
    isRefreshing = false;
    cars.clear();
    cars = [];
  }
}
