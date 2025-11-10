import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/constants/colors.dart';

class ChoiceChipsShimmer extends StatelessWidget {
  final int itemCount;

  const ChoiceChipsShimmer({
    super.key,
    this.itemCount = 5, // Default to show 5 skeleton chips
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: MyColors.shimmerBase,
      highlightColor: MyColors.shimmerHighlight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: List.generate(
            itemCount,
            (index) => Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: MyColors.shimmerContainerBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: 40 + (index % 3) * 20, // Varying widths for realism
                height: 12,
                color: MyColors.shimmerBase,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
