import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api/auth/auth_apis.dart';
import '../../../module/toast.dart';

class ResetPasswordController extends GetxController {
  final RxBool _isLoading = false.obs;

  final Rx<GlobalKey<FormState>> _formKey = GlobalKey<FormState>().obs;
  final Rx<String> _otpCode = ''.obs;
  final Rx<String> _identity = ''.obs;
  final Rx<TextEditingController> _passwordController =
      TextEditingController().obs;
  final Rx<TextEditingController> _confirmPasswordController =
      TextEditingController().obs;

  String get otpCode => _otpCode.value;
  String get identity => _identity.value;
  bool get isLoading => _isLoading.value;

  GlobalKey<FormState> get formKey => _formKey.value;

  TextEditingController get passwordController => _passwordController.value;
  TextEditingController get confirmPasswordController =>
      _confirmPasswordController.value;

  set isLoading(bool loading) => _isLoading.value = loading;

  set otpCode(String code) => _otpCode.value = code;
  set identity(String identity) => _identity.value = identity;

  void clearControllers() {
    _otpCode.value = '';
    _identity.value = '';
    passwordController.clear();
    confirmPasswordController.clear();
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

  Future<bool> resetPassword() async {
    isLoading = true;

    try {
      return await AuthApis()
          .resetPassword(
        code: otpCode,
        identity: identity,
        newPassword: passwordController.text,
      )
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
