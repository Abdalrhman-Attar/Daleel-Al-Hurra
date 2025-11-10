import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/translation_service.dart';
import '../widgets/forms/forgot_password_reset_form.dart';
import '../widgets/section_wrapper.dart';

class ForgotPasswordResetPage extends StatelessWidget {
  const ForgotPasswordResetPage({
    super.key,
    required this.identity,
  });

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
            translationService.tr('complete the password reset'),
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),

          // Forgot password reset form container
          ForgotPasswordResetForm(identity: identity),
        ],
      ),
    );
  }
}
