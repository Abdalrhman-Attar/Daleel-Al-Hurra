import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api/auth/auth_apis.dart';
import '../../../module/toast.dart';

class ForgotPasswordController extends GetxController {
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

  Future<String?> requestReset() async {
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

      final response =
          await AuthApis().requestReset(identity: formattedPhoneNumber);

      if (response.isSuccess) {
        clearForm();
        clearControllers();

        Toast.s(response.message ?? 'Reset request sent successfully');

        isLoading = false;
        return formattedPhoneNumber; // Return formatted phone number for next step
      }

      // Display errors
      final errors = response.errors ?? [];
      for (var i = 0; i < errors.length; i++) {
        Future.delayed(Duration(milliseconds: i * 500), () {
          Toast.e(response.message ?? 'Request failed', description: errors[i]);
        });
      }

      isLoading = false;
      return null;
    } catch (e) {
      Toast.e('Request failed', description: e.toString());
      isLoading = false;
      return null;
    }
  }
}
