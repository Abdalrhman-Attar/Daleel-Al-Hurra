import 'package:flutter/material.dart';

import 'car_card_shimmer.dart';

class CarGridShimmer extends StatelessWidget {
  final int itemCount;

  const CarGridShimmer({
    super.key,
    this.itemCount = 6, // Default to show 6 skeleton items
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 4),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.54,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemBuilder: (context, index) => const CarCardShimmer(),
      ),
    );
  }
}
