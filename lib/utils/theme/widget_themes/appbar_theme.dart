import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

import 'icon_theme.dart';
import 'title_text_style.dart';

class MyAppBarTheme {
  MyAppBarTheme._();

  static AppBarTheme get lightAppBarTheme => AppBarTheme(
        elevation: Sizes.elevationNone,
        centerTitle: false,
        scrolledUnderElevation: Sizes.elevationNone,
        backgroundColor: MyColors.backgroundLight,
        surfaceTintColor: MyColors.transparent,
        iconTheme: MyIconTheme.lightIconTheme,
        actionsIconTheme: MyIconTheme.lightIconTheme,
        titleTextStyle: MyTitleTextStyle.lightAppBarTitle,
      );

  static AppBarTheme get darkAppBarTheme => AppBarTheme(
        elevation: Sizes.elevationNone,
        centerTitle: false,
        scrolledUnderElevation: Sizes.elevationNone,
        backgroundColor: MyColors.backgroundDark,
        surfaceTintColor: MyColors.transparent,
        iconTheme: MyIconTheme.darkIconTheme,
        actionsIconTheme: MyIconTheme.darkIconTheme,
        titleTextStyle: MyTitleTextStyle.darkAppBarTitle,
      );
}
