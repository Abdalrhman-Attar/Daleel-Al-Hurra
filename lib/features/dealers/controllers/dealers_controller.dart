import 'package:get/get.dart';

import '../../../api/cars/cars_apis.dart';
import '../../../model/cars/dealer/dealer.dart';

class DealersController extends GetxController {
  final RxBool _isLoading = true.obs;
  final RxBool _isError = false.obs;
  final RxBool _isRefreshing = false.obs;
  final RxList<Dealer> _dealers = <Dealer>[].obs;

  bool get isLoading => _isLoading.value;
  bool get isError => _isError.value;
  bool get isRefreshing => _isRefreshing.value;
  List<Dealer> get dealers => _dealers;

  set isLoading(bool value) => _isLoading.value = value;
  set isError(bool value) => _isError.value = value;
  set isRefreshing(bool value) => _isRefreshing.value = value;
  set dealers(List<Dealer> value) => _dealers.value = value;
  Future<void> fetchDealers({
    bool isRefresh = false,
  }) async {
    try {
      isError = false;

      isLoading = true;
      isRefreshing = false;

      final response = await CarsApis().getDealers();

      if (response.isSuccess) {
        dealers = response.data ?? [];
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
    await fetchDealers(isRefresh: true);
  }

  void reset() {
    isLoading = true;
    isError = false;
    isRefreshing = false;
    dealers.clear();
    dealers = [];
  }
}
