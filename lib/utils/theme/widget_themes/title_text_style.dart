import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../constants/sizes.dart';

class MyTitleTextStyle {
  MyTitleTextStyle._();

  static TextStyle get lightAppBarTitle => TextStyle(
        fontSize: Sizes.fontSizeLg,
        fontWeight: FontWeight.w600,
        color: MyColors.textPrimary,
        fontFamily: MyFonts.getFontFamily(),
        letterSpacing: 0.15,
        height: 1.2,
      );

  static TextStyle get darkAppBarTitle => TextStyle(
        fontSize: Sizes.fontSizeLg,
        fontWeight: FontWeight.w600,
        color: MyColors.textPrimaryDark,
        fontFamily: MyFonts.getFontFamily(),
        letterSpacing: 0.15,
        height: 1.2,
      );

  static TextStyle get lightSectionTitleLarge => TextStyle(
        fontSize: Sizes.fontSizeXxl,
        fontWeight: FontWeight.bold,
        color: MyColors.textPrimary,
        fontFamily: MyFonts.getFontFamily(),
        letterSpacing: 0.2,
        height: 1.3,
      );

  static TextStyle get darkSectionTitleLarge => TextStyle(
        fontSize: Sizes.fontSizeXxl,
        fontWeight: FontWeight.bold,
        color: MyColors.textPrimaryDark,
        fontFamily: MyFonts.getFontFamily(),
        letterSpacing: 0.2,
        height: 1.3,
      );

  static TextStyle get lightSectionTitleMedium => TextStyle(
        fontSize: Sizes.fontSizeXl,
        fontWeight: FontWeight.w600,
        color: MyColors.textPrimary,
        fontFamily: MyFonts.getFontFamily(),
        letterSpacing: 0.15,
        height: 1.2,
      );

  static TextStyle get darkSectionTitleMedium => TextStyle(
        fontSize: Sizes.fontSizeXl,
        fontWeight: FontWeight.w600,
        color: MyColors.textPrimaryDark,
        fontFamily: MyFonts.getFontFamily(),
        letterSpacing: 0.15,
        height: 1.2,
      );

  static TextStyle get lightDialogTitle => TextStyle(
        fontSize: Sizes.fontSizeXl,
        fontWeight: FontWeight.w700,
        color: MyColors.textPrimary,
        fontFamily: MyFonts.getFontFamily(),
        letterSpacing: 0.1,
        height: 1.2,
      );

  static TextStyle get darkDialogTitle => TextStyle(
        fontSize: Sizes.fontSizeXl,
        fontWeight: FontWeight.w700,
        color: MyColors.textPrimaryDark,
        fontFamily: MyFonts.getFontFamily(),
        letterSpacing: 0.1,
        height: 1.2,
      );

  static TextStyle get lightCardHeader => TextStyle(
        fontSize: Sizes.fontSizeLg,
        fontWeight: FontWeight.w600,
        color: MyColors.textPrimary,
        fontFamily: MyFonts.getFontFamily(),
        letterSpacing: 0.05,
        height: 1.15,
      );

  static TextStyle get darkCardHeader => TextStyle(
        fontSize: Sizes.fontSizeLg,
        fontWeight: FontWeight.w600,
        color: MyColors.textPrimaryDark,
        fontFamily: MyFonts.getFontFamily(),
        letterSpacing: 0.05,
        height: 1.15,
      );
}
