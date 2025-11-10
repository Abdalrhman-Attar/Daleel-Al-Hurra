import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../module/global_elevated_button.dart';
import '../../../../module/global_text_field.dart';
import '../../../../module/pin_input.dart';
import '../../../../services/translation_service.dart';
import '../../../../utils/constants/colors.dart';
import '../../controllers/reset_password_controller.dart';
import '../../views/login_page.dart';

class ForgotPasswordResetForm extends StatelessWidget {
  ForgotPasswordResetForm({
    super.key,
    required this.identity,
  });

  final String identity;
  final ResetPasswordController _resetPasswordController =
      Get.put(ResetPasswordController());

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return Get.find<TranslationService>().tr('password required');
    }

    if (value.length < 6) {
      return Get.find<TranslationService>().tr('password too short');
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return Get.find<TranslationService>().tr('confirm password required');
    }
    if (value != _resetPasswordController.passwordController.text) {
      return Get.find<TranslationService>().tr('passwords do not match');
    }
    return null;
  }

  String? _validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return Get.find<TranslationService>().tr('otp required');
    }
    if (value.length < 6) {
      return Get.find<TranslationService>().tr('otp must be 6 digits');
    }
    return null;
  }

  Future<void> _handlePasswordReset(BuildContext context) async {
    // Set the identity and otp code in the controller
    _resetPasswordController.identity = identity;
    _resetPasswordController.otpCode = _otpCodeController.text.trim();

    if (_resetPasswordController.formKey.currentState?.validate() ?? false) {
      _resetPasswordController.isLoading = true;
      await Future.delayed(const Duration(seconds: 1), () async {
        if (await _resetPasswordController.resetPassword()) {
          _resetPasswordController.clearControllers();
          _otpCodeController.clear();
          await Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        }
      });
      _resetPasswordController.isLoading = false;
    }
  }

  final TextEditingController _otpCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Form(
        key: _resetPasswordController.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40),
            Text(
              Get.find<TranslationService>()
                  .tr('enter the verification code sent to your phone'),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // OTP Input
            GlobalPinInput(
              length: 6,
              controller: _otpCodeController,
              enableBlur: true,
              fillColor: Colors.white.withValues(alpha: 0.1),
              cursorColor: Colors.white,
              focusedBorderColor: Colors.white.withValues(alpha: 0.2),
              validator: _validateOtp,
            ),
            const SizedBox(height: 24),
            Text(
              Get.find<TranslationService>().tr('enter your new password'),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            GlobalTextFormField(
              controller: _resetPasswordController.passwordController,
              hint: Get.find<TranslationService>().tr('enter password'),
              obscureText: true,
              validator: _validatePassword,
              validationMode: ValidationMode.onInteraction,
              enableBlur: true,
              prefixIcon: Icon(
                Icons.lock_outline,
                color: Colors.white.withValues(alpha: 0.7),
              ),
              fillColor: Colors.white.withValues(alpha: 0.1),
              filled: true,
            ),
            const SizedBox(height: 16),
            GlobalTextFormField(
              controller: _resetPasswordController.confirmPasswordController,
              hint: Get.find<TranslationService>().tr('confirm password'),
              obscureText: true,
              validator: _validateConfirmPassword,
              validationMode: ValidationMode.onInteraction,
              enableBlur: true,
              prefixIcon: Icon(
                Icons.lock_outline,
                color: Colors.white.withValues(alpha: 0.7),
              ),
              fillColor: Colors.white.withValues(alpha: 0.1),
              filled: true,
            ),
            const SizedBox(height: 24),
            GlobalElevatedButton(
              text: _resetPasswordController.isLoading
                  ? Get.find<TranslationService>().tr('reseting password')
                  : Get.find<TranslationService>().tr('reset password'),
              isLoading: _resetPasswordController.isLoading,
              onPressed: () async => await _handlePasswordReset(context),
              backgroundColor: MyColors.primary,
              borderRadius: BorderRadius.circular(50.0),
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              isMinimumWidth: false,
            ),
          ],
        ),
      ),
    );
  }
}
