import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../module/global_elevated_button.dart';
import '../../../../module/global_text_field.dart';
import '../../../../services/translation_service.dart';
import '../../../../utils/constants/colors.dart';
import '../../controllers/choose_recovery_type_controller.dart';
import '../../views/otp_page.dart';

class ChooseRecoveryTypeForm extends StatelessWidget {
  ChooseRecoveryTypeForm({super.key});

  final ChooseRecoveryTypeController chooseRecoveryTypeController = Get.put(ChooseRecoveryTypeController());

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

  Future<void> _handleResetRequest(BuildContext context) async {
    if (chooseRecoveryTypeController.formKey.currentState?.validate() ?? false) {
      chooseRecoveryTypeController.isLoading = true;
      await Future.delayed(const Duration(seconds: 1), () async {
        if (await chooseRecoveryTypeController.requestReset()) {
          chooseRecoveryTypeController.clearControllers();
          // Format phone number with country code if not already formatted
          var formattedPhoneNumber = chooseRecoveryTypeController.phoneNumberController.text.trim();
          if (!formattedPhoneNumber.startsWith('+')) {
            // Remove leading 0 if present for Jordanian numbers
            if (formattedPhoneNumber.startsWith('0')) {
              formattedPhoneNumber = formattedPhoneNumber.substring(1);
            }
            // Add Jordanian country code (+962)
            formattedPhoneNumber = '+962$formattedPhoneNumber';
          }

          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OtpPage(
                isPasswordReset: true,
                identity: formattedPhoneNumber,
              ),
            ),
          );
        }
      });
      chooseRecoveryTypeController.isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Form(
        key: chooseRecoveryTypeController.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40),
            GlobalTextFormField(
              controller: chooseRecoveryTypeController.phoneNumberController,
              hint: Get.find<TranslationService>().tr('enter phone'),
              validator: _validateLogin,
              validationMode: ValidationMode.onInteraction,
              enableBlur: true,
              fillColor: Colors.white.withValues(alpha: 0.1),
              filled: true,
            ),
            const SizedBox(height: 16),
            GlobalElevatedButton(
              text: chooseRecoveryTypeController.isLoading ? Get.find<TranslationService>().tr('sending reset request') : Get.find<TranslationService>().tr('request reset'),
              isLoading: chooseRecoveryTypeController.isLoading,
              onPressed: () async => await _handleResetRequest(context),
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
