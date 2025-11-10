import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../common/widgets/shimmer/shimmer_components.dart';
import '../controllers/locale/locale.dart';
import '../utils/constants/colors.dart';

class DynamicIconViewer extends StatelessWidget {
  final String filePath;
  final double size;
  final Color? color;
  final bool revers;

  const DynamicIconViewer({
    super.key,
    required this.filePath,
    this.size = 24,
    this.color,
    this.revers = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the file extension
    final isSvg = filePath.toLowerCase().endsWith('.svg');

    var icon = isSvg
        ? SvgPicture.asset(
            filePath,
            width: size,
            height: size,
            colorFilter: color != null
                ? ColorFilter.mode(color!, BlendMode.srcIn)
                : ColorFilter.mode(MyColors.iconPrimary, BlendMode.srcIn),
            placeholderBuilder: (BuildContext context) => const Center(
              child: LoadingShimmer(),
            ),
          )
        : color != null
            ? ColorFiltered(
                colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
                child: Image.asset(
                  filePath,
                  width: size,
                  height: size,
                  fit: BoxFit.contain,
                ),
              )
            : Image.asset(
                filePath,
                width: size,
                height: size,
                fit: BoxFit.contain,
              );

    if (!Get.find<LocaleController>().getIsRtl()) {
      icon = Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(3.14159),
        child: icon,
      );
    }

    return icon;
  }
}
