import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/constants/colors.dart';

class CategorySliderShimmer extends StatelessWidget {
  const CategorySliderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: MyColors.shimmerBase,
      highlightColor: MyColors.shimmerHighlight,
      child: SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: 4, // Show 4 skeleton items
          itemBuilder: (context, index) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.4,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  // Category image
                  Flexible(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        color: MyColors.shimmerContainerBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Category name
                  Container(
                    width: 80,
                    height: 18,
                    color: MyColors.shimmerBase,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
