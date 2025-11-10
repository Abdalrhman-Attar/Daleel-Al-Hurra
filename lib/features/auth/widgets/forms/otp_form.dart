import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/layouts/bottom_nav_layout/bottom_nav_page.dart';
import '../../../../module/global_elevated_button.dart';
import '../../../../module/pin_input.dart';
import '../../../../services/translation_service.dart';
import '../../../../utils/constants/colors.dart';
import '../../controllers/otp_controller.dart';
import '../../views/reset_password_page.dart';

class OtpForm extends StatefulWidget {
  const OtpForm({
    super.key,
    this.isPasswordReset = false,
    this.identity,
    this.isLoginVerification = false,
  });

  final bool isPasswordReset;
  final String? identity;
  final bool isLoginVerification;

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  late final OtpController _otpController;

  @override
  void initState() {
    super.initState();
    // Get or create the OTP controller and set verification type
    _otpController = Get.put(OtpController());
    _otpController.setVerificationType(widget.isLoginVerification);
    // Ensure timer starts immediately when entering the page
    _otpController.startResendTimer();
  }

  @override
  void dispose() {
    // Clean up resources when widget is disposed
    super.dispose();
  }

  Future<void> _handleVerify(BuildContext context) async {
    if (_otpController.formKey.currentState?.validate() ?? false) {
      _otpController.isLoading = true;

      // Simulate login process
      Future.delayed(const Duration(seconds: 1), () async {
        if (await _otpController.varify()) {
          final otpCode = _otpController.codeController.text;
          await Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => widget.isPasswordReset
                  ? ResetPasswordPage(
                      otpCode: otpCode,
                      identity: widget.identity!,
                    )
                  : const BottomNavPage(),
            ),
            (route) => false,
          );
        }
      });
      _otpController.isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Form(
        key: _otpController.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40),
            GlobalPinInput(
              length: 6,
              controller: _otpController.codeController,
              enableBlur: true,
              fillColor: Colors.white.withValues(alpha: 0.1),
              cursorColor: Colors.white,
              focusedBorderColor: Colors.white.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            GlobalElevatedButton(
              text: _otpController.isLoading ? Get.find<TranslationService>().tr('signing in') : Get.find<TranslationService>().tr('sign in'),
              isLoading: _otpController.isLoading,
              onPressed: () async => await _handleVerify(context),
              backgroundColor: MyColors.primary,
              borderRadius: BorderRadius.circular(50.0),
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              isMinimumWidth: false,
            ),
            const SizedBox(height: 16),
            // Resend OTP section
            Obx(
              () => Column(
                children: [
                  Text(
                    _otpController.canResendOtp ? Get.find<TranslationService>().tr('you can resend the code now') : '${Get.find<TranslationService>().tr('you can resend the code in:')}${_otpController.timerText}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  GlobalElevatedButton(
                    text: Get.find<TranslationService>().tr('resend code'),
                    isLoading: false,
                    onPressed: _otpController.canResendOtp ? () => _otpController.resendOtp() : null,
                    backgroundColor: _otpController.canResendOtp ? MyColors.primary.withValues(alpha: 0.8) : Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(50.0),
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    isMinimumWidth: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
