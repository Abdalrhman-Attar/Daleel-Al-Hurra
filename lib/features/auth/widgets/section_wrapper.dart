import 'package:flutter/material.dart';

import '../../../common/widgets/guest_and_social_login.dart';
import '../../../common/widgets/logo_language_row.dart';
import '../../../module/global_image.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/constants/image_strings.dart';

class SectionWrapper extends StatelessWidget {
  const SectionWrapper({
    super.key,
    this.child,
    this.showGuestAndSocialLogin = true,
  });

  final Widget? child;
  final bool showGuestAndSocialLogin;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GlobalImage(
            type: ImageType.asset,
            assetPath: ImageStrings.authBackground,
            width: double.infinity,
            height: double.infinity,
            gradientOverlay: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                MyColors.black.withValues(alpha: 0.6),
                MyColors.black.withValues(alpha: 0.4),
              ],
            ),
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const LogoLanguageRow(),
                        const Spacer(),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: child,
                        ),
                        // Sign in link
                        const SizedBox(height: 16),
                        if (showGuestAndSocialLogin)
                          const GuestAndSocialLogin(),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
