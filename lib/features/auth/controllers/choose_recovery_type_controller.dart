import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api/auth/auth_apis.dart';
import '../../../module/toast.dart';

class ChooseRecoveryTypeController extends GetxController {
  final RxBool _isLoading = false.obs;

  final Rx<GlobalKey<FormState>> _formKey = GlobalKey<FormState>().obs;
  final Rx<TextEditingController> _phoneNumberController =
      TextEditingController().obs;

  bool get isLoading => _isLoading.value;

  GlobalKey<FormState> get formKey => _formKey.value;

  TextEditingController get phoneNumberController =>
      _phoneNumberController.value;

  set isLoading(bool loading) => _isLoading.value = loading;

  void clearControllers() {
    phoneNumberController.clear();
  }

  void clearForm() => formKey.currentState?.reset();

  void clearLoading() => isLoading = false;

  @override
  void onInit() {
    super.onInit();
    _formKey.value = GlobalKey<FormState>();
    clearControllers();
    clearForm();
    clearLoading();
  }

  Future<bool> requestReset() async {
    isLoading = true;

    try {
      // Format phone number with country code if not already formatted
      var formattedPhoneNumber = phoneNumberController.text.trim();
      if (!formattedPhoneNumber.startsWith('+')) {
        // Remove leading 0 if present for Jordanian numbers
        if (formattedPhoneNumber.startsWith('0')) {
          formattedPhoneNumber = formattedPhoneNumber.substring(1);
        }
        // Add Jordanian country code (+962)
        formattedPhoneNumber = '+962$formattedPhoneNumber';
      }

      return await AuthApis()
          .requestReset(identity: formattedPhoneNumber)
          .then((value) async {
        if (value.isSuccess) {
          clearForm();
          clearControllers();

          isLoading = false;

          Toast.s(value.message ?? 'Login successful');

          return true;
        }
        // staggered display of errors
        final errors = value.errors ?? [];
        for (var i = 0; i < errors.length; i++) {
          Future.delayed(Duration(milliseconds: i * 500), () {
            Toast.e(value.message ?? 'Login failed', description: errors[i]);
          });
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
