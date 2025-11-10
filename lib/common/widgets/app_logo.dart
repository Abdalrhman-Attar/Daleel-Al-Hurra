import 'package:flutter/material.dart';

import '../../module/global_image.dart';
import '../../utils/constants/enums.dart';
import '../../utils/constants/logo_strings.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.overlayColor,
  });

  final double? height;
  final double? width;
  final BoxFit fit;
  final Color? overlayColor;

  @override
  Widget build(BuildContext context) {
    return GlobalImage(
      type: ImageType.asset,
      assetPath: LogoStrings.logo,
      height: height ?? 50,
      width: width,
      overlayColor: overlayColor ?? Colors.white,
      fit: fit,
    );
  }
}
