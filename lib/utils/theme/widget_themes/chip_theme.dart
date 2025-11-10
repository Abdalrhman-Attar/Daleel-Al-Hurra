import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../constants/sizes.dart';

class MyChipTheme {
  MyChipTheme._();

  static ChipThemeData get lightChipTheme => ChipThemeData(
        checkmarkColor: MyColors.textOnPrimary,
        selectedColor: MyColors.primary,
        disabledColor: MyColors.grey200,
        backgroundColor: MyColors.grey100,
        padding: const EdgeInsets.symmetric(
            horizontal: Sizes.spaceSm, vertical: Sizes.spaceXs),
        labelStyle: TextStyle(
          color: MyColors.textPrimary,
          fontSize: Sizes.fontSizeSm,
          fontFamily: MyFonts.getFontFamily(),
          fontWeight: FontWeight.normal,
        ),
        secondaryLabelStyle: TextStyle(
          color: MyColors.textOnPrimary,
          fontSize: Sizes.fontSizeSm,
          fontFamily: MyFonts.getFontFamily(),
          fontWeight: FontWeight.w500,
        ),
        shape: StadiumBorder(
          side: BorderSide(
            color: MyColors.border,
            width: Sizes.borderWidthThin,
          ),
        ),
        elevation: Sizes.elevationNone,
        pressElevation: Sizes.elevationSm,
        iconTheme: IconThemeData(
          color: MyColors.iconSecondary,
          size: Sizes.iconSizeSm,
        ),
        brightness: Brightness.light,
      );

  static ChipThemeData get darkChipTheme => ChipThemeData(
        checkmarkColor: MyColors.textOnPrimaryDark,
        selectedColor: MyColors.primaryDark,
        disabledColor: MyColors.grey700Dark,
        backgroundColor: MyColors.grey800Dark,
        padding: const EdgeInsets.symmetric(
            horizontal: Sizes.spaceSm, vertical: Sizes.spaceXs),
        labelStyle: TextStyle(
          color: MyColors.textPrimaryDark,
          fontSize: Sizes.fontSizeSm,
          fontFamily: MyFonts.getFontFamily(),
          fontWeight: FontWeight.normal,
        ),
        secondaryLabelStyle: TextStyle(
          color: MyColors.textOnPrimaryDark,
          fontSize: Sizes.fontSizeSm,
          fontFamily: MyFonts.getFontFamily(),
          fontWeight: FontWeight.w500,
        ),
        shape: StadiumBorder(
          side: BorderSide(
            color: MyColors.borderDark,
            width: Sizes.borderWidthThin,
          ),
        ),
        elevation: Sizes.elevationNone,
        pressElevation: Sizes.elevationSm,
        iconTheme: IconThemeData(
          color: MyColors.iconSecondaryDark,
          size: Sizes.iconSizeSm,
        ),
        brightness: Brightness.dark,
      );
}
