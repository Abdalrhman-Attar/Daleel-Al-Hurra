import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/constants/colors.dart';

class BrandCardShimmer extends StatelessWidget {
  const BrandCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: MyColors.shimmerBase,
      highlightColor: MyColors.shimmerHighlight,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Brand image container
              Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: MyColors.shimmerContainerBackground,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: MyColors.shimmerBase,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Brand name
              Container(
                width: 60,
                height: 12,
                color: MyColors.shimmerBase,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
