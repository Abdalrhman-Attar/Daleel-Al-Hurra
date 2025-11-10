import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'global_shimmer.dart';

class GlobalOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final Color? borderColor;
  final Color? foregroundColor;
  final Color? disabledBorderColor;
  final Color? disabledForegroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? borderWidth;
  final Widget? icon;
  final String? tooltip;
  final TextStyle? textStyle;
  final double? width;
  final bool isMinimumWidth;
  final double? height;
  final Color? shimmerBaseColor;
  final Color? shimmerHighlightColor;
  final Duration? shimmerPeriod;
  final bool enableBlur;

  const GlobalOutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.borderColor,
    this.foregroundColor,
    this.disabledBorderColor,
    this.disabledForegroundColor,
    this.borderRadius,
    this.padding,
    this.borderWidth,
    this.icon,
    this.tooltip,
    this.textStyle,
    this.width,
    this.isMinimumWidth = true,
    this.height,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.shimmerPeriod,
    this.enableBlur = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBorderColor = borderColor ?? theme.colorScheme.primary;
    final effectiveForegroundColor =
        foregroundColor ?? theme.colorScheme.primary;
    final effectiveDisabledBorderColor = disabledBorderColor ??
        theme.colorScheme.onSurface.withValues(alpha: 0.12);
    final effectiveDisabledForegroundColor = disabledForegroundColor ??
        theme.colorScheme.onSurface.withValues(alpha: 0.38);
    // calculate minimum width based on the text length
    final textWidth = (text.length * 8.0)
        .clamp(0, 200.0); // assuming average character width of 8.0
    final minimumWidth = textWidth + 32; // adding padding for better appearance
    Widget buttonContent = SizedBox(
      width:
          width ?? (isMinimumWidth ? minimumWidth.toDouble() : double.infinity),
      height: height ?? 50,
      child: enableBlur
          ? _buildBlurButton(
              context,
              effectiveBorderColor,
              effectiveForegroundColor,
              effectiveDisabledBorderColor,
              effectiveDisabledForegroundColor,
              theme,
              minimumWidth.toDouble(),
            )
          : _buildRegularButton(
              context,
              effectiveBorderColor,
              effectiveForegroundColor,
              effectiveDisabledBorderColor,
              effectiveDisabledForegroundColor,
              theme,
              minimumWidth.toDouble(),
            ),
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
        child: GlobalShimmer.wrap(
          baseColor:
              shimmerBaseColor ?? effectiveBorderColor.withValues(alpha: 0.7),
          highlightColor: shimmerHighlightColor ??
              effectiveBorderColor.withValues(alpha: 0.9),
          period: shimmerPeriod ?? const Duration(milliseconds: 1500),
          direction: ShimmerDirection.ltr,
          child: Container(
            width: width ??
                (isMinimumWidth ? minimumWidth.toDouble() : double.infinity),
            height: height ?? 40,
            decoration: BoxDecoration(
              border: Border.all(
                color: effectiveBorderColor.withValues(alpha: 0.5),
                width: borderWidth ?? 1.5,
              ),
              borderRadius: borderRadius ?? BorderRadius.circular(8),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: textStyle ??
                        theme.textTheme.labelLarge?.copyWith(
                          color:
                              effectiveForegroundColor.withValues(alpha: 0.5),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return buttonContent;
  }

  Widget _buildRegularButton(
    BuildContext context,
    Color effectiveBorderColor,
    Color effectiveForegroundColor,
    Color effectiveDisabledBorderColor,
    Color effectiveDisabledForegroundColor,
    ThemeData theme,
    double minimumWidth,
  ) {
    return OutlinedButton(
      onPressed: (enabled && !isLoading) ? onPressed : null,
      style: OutlinedButton.styleFrom(
        foregroundColor: effectiveForegroundColor,
        disabledForegroundColor: effectiveDisabledForegroundColor,
        side: BorderSide(
          color: (enabled && !isLoading)
              ? effectiveBorderColor
              : effectiveDisabledBorderColor,
          width: borderWidth ?? 1.5,
        ),
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: textStyle ??
                theme.textTheme.labelLarge?.copyWith(
                  color: (enabled && !isLoading)
                      ? effectiveForegroundColor
                      : effectiveDisabledForegroundColor,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurButton(
    BuildContext context,
    Color effectiveBorderColor,
    Color effectiveForegroundColor,
    Color effectiveDisabledBorderColor,
    Color effectiveDisabledForegroundColor,
    ThemeData theme,
    double minimumWidth,
  ) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: width ??
              (isMinimumWidth ? minimumWidth.toDouble() : double.infinity),
          height: height ?? 50,
          decoration: BoxDecoration(
            color: (enabled && !isLoading)
                ? effectiveBorderColor.withValues(alpha: 0.2)
                : effectiveDisabledBorderColor.withValues(alpha: 0.2),
            borderRadius: borderRadius ?? BorderRadius.circular(8),
            border: Border.all(
              color: (enabled && !isLoading)
                  ? effectiveBorderColor.withValues(alpha: 0.3)
                  : effectiveDisabledBorderColor.withValues(alpha: 0.3),
              width: borderWidth ?? 1.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: (enabled && !isLoading) ? onPressed : null,
              borderRadius: borderRadius ?? BorderRadius.circular(8),
              child: Padding(
                padding: padding ??
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      icon!,
                      const SizedBox(width: 8),
                    ],
                    Text(
                      text,
                      style: textStyle ??
                          theme.textTheme.labelLarge?.copyWith(
                            color: (enabled && !isLoading)
                                ? effectiveForegroundColor
                                : effectiveDisabledForegroundColor,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
