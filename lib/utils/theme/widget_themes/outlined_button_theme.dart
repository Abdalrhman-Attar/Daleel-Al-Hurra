import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../constants/sizes.dart';

class MyOutlinedButtonTheme {
  MyOutlinedButtonTheme._();

  static OutlinedButtonThemeData get lightOutlinedButtonTheme =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: Sizes.elevationNone,
          foregroundColor: MyColors.textPrimary,
          backgroundColor: Colors.transparent,
          disabledForegroundColor: MyColors.textDisabled,
          disabledBackgroundColor: Colors.transparent,
          side: BorderSide(color: MyColors.primary, width: Sizes.borderWidthMd),
          padding: const EdgeInsets.symmetric(
            vertical: Sizes.buttonPaddingVerticalMd,
            horizontal: Sizes.buttonPaddingHorizontalMd,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.buttonRadiusMd)),
          textStyle: TextStyle(
            fontSize: Sizes.fontSizeMd,
            color: MyColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: MyFonts.getFontFamily(),
            letterSpacing: 0.5,
          ),
        ),
      );

  static OutlinedButtonThemeData get darkOutlinedButtonTheme =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: Sizes.elevationNone,
          foregroundColor: MyColors.textPrimaryDark,
          backgroundColor: Colors.transparent,
          disabledForegroundColor: MyColors.textDisabledDark,
          disabledBackgroundColor: Colors.transparent,
          side: BorderSide(
              color: MyColors.primaryDark, width: Sizes.borderWidthMd),
          padding: const EdgeInsets.symmetric(
            vertical: Sizes.buttonPaddingVerticalMd,
            horizontal: Sizes.buttonPaddingHorizontalMd,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.buttonRadiusMd)),
          textStyle: TextStyle(
            fontSize: Sizes.fontSizeMd,
            color: MyColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
            fontFamily: MyFonts.getFontFamily(),
            letterSpacing: 0.5,
          ),
        ),
      );
}
