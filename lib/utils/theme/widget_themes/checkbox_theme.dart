import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class MyCheckboxTheme {
  MyCheckboxTheme._();

  static CheckboxThemeData get lightCheckboxTheme => CheckboxThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.xs)),
        checkColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? MyColors.white
                : MyColors.transparent),
        fillColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? MyColors.primary
                : MyColors.transparent),
        side: WidgetStateBorderSide.resolveWith(
          (states) => states.contains(WidgetState.disabled)
              ? BorderSide(width: 1.5, color: MyColors.textDisabled)
              : states.contains(WidgetState.selected)
                  ? BorderSide(width: 2, color: MyColors.primary)
                  : BorderSide(width: 2, color: MyColors.grey500),
        ),
        visualDensity: VisualDensity.compact,
        splashRadius: Sizes.sm * 2,
      );

  static CheckboxThemeData get darkCheckboxTheme => CheckboxThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.xs)),
        checkColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? MyColors.white
                : MyColors.transparent),
        fillColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? MyColors.primaryDark
                : MyColors.transparent),
        side: WidgetStateBorderSide.resolveWith(
          (states) => states.contains(WidgetState.disabled)
              ? BorderSide(width: 1.5, color: MyColors.textDisabledDark)
              : states.contains(WidgetState.selected)
                  ? BorderSide(width: 2, color: MyColors.primaryDark)
                  : BorderSide(width: 2, color: MyColors.grey400Dark),
        ),
        visualDensity: VisualDensity.compact,
        splashRadius: Sizes.sm * 2,
      );
}
