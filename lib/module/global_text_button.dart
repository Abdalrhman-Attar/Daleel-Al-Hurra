import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'global_shimmer.dart';

class GlobalTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final Color? foregroundColor;
  final Color? disabledForegroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final double? width;
  final bool isMinimumWidth;

  final double? height;
  final String? tooltip;
  final Color? shimmerBaseColor;
  final Color? shimmerHighlightColor;
  final Duration? shimmerPeriod;
  final Widget? trailingIcon;

  const GlobalTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.foregroundColor,
    this.disabledForegroundColor,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.width,
    this.isMinimumWidth = true,
    this.height,
    this.tooltip,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.shimmerPeriod,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveForegroundColor =
        foregroundColor ?? theme.colorScheme.primary;
    final effectiveDisabledForegroundColor = disabledForegroundColor ??
        theme.colorScheme.onSurface.withValues(alpha: 0.38);
    // calculate minimum width based on the text length
    final textWidth = (text.length * 8.0)
        .clamp(0, 200.0); // assuming average character width of 8.0
    final iconWidth = trailingIcon != null ? 24.0 : 0.0; // assuming icon width
    final minimumWidth =
        textWidth + iconWidth - 10; // adding padding for better appearance
    Widget buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: textStyle ??
              theme.textTheme.labelLarge?.copyWith(
                color: (enabled && !isLoading)
                    ? effectiveForegroundColor
                    : effectiveDisabledForegroundColor,
              ),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: 8),
          trailingIcon!,
        ],
      ],
    );

    Widget buttonContent = TextButton(
      onPressed: (enabled && !isLoading) ? onPressed : null,
      style: TextButton.styleFrom(
        foregroundColor: effectiveForegroundColor,
        disabledForegroundColor: effectiveDisabledForegroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: Size(
            width ??
                (isMinimumWidth ? minimumWidth.toDouble() : double.infinity),
            height ?? 40),
      ),
      child: buttonChild,
    );

    if (tooltip != null) {
      buttonContent = Tooltip(
        message: tooltip!,
        child: buttonContent,
      );
    }

    if (isLoading) {
      buttonContent = Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: GlobalShimmer(
          baseColor: shimmerBaseColor ??
              effectiveForegroundColor.withValues(alpha: 0.7),
          highlightColor: shimmerHighlightColor ??
              effectiveForegroundColor.withValues(alpha: 0.9),
          period: shimmerPeriod ?? const Duration(milliseconds: 1500),
          direction: ShimmerDirection.ltr,
          child: Container(
            width: width ??
                (isMinimumWidth ? minimumWidth.toDouble() : double.infinity),
            height: height ?? 40,
            decoration: BoxDecoration(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
            ),
            child: Center(
              child: buttonChild,
            ),
          ),
        ),
      );
    }

    return buttonContent;
  }
}
