import 'package:flutter/material.dart';

import '../../../common/widgets/shimmer/shimmer_components.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

/// A circular loader widget with customizable foreground and background colors.
class CircularLoader extends StatelessWidget {
  /// Default constructor for the TCircularLoader.
  ///
  /// Parameters:
  ///   - foregroundColor: The color of the circular loader.
  ///   - backgroundColor: The background color of the circular loader.
  const CircularLoader({
    super.key,
    this.foregroundColor = MyColors.white,
    this.backgroundColor,
  });

  final Color? foregroundColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Sizes.lg),
      decoration: BoxDecoration(
        color: backgroundColor ?? MyColors.primary,
        shape: BoxShape.circle,
      ), // Circular background
      child: const Center(
        child: LoadingShimmer(), // Shimmer loader
      ),
    );
  }
}
