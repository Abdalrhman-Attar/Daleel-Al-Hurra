import 'package:flutter/material.dart';

import 'brand_card_shimmer.dart';

class BrandGridShimmer extends StatelessWidget {
  final int itemCount;

  const BrandGridShimmer({
    super.key,
    this.itemCount = 8, // Default to show 8 skeleton items
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: itemCount,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => const BrandCardShimmer(),
      ),
    );
  }
}
