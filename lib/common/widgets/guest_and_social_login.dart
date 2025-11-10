import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/auth/widgets/divider_with_text.dart';
import '../../module/global_text_button.dart';
import '../../services/translation_service.dart';
import 'layouts/bottom_nav_layout/bottom_nav_page.dart';

class GuestAndSocialLogin extends StatelessWidget {
  const GuestAndSocialLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final translationService = Get.find<TranslationService>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DividerWithText(text: translationService.tr('or')),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // const SocialButtons(),
              GlobalTextButton(
                text: translationService.tr('continue as guest'),
                onPressed: () {
                  // Handle skip action
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BottomNavPage()),
                    (route) => false,
                  );
                },
                borderRadius: BorderRadius.circular(50.0),
                foregroundColor: Colors.white.withValues(alpha: 0.8),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
