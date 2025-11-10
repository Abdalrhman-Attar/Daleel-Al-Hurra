import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../module/global_elevated_button.dart';
import '../../../../module/global_text_field.dart';
import '../../../../services/translation_service.dart';
import '../../../../utils/constants/colors.dart';
import '../../controllers/forgot_password_controller.dart';
import '../../views/forgot_password_reset_page.dart';

class ForgotPasswordForm extends StatelessWidget {
  ForgotPasswordForm({super.key});

  final ForgotPasswordController _forgotPasswordController =
      Get.put(ForgotPasswordController());

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return Get.find<TranslationService>().tr('phone required');
    }

    // Phone validation
    final cleanValue = value.replaceAll(RegExp(r'[^\d+]'), '');

    // Check if it's already in international format
    if (cleanValue.startsWith('+')) {
      final phoneRegex = RegExp(r'^\+\d{10,15}$');
      if (!phoneRegex.hasMatch(cleanValue)) {
        return Get.find<TranslationService>().tr('invalid phone');
      }
    } else {
      // Check if it's a local Jordanian number (9 digits, optionally starting with 0)
      if (cleanValue.length == 9 ||
          (cleanValue.length == 10 && cleanValue.startsWith('0'))) {
        // Remove leading 0 if present
        final numberWithoutZero =
            cleanValue.startsWith('0') ? cleanValue.substring(1) : cleanValue;

        // Check if it's a valid Jordanian mobile number (starts with 7)
        if (numberWithoutZero.startsWith('7') &&
            numberWithoutZero.length == 9) {
          return null;
        }
      }
      return Get.find<TranslationService>().tr('invalid phone');
    }

    return null;
  }

  Future<void> _handleForgotPassword(BuildContext context) async {
    if (_forgotPasswordController.formKey.currentState?.validate() ?? false) {
      _forgotPasswordController.isLoading = true;

      await Future.delayed(const Duration(seconds: 1), () async {
        final formattedPhoneNumber =
            await _forgotPasswordController.requestReset();

        if (formattedPhoneNumber != null) {
          // Reset request successful, navigate to the new forgot password reset page
          await Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ForgotPasswordResetPage(
                identity: formattedPhoneNumber,
              ),
            ),
          );
        }
      });

      _forgotPasswordController.isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Form(
        key: _forgotPasswordController.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40),
            Text(
              Get.find<TranslationService>()
                  .tr('enter your phone number to reset password'),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GlobalTextFormField(
              controller: _forgotPasswordController.phoneNumberController,
              hint: Get.find<TranslationService>().tr('enter phone'),
              validator: _validatePhone,
              validationMode: ValidationMode.onInteraction,
              enableBlur: true,
              fillColor: Colors.white.withValues(alpha: 0.1),
              filled: true,
              prefixIcon: Icon(
                Icons.phone_outlined,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            GlobalElevatedButton(
              text: _forgotPasswordController.isLoading
                  ? Get.find<TranslationService>().tr('sending request')
                  : Get.find<TranslationService>().tr('send reset request'),
              isLoading: _forgotPasswordController.isLoading,
              onPressed: () async => await _handleForgotPassword(context),
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
