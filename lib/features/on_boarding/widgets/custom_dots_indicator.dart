import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class CustomDotsIndicator extends StatelessWidget {
  final double position;
  final int dotsCount;
  const CustomDotsIndicator({
    required this.dotsCount,
    required this.position,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DotsIndicator(
      dotsCount: dotsCount,
      position: position,
      decorator: DotsDecorator(
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.4),
        size: const Size.square(8.0),
        activeSize: const Size(24, 8),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        activeColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
