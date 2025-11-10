import 'package:flutter/material.dart';

import '../widgets/forms/otp_form.dart';
import '../widgets/section_wrapper.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({
    super.key,
    this.isPasswordReset = false,
    this.identity,
    this.isLoginVerification = false,
  });

  final bool isPasswordReset;
  final String? identity;
  final bool isLoginVerification;

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      showGuestAndSocialLogin: false,
      child: Column(
        children: [
          // Text(
          //   S.current.welcomeBack,
          //   style: const TextStyle(
          //     fontSize: 32,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.white,
          //   ),
          //   textAlign: TextAlign.center,
          // ),
          // const SizedBox(height: 8),
          // Text(
          //   S.current.signInToContinue,
          //   style: TextStyle(
          //     fontSize: 16,
          //     color: Colors.white.withValues(alpha: 0.8),
          //   ),
          //   textAlign: TextAlign.center,
          // ),

          // Login form container
          OtpForm(
            isPasswordReset: isPasswordReset,
            identity: identity,
            isLoginVerification: isLoginVerification,
          ),
        ],
      ),
    );
  }
}
