import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../module/global_elevated_button.dart';
import '../../../module/global_outlined_button.dart';
import '../../../services/translation_service.dart';
import '../../../utils/constants/colors.dart';
import '../widgets/section_wrapper.dart';
import 'login_page.dart';
import 'register_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});
  @override
  Widget build(BuildContext context) {
    final translationService = Get.find<TranslationService>();
    return SectionWrapper(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: GlobalElevatedButton(
                  text: translationService.tr('register'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  backgroundColor: MyColors.primary,
                  borderRadius: BorderRadius.circular(50.0),
                  isMinimumWidth: false,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GlobalOutlinedButton(
                  text: translationService.tr('login'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  enableBlur: true,
                  foregroundColor: MyColors.white,
                  borderColor: MyColors.white,
                  borderRadius: BorderRadius.circular(50.0),
                  isMinimumWidth: false,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
