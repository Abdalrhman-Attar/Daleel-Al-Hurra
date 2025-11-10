import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../services/translation_service.dart';
import '../widgets/forms/choose_recovery_type_form.dart';
import '../widgets/section_wrapper.dart';

class ChooseRecoveryType extends StatelessWidget {
  const ChooseRecoveryType({super.key});

  @override
  Widget build(BuildContext context) {
    final translationService = Get.find<TranslationService>();
    return SectionWrapper(
      showGuestAndSocialLogin: false,
      child: Column(
        children: [
          Text(
            translationService.tr('request password reset'),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),

          // Login form container
          ChooseRecoveryTypeForm(),
        ],
      ),
    );
  }
}
