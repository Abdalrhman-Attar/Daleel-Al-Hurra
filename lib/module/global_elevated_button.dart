import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/constants/colors.dart';
import 'global_shimmer.dart';

class GlobalElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
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

  const GlobalElevatedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.borderRadius,
    this.padding,
    this.elevation,
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
    final effectiveBackgroundColor =
        backgroundColor ?? theme.colorScheme.primary;
    final effectiveForegroundColor =
        foregroundColor ?? theme.colorScheme.onPrimary;
    final effectiveDisabledBackgroundColor = disabledBackgroundColor ??
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
              effectiveBackgroundColor,
              effectiveForegroundColor,
              effectiveDisabledBackgroundColor,
              effectiveDisabledForegroundColor,
              theme,
              minimumWidth.toDouble(),
            )
          : _buildRegularButton(
              context,
              effectiveBackgroundColor,
              effectiveForegroundColor,
              effectiveDisabledBackgroundColor,
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
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child: GlobalShimmer.wrap(
          baseColor: shimmerBaseColor ??
              effectiveBackgroundColor.withValues(alpha: 0.6),
          highlightColor: shimmerHighlightColor ??
              effectiveBackgroundColor.withValues(alpha: 0.9),
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          period: shimmerPeriod ?? const Duration(milliseconds: 1500),
          direction: ShimmerDirection.ltr,
          child: Container(
            width: width ??
                (isMinimumWidth ? minimumWidth.toDouble() : double.infinity),
            height: height ?? 50,
            decoration: BoxDecoration(
              color: MyColors.transparent,
              borderRadius: borderRadius ?? BorderRadius.circular(5),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: textStyle ??
                        theme.textTheme.labelLarge?.copyWith(
                          color: MyColors.white.withValues(alpha: 0.7),
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
    Color effectiveBackgroundColor,
    Color effectiveForegroundColor,
    Color effectiveDisabledBackgroundColor,
    Color effectiveDisabledForegroundColor,
    ThemeData theme,
    double minimumWidth,
  ) {
    return ElevatedButton(
      onPressed: (enabled && !isLoading) ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: effectiveBackgroundColor,
        foregroundColor: effectiveForegroundColor,
        disabledBackgroundColor: effectiveDisabledBackgroundColor,
        disabledForegroundColor: effectiveDisabledForegroundColor,
        side: BorderSide.none,
        elevation: elevation ?? 0,
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
    Color effectiveBackgroundColor,
    Color effectiveForegroundColor,
    Color effectiveDisabledBackgroundColor,
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
                ? effectiveBackgroundColor.withValues(alpha: 0.2)
                : effectiveDisabledBackgroundColor.withValues(alpha: 0.2),
            borderRadius: borderRadius ?? BorderRadius.circular(8),
            border: Border.all(
              color: (enabled && !isLoading)
                  ? effectiveBackgroundColor.withValues(alpha: 0.3)
                  : effectiveDisabledBackgroundColor.withValues(alpha: 0.3),
              width: 1,
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
