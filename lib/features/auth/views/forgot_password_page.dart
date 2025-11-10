import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/translation_service.dart';
import '../widgets/forms/forgot_password_form.dart';
import '../widgets/section_wrapper.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final translationService = Get.find<TranslationService>();
    return SectionWrapper(
      showGuestAndSocialLogin: false,
      child: Column(
        children: [
          Text(
            translationService.tr('forgot password'),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            translationService.tr('we will send you a reset code'),
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),

          // Forgot password form container
          ForgotPasswordForm(),
        ],
      ),
    );
  }
}
