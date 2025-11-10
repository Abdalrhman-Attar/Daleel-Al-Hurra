import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../module/global_text_button.dart';
import '../../../services/translation_service.dart';
import '../widgets/forms/login_form.dart';
import '../widgets/section_wrapper.dart';
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final translationService = Get.find<TranslationService>();
    return SectionWrapper(
      child: Column(
        children: [
          Text(
            translationService.tr('welcome back'),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            translationService.tr('sign in to continue'),
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),

          // Login form container
          LoginForm(),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                translationService.tr('dont have account'),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              GlobalTextButton(
                text: translationService.tr('register'),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
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
