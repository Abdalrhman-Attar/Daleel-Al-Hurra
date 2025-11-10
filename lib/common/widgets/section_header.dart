import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.textButtonTitle,
    this.onPressed,
    this.icon = Icons.arrow_forward_ios,
    this.padding = 20,
    this.textButtonColor,
  });

  final String title;
  final String? textButtonTitle;
  final void Function()? onPressed;
  final IconData? icon;
  final double padding;
  final Color? textButtonColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (textButtonTitle != null && onPressed != null)
            SizedBox(
              height: 20,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
                onPressed: onPressed,
                child: Row(
                  children: [
                    Text(
                      textButtonTitle!,
                      style: TextStyle(
                        color: textButtonColor ?? const Color(0xffADAB80),
                        fontSize: 12,
                      ),
                    ),
                    if (icon != null) const SizedBox(width: 4),
                    if (icon != null)
                      Icon(
                        icon,
                        size: 16,
                        color: const Color(0xffADAB80),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
