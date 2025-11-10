import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../constants/sizes.dart';

class MyElevatedButtonTheme {
  MyElevatedButtonTheme._();

  static ElevatedButtonThemeData get lightElevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: Sizes.buttonElevation,
          foregroundColor: MyColors.textOnPrimary,
          backgroundColor: MyColors.primary,
          disabledForegroundColor: MyColors.textDisabled,
          disabledBackgroundColor: MyColors.buttonDisabledBackground,
          side:
              BorderSide(color: MyColors.primary, width: Sizes.borderWidthThin),
          padding: const EdgeInsets.symmetric(
            vertical: Sizes.buttonPaddingVerticalMd,
            horizontal: Sizes.buttonPaddingHorizontalMd,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.buttonRadiusMd)),
          textStyle: TextStyle(
            fontSize: Sizes.fontSizeMd,
            color: MyColors.textOnPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: MyFonts.getFontFamily(),
            letterSpacing: 0.5,
          ),
        ),
      );

  static ElevatedButtonThemeData get darkElevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: Sizes.buttonElevation,
          foregroundColor: MyColors.textOnPrimaryDark,
          backgroundColor: MyColors.primaryDark,
          disabledForegroundColor: MyColors.textDisabledDark,
          disabledBackgroundColor: MyColors.buttonDisabledBackgroundDark,
          side: BorderSide(
              color: MyColors.primaryDark, width: Sizes.borderWidthThin),
          padding: const EdgeInsets.symmetric(
            vertical: Sizes.buttonPaddingVerticalMd,
            horizontal: Sizes.buttonPaddingHorizontalMd,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.buttonRadiusMd)),
          textStyle: TextStyle(
            fontSize: Sizes.fontSizeMd,
            color: MyColors.textOnPrimaryDark,
            fontWeight: FontWeight.w600,
            fontFamily: MyFonts.getFontFamily(),
            letterSpacing: 0.5,
          ),
        ),
      );
}
