import 'package:flutter/material.dart';

import '../../utils/constants/logo_strings.dart';

class AppBarLogo extends StatelessWidget {
  const AppBarLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      LogoStrings.logo,
      height: 140,
      fit: BoxFit.contain,
      color: Theme.of(context).brightness == Brightness.light
          ? null
          : Colors.white,
    );
  }
}
