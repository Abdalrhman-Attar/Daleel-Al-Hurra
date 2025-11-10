import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class MyBottomSheetTheme {
  MyBottomSheetTheme._();

  static BottomSheetThemeData get lightBottomSheetTheme => BottomSheetThemeData(
        showDragHandle: true,
        backgroundColor: MyColors.surface,
        modalBackgroundColor: MyColors.surface,
        surfaceTintColor: MyColors.transparent,
        dragHandleColor: MyColors.grey500,
        elevation: Sizes.elevationMd,
        modalElevation: Sizes.elevationMd,
        constraints: const BoxConstraints(minWidth: double.infinity),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Sizes.radiusLg),
            topRight: Radius.circular(Sizes.radiusLg),
          ),
        ),
      );

  static BottomSheetThemeData get darkBottomSheetTheme => BottomSheetThemeData(
        showDragHandle: true,
        backgroundColor: MyColors.surfaceDark,
        modalBackgroundColor: MyColors.surfaceDark,
        surfaceTintColor: MyColors.transparent,
        dragHandleColor: MyColors.grey400Dark,
        elevation: Sizes.elevationMd,
        modalElevation: Sizes.elevationMd,
        constraints: const BoxConstraints(minWidth: double.infinity),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Sizes.radiusLg),
            topRight: Radius.circular(Sizes.radiusLg),
          ),
        ),
      );
}
