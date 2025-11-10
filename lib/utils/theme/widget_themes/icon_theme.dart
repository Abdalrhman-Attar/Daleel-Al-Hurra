import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class MyIconTheme {
  MyIconTheme._();

  static IconThemeData get lightIconTheme => IconThemeData(
        color: MyColors.iconPrimary,
        size: Sizes.iconSizeMd,
      );

  static IconThemeData get darkIconTheme => IconThemeData(
        color: MyColors.iconPrimaryDark,
        size: Sizes.iconSizeMd,
      );

  static IconThemeData get lightIconOnPrimaryTheme => IconThemeData(
        color: MyColors.iconOnPrimary,
        size: Sizes.iconSizeMd,
      );

  static IconThemeData get darkIconOnPrimaryTheme => IconThemeData(
        color: MyColors.iconOnPrimaryDark,
        size: Sizes.iconSizeMd,
      );

  static IconThemeData get lightIconSecondaryTheme => IconThemeData(
        color: MyColors.iconSecondary,
        size: Sizes.iconSizeSm,
      );

  static IconThemeData get darkIconSecondaryTheme => IconThemeData(
        color: MyColors.iconSecondaryDark,
        size: Sizes.iconSizeSm,
      );
}
