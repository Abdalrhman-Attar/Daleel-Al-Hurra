import 'package:get/get.dart';

import '../../../api/auth/auth_apis.dart';
import '../../../stores/secure_store.dart';
import '../../../stores/user_data_store.dart';

class DeleteAccountController extends GetxController {
  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set isLoading(bool loading) => _isLoading.value = loading;

  void clearLoading() => isLoading = false;

  @override
  void onInit() {
    super.onInit();

    clearLoading();
  }

  Future<bool> deleteAccount() async {
    isLoading = true;

    try {
      return await AuthApis().deleteAccount().then((value) async {
        if (value.isSuccess) {
          Get.find<UserDataStore>().clear();
          Get.find<SecureStore>().authToken = '';
          isLoading = false;
          return true;
        }
        return false;
      });
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
