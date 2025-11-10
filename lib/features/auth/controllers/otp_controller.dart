import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../module/toast.dart';
import '../../../stores/preferences_store.dart';
import 'login_controller.dart';
import 'register_controller.dart';

class OtpController extends GetxController {
  final RxBool _isLoading = false.obs;
  final RxBool _isLoginVerification = false.obs;
  final RxBool _canResendOtp = false.obs;
  final RxInt _resendTimer = 120.obs; // 2 minutes in seconds
  final RxString _timerText = '02:00'.obs;

  final Rx<GlobalKey<FormState>> _formKey = GlobalKey<FormState>().obs;
  final Rx<TextEditingController> _codeController = TextEditingController().obs;

  bool get isLoading => _isLoading.value;
  bool get isLoginVerification => _isLoginVerification.value;
  bool get canResendOtp => _canResendOtp.value;
  int get resendTimer => _resendTimer.value;
  String get timerText => _timerText.value;

  GlobalKey<FormState> get formKey => _formKey.value;

  TextEditingController get codeController => _codeController.value;

  set isLoading(bool loading) => _isLoading.value = loading;

  void clearControllers() {
    codeController.clear();
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
    // Timer will be started when the OTP form is initialized
  }

  @override
  void onClose() {
    _stopTimer();
    super.onClose();
  }

  /// Set whether this OTP is for login verification or password reset
  void setVerificationType(bool isLoginVerification) {
    _isLoginVerification.value = isLoginVerification;
  }

  /// Timer for resend OTP functionality
  Timer? _timer;

  /// Start the 2-minute countdown timer
  void startResendTimer() {
    // Cancel any existing timer to prevent multiple timers running
    _stopTimer();

    _canResendOtp.value = false;
    _resendTimer.value = 120; // Reset to 2 minutes
    _updateTimerText();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer.value > 0) {
        _resendTimer.value--;
        _updateTimerText();
      } else {
        _canResendOtp.value = true;
        _stopTimer();
      }
    });
  }

  /// Update timer text in MM:SS format
  void _updateTimerText() {
    var minutes = _resendTimer.value ~/ 60;
    var seconds = _resendTimer.value % 60;
    _timerText.value =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Stop the timer
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Resend OTP code
  Future<void> resendOtp() async {
    if (!canResendOtp) return;

    _canResendOtp.value = false; // Disable button while processing

    try {
      if (isLoginVerification) {
        // For login verification, we don't have a specific resend method
        // This would need to be implemented based on login flow requirements
        Toast.i('Please try again later');
        startResendTimer(); // Restart timer
      } else {
        // For registration verification, use RegisterController
        final registerController = Get.find<RegisterController>();
        await registerController.resendOtp();
        startResendTimer(); // Restart timer after successful resend
      }
    } catch (e) {
      startResendTimer(); // Restart timer on error
    }
  }

  Future<bool> varify() async {
    isLoading = true;

    try {
      if (isLoginVerification) {
        // Use LoginController for login verification with temporary token
        final loginController = Get.find<LoginController>();
        final success = await loginController.verifyOtpWithTemporaryToken(
          code: codeController.text.trim(),
        );

        if (success) {
          clearControllers();
          clearForm();
          isLoading = false;
          return true;
        }

        isLoading = false;
        return false;
      } else {
        // Use RegisterController for OTP verification after registration
        final registerController = Get.find<RegisterController>();
        final success = await registerController.verifyOtp(
          type: 'phone',
          code: codeController.text.trim(),
        );

        if (success) {
          // OTP verification successful - user data is already saved by RegisterController
          Get.find<PreferencesStore>().isLoggedIn = true;

          clearControllers();
          clearForm();
          isLoading = false;
          return true;
        }

        isLoading = false;
        return false;
      }
    } catch (e) {
      isLoading = false;
      return false;
    }
  }
}
