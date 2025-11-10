import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/constants/colors.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: MyColors.shimmerBase,
      highlightColor: MyColors.shimmerHighlight,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: MyColors.shimmerContainerBackground,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
