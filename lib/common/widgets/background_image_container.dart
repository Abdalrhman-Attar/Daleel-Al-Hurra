import 'package:flutter/material.dart';

import '../../../utils/constants/image_strings.dart';

class BackgroundImageContainer extends StatelessWidget {
  const BackgroundImageContainer({
    super.key,
    required this.child,
    this.enableRtlTransform = true,
  });

  final Widget child;
  final bool enableRtlTransform;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage(ImageStrings.authBackground),
          fit: BoxFit.cover,
          matchTextDirection: !enableRtlTransform,
        ),
      ),
      child: child,
    );
  }
}
