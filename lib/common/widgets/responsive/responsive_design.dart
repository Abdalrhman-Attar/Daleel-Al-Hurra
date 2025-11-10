import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';

class ResponsiveDesign extends StatelessWidget {
  const ResponsiveDesign({
    super.key,
    required this.desktop,
    required this.tablet,
    required this.mobile,
  });

  final Widget desktop;
  final Widget tablet;
  final Widget mobile;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > Sizes.screenSizeDesktop) {
          return desktop;
        } else if (constraints.maxWidth > Sizes.screenSizeTablet &&
            constraints.maxWidth < Sizes.screenSizeDesktop) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}
