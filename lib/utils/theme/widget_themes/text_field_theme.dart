import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../constants/sizes.dart';

class MyTextFormFieldTheme {
  MyTextFormFieldTheme._();

  static InputDecorationTheme get lightInputDecorationTheme =>
      InputDecorationTheme(
        errorMaxLines: 3,
        prefixIconColor: MyColors.iconSecondary,
        suffixIconColor: MyColors.iconSecondary,
        labelStyle: TextStyle(
          fontSize: Sizes.fontSizeMd,
          color: MyColors.textSecondary,
          fontFamily: MyFonts.getFontFamily(),
        ),
        hintStyle: TextStyle(
          fontSize: Sizes.fontSizeSm,
          color: MyColors.textSecondary,
          fontFamily: MyFonts.getFontFamily(),
        ),
        errorStyle: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
          fontSize: Sizes.fontSizeXs,
          color: MyColors.error,
          fontFamily: MyFonts.getFontFamily(),
        ),
        floatingLabelStyle: TextStyle(
          color: MyColors.primary.withValues(alpha: 0.85),
          fontSize: Sizes.fontSizeMd,
          fontFamily: MyFonts.getFontFamily(),
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.inputFieldRadius),
          borderSide:
              BorderSide(width: Sizes.borderWidthThin, color: MyColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.inputFieldRadius),
          borderSide:
              BorderSide(width: Sizes.borderWidthThin, color: MyColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.inputFieldRadius),
          borderSide:
              BorderSide(width: Sizes.borderWidthMd, color: MyColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.inputFieldRadius),
          borderSide:
              BorderSide(width: Sizes.borderWidthThin, color: MyColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.inputFieldRadius),
          borderSide:
              BorderSide(width: Sizes.borderWidthMd, color: MyColors.error),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.inputFieldRadius),
          borderSide:
              BorderSide(width: Sizes.borderWidthThin, color: MyColors.grey300),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Sizes.inputFieldPaddingHorizontal,
          vertical: Sizes.inputFieldPaddingVertical,
        ),
        filled: true,
        fillColor: MyColors.inputBackground,
      );

  static InputDecorationTheme get darkInputDecorationTheme =>
      InputDecorationTheme(
        errorMaxLines: 3,
        prefixIconColor: MyColors.iconSecondaryDark,
        suffixIconColor: MyColors.iconSecondaryDark,
        labelStyle: TextStyle(
          fontSize: Sizes.fontSizeMd,
          color: MyColors.textSecondaryDark,
          fontFamily: MyFonts.getFontFamily(),
        ),
        hintStyle: TextStyle(
          fontSize: Sizes.fontSizeSm,
          color: MyColors.textSecondaryDark,
          fontFamily: MyFonts.getFontFamily(),
        ),
        errorStyle: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
          fontSize: Sizes.fontSizeXs,
          color: MyColors.errorDark,
          fontFamily: MyFonts.getFontFamily(),
        ),
        floatingLabelStyle: TextStyle(
          color: MyColors.primaryDark.withValues(alpha: 0.85),
          fontSize: Sizes.fontSizeMd,
          fontFamily: MyFonts.getFontFamily(),
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.inputFieldRadius),
          borderSide: BorderSide(
              width: Sizes.borderWidthThin, color: MyColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.inputFieldRadius),
          borderSide: BorderSide(
              width: Sizes.borderWidthThin, color: MyColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.inputFieldRadius),
          borderSide: BorderSide(
              width: Sizes.borderWidthMd, color: MyColors.primaryDark),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.inputFieldRadius),
          borderSide: BorderSide(
              width: Sizes.borderWidthThin, color: MyColors.errorDark),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.inputFieldRadius),
          borderSide:
              BorderSide(width: Sizes.borderWidthMd, color: MyColors.errorDark),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.inputFieldRadius),
          borderSide: BorderSide(
              width: Sizes.borderWidthThin, color: MyColors.grey700Dark),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Sizes.inputFieldPaddingHorizontal,
          vertical: Sizes.inputFieldPaddingVertical,
        ),
        filled: true,
        fillColor: MyColors.inputBackgroundDark,
      );
}
