import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/translation_service.dart';
import '../widgets/forms/reset_password_form.dart';
import '../widgets/section_wrapper.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({
    super.key,
    required this.otpCode,
    required this.identity,
  });

  final String otpCode;
  final String identity;

  @override
  Widget build(BuildContext context) {
    final translationService = Get.find<TranslationService>();
    return SectionWrapper(
      showGuestAndSocialLogin: false,
      child: Column(
        children: [
          Text(
            translationService.tr('reset password'),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            translationService.tr('enter new password'),
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),

          // Login form container
          ResetPasswordForm(
            otpCode: otpCode,
            identity: identity,
          ),
        ],
      ),
    );
  }
}
