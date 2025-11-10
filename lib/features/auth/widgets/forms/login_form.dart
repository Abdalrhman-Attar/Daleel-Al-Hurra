import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/layouts/bottom_nav_layout/bottom_nav_page.dart';
import '../../../../module/global_elevated_button.dart';
import '../../../../module/global_text_field.dart';
import '../../../../services/translation_service.dart';
import '../../../../utils/constants/colors.dart';
import '../../controllers/login_controller.dart';
import '../../views/forgot_password_page.dart';
import '../../views/otp_page.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key});

  final LoginController _loginController = Get.put(LoginController());

  String? _validateLogin(String? value) {
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
      if (cleanValue.length == 9 || (cleanValue.length == 10 && cleanValue.startsWith('0'))) {
        // Remove leading 0 if present
        final numberWithoutZero = cleanValue.startsWith('0') ? cleanValue.substring(1) : cleanValue;

        // Check if it's a valid Jordanian mobile number (starts with 7)
        if (numberWithoutZero.startsWith('7') && numberWithoutZero.length == 9) {
          return null;
        }
      }
      return Get.find<TranslationService>().tr('invalid phone');
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return Get.find<TranslationService>().tr('password required');
    }

    if (value.length < 6) {
      return Get.find<TranslationService>().tr('password too short');
    }

    return null;
  }

  Future<void> _handleLogin(BuildContext context) async {
    if (_loginController.formKey.currentState?.validate() ?? false) {
      // Format phone number with country code before login
      var formattedPhoneNumber = _loginController.phoneNumberController.text.trim();
      if (!formattedPhoneNumber.startsWith('+')) {
        // Remove leading 0 if present for Jordanian numbers
        if (formattedPhoneNumber.startsWith('0')) {
          formattedPhoneNumber = formattedPhoneNumber.substring(1);
        }
        // Add Jordanian country code (+962)
        formattedPhoneNumber = '+962$formattedPhoneNumber';
      }

      // Update the text field with formatted phone number
      _loginController.phoneNumberController.text = formattedPhoneNumber;

      _loginController.isLoading = true;
      await Future.delayed(const Duration(seconds: 1), () async {
        final loginResult = await _loginController.login();

        switch (loginResult) {
          case 0:
            // Login failed - errors already shown by controller
            break;

          case 1:
            // User is verified - navigate to BottomNavPage
            _loginController.clearControllers();
            await Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const BottomNavPage()),
              (route) => false,
            );
            break;

          case 2:
            // User is not verified - navigate to OTP page
            _loginController.clearControllers();
            // Request OTP automatically for unverified users
            await _loginController.requestOtpForVerification();

            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OtpPage(
                  isPasswordReset: false,
                  identity: _loginController.phoneNumberController.text,
                  isLoginVerification: true,
                ),
              ),
            );
            break;
        }
      });
      _loginController.isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Form(
        key: _loginController.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40),
            GlobalTextFormField(
              controller: _loginController.phoneNumberController,
              hint: Get.find<TranslationService>().tr('enter phone'),
              validator: _validateLogin,
              validationMode: ValidationMode.onInteraction,
              enableBlur: true,
              fillColor: Colors.white.withValues(alpha: 0.1),
              filled: true,
            ),
            const SizedBox(height: 16),
            GlobalTextFormField(
              controller: _loginController.passwordController,
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
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordPage(),
                    ),
                  );
                },
                child: Text(
                  Get.find<TranslationService>().tr('forgot password'),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GlobalElevatedButton(
              text: _loginController.isLoading ? Get.find<TranslationService>().tr('signing in') : Get.find<TranslationService>().tr('sign in'),
              isLoading: _loginController.isLoading,
              onPressed: () async => await _handleLogin(context),
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
