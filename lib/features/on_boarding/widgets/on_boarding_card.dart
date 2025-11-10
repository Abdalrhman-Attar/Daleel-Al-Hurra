import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../../model/on_boarding.dart';

class OnboardingCard extends StatelessWidget {
  final Onboarding onboarding;
  const OnboardingCard({required this.onboarding, super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 1400),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              onboarding.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              onboarding.info,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
