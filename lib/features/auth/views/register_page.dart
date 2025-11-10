import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../module/global_text_button.dart';
import '../../../services/translation_service.dart';
import '../widgets/forms/register_form.dart';
import '../widgets/section_wrapper.dart';
import 'login_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});
  @override
  Widget build(BuildContext context) {
    final translationService = Get.find<TranslationService>();
    return SectionWrapper(
      child: Column(
        children: [
          Text(
            translationService.tr('create account'),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            translationService.tr('sign up to get started'),
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          RegisterForm(),
          // Sign in link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                translationService.tr('already have account'),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              GlobalTextButton(
                text: translationService.tr('sign in'),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(50.0),
                foregroundColor: Colors.white.withValues(alpha: 0.8),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
