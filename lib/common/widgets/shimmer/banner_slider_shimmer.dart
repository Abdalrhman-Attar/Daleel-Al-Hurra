import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/constants/colors.dart';

class BannerSliderShimmer extends StatelessWidget {
  const BannerSliderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: MyColors.shimmerBase,
      highlightColor: MyColors.shimmerHighlight,
      child: SizedBox(
        height: 180,
        child: PageView.builder(
          itemCount: 3,
          controller: PageController(viewportFraction: 0.92),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: Colors.grey.shade300,
                    ),
                    Positioned(
                      bottom: 15,
                      left: 10,
                      right: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 160,
                            height: 14,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 100,
                            height: 12,
                            color: Colors.grey.shade400,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
