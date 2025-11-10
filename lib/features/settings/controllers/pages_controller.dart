import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../api/general/general_apis.dart';
import '../../../model/general/page_model/page_model.dart';

class PagesController extends GetxController {
  final RxBool _isLoading = true.obs;
  final RxBool _isError = false.obs;
  final RxBool _isRefreshing = false.obs;
  final RxList<PageModel> _pages = <PageModel>[].obs;

  bool get isLoading => _isLoading.value;
  bool get isError => _isError.value;
  bool get isRefreshing => _isRefreshing.value;
  List<PageModel> get pages => _pages;

  set isLoading(bool value) => _isLoading.value = value;
  set isError(bool value) => _isError.value = value;
  set isRefreshing(bool value) => _isRefreshing.value = value;
  set pages(List<PageModel> value) => _pages.value = value;
  Future<void> fetchPages({
    bool isRefresh = false,
  }) async {
    try {
      isError = false;

      isLoading = true;
      isRefreshing = false;

      final response = await GeneralApis().getPages();

      if (response.isSuccess) {
        pages = response.data ?? [];
      } else {
        isError = true;
      }
    } catch (e) {
      isError = true;
      debugPrint('error: $e');
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> refresh() async {
    await fetchPages(isRefresh: true);
  }

  void reset() {
    isLoading = true;
    isError = false;
    isRefreshing = false;
    pages.clear();
    pages = [];
  }
}
