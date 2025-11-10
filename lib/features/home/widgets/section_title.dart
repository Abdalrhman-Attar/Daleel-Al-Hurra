import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry? padding;
  final String? textButtonText;
  final VoidCallback? onTextButtonTap;
  final Widget? trailingWidget;

  const SectionTitle(
    this.text, {
    super.key,
    this.padding,
    this.textButtonText,
    this.onTextButtonTap,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  //margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: MyColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  text.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                if (trailingWidget != null) ...[
                  const Spacer(),
                  trailingWidget!,
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
