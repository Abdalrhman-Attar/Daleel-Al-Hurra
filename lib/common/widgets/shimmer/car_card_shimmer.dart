import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/constants/colors.dart';

class CarCardShimmer extends StatelessWidget {
  const CarCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: MyColors.shimmerBase,
      highlightColor: MyColors.shimmerHighlight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Card(
          color: MyColors.surface,
          surfaceTintColor: MyColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image section (3/5 of card)
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    // Main image area
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        color: MyColors.shimmerContainerBackground,
                      ),
                    ),
                    // Price badge skeleton (top-right)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: MyColors.shimmerContainerBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: MyColors.shimmerBase,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              width: 60,
                              height: 13,
                              color: MyColors.shimmerBase,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Brand logo skeleton (top-left)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        height: 32,
                        width: 32,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: MyColors.shimmerContainerBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: MyColors.shimmerBase,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    // Image dots skeleton (bottom-left)
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 4),
                        decoration: BoxDecoration(
                          color: MyColors.shimmerContainerBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            3,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: MyColors.shimmerBase,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Favorite button skeleton (bottom-right)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: MyColors.shimmerContainerBackground,
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Details section (2/5 of card)
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Car title and year/mileage
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Car title
                          Container(
                            width: 140,
                            height: 16,
                            color: MyColors.shimmerBase,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              // Year badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: MyColors.shimmerContainerBackground,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  width: 30,
                                  height: 12,
                                  color: MyColors.shimmerBase,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Mileage
                              Container(
                                width: 60,
                                height: 12,
                                color: MyColors.shimmerBase,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Specifications row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          3,
                          (index) => Column(
                            children: [
                              // Icon container
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: MyColors.shimmerContainerBackground,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Value
                              Container(
                                width: 20,
                                height: 12,
                                color: MyColors.shimmerBase,
                              ),
                              // Label
                              Container(
                                width: 25,
                                height: 10,
                                color: MyColors.shimmerBase,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
