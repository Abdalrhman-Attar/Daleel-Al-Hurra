import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../api/general/general_apis.dart';
import '../../../model/general/page_model/slider_model.dart';

class SliderController extends GetxController {
  final RxBool _isLoading = true.obs;
  final RxBool _isError = false.obs;
  final RxBool _isRefreshing = false.obs;
  final RxList<SliderModel> _sliders = <SliderModel>[].obs;

  bool get isLoading => _isLoading.value;
  bool get isError => _isError.value;
  bool get isRefreshing => _isRefreshing.value;
  List<SliderModel> get sliders => _sliders;

  set isLoading(bool value) => _isLoading.value = value;
  set isError(bool value) => _isError.value = value;
  set isRefreshing(bool value) => _isRefreshing.value = value;
  set sliders(List<SliderModel> value) => _sliders.value = value;

  Future<void> fetchSliders({
    bool isRefresh = false,
  }) async {
    try {
      isError = false;
      if (!isRefresh) isLoading = true;
      isRefreshing = isRefresh;

      final response = await GeneralApis().getSliderApps();

      if (response.isSuccess) {
        sliders = response.data ?? [];
      } else {
        isError = true;
      }
    } catch (e) {
      isError = true;
      debugPrint(' Slider fetch error: $e');
    } finally {
      isLoading = false;
      isRefreshing = false;
    }
  }

  @override
  Future<void> refresh() async {
    await fetchSliders(isRefresh: true);
  }

  void reset() {
    isLoading = true;
    isError = false;
    isRefreshing = false;
    sliders.clear();
    sliders = [];
  }
}
