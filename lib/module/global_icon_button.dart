import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'dynamic_icon_viewer.dart';
import 'global_shimmer.dart';

class GlobalIconButton extends StatefulWidget {
  final IconData? iconData;
  final String? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final Color? iconColor;
  final Color? disabledIconColor;
  final double? iconSize;
  final double? buttonSize;
  final String? tooltip;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? shimmerBaseColor;
  final Color? shimmerHighlightColor;
  final Duration? shimmerPeriod;
  final ScrollController? scrollController;
  final double? transitionOffset;
  final Color? overlayColor;

  const GlobalIconButton({
    super.key,
    this.iconData,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.iconColor,
    this.disabledIconColor,
    this.iconSize,
    this.buttonSize,
    this.tooltip,
    this.borderRadius,
    this.backgroundColor,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.shimmerPeriod,
    this.scrollController,
    this.transitionOffset,
    this.overlayColor,
  });

  @override
  State<GlobalIconButton> createState() => _GlobalIconButtonState();
}

class _GlobalIconButtonState extends State<GlobalIconButton> {
  double opacity = 1.0;

  @override
  void initState() {
    super.initState();
    if (widget.scrollController != null) {
      widget.scrollController!.addListener(_scrollListener);
    }
  }

  @override
  void dispose() {
    if (widget.scrollController != null) {
      widget.scrollController!.removeListener(_scrollListener);
    }
    super.dispose();
  }

  void _scrollListener() {
    var offset = widget.scrollController!.offset;
    var fraction = (offset / widget.transitionOffset!).clamp(0.0, 1.0);
    setState(() {
      opacity = 1.0 - fraction;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIconColor = widget.iconColor ?? theme.colorScheme.primary;
    final effectiveDisabledIconColor = widget.disabledIconColor ??
        theme.colorScheme.onSurface.withValues(alpha: 0.38);
    final effectiveBackgroundColor =
        widget.backgroundColor ?? Colors.transparent;
    final effectiveOverlayColor = widget.overlayColor ?? effectiveIconColor;

    // Calculate the interpolated color for the scroll transition
    final interpolatedColor = widget.scrollController != null
        ? Color.lerp(effectiveOverlayColor, effectiveIconColor, 1.0 - opacity)
        : effectiveIconColor;

    Widget buttonContent = IconButton(
      onPressed:
          (widget.enabled && !widget.isLoading) ? widget.onPressed : null,
      icon: widget.iconData == null && widget.icon == null
          ? const Icon(Icons.error)
          : widget.iconData == null
              ? DynamicIconViewer(
                  filePath: widget.icon ?? '',
                  size: widget.iconSize ?? 24,
                  color: (widget.enabled && !widget.isLoading)
                      ? interpolatedColor
                      : effectiveDisabledIconColor,
                )
              : Icon(
                  widget.iconData,
                  size: widget.iconSize ?? 24,
                  color: (widget.enabled && !widget.isLoading)
                      ? interpolatedColor
                      : effectiveDisabledIconColor,
                ),
      constraints: BoxConstraints.tight(Size.square(widget.buttonSize ?? 48)),
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        backgroundColor: effectiveBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );

    if (widget.tooltip != null) {
      buttonContent = Tooltip(
        message: widget.tooltip!,
        child: buttonContent,
      );
    }

    if (widget.isLoading) {
      buttonContent = GlobalShimmer.wrap(
        baseColor: widget.shimmerBaseColor ??
            effectiveIconColor.withValues(alpha: 0.7),
        highlightColor: widget.shimmerHighlightColor ??
            effectiveIconColor.withValues(alpha: 0.9),
        period: widget.shimmerPeriod ?? const Duration(milliseconds: 1500),
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        direction: ShimmerDirection.ltr,
        child: Container(
          width: widget.buttonSize ?? 48,
          height: widget.buttonSize ?? 48,
          decoration: BoxDecoration(
            color: effectiveBackgroundColor.withValues(alpha: 0.5),
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          ),
          child: Center(
            child: widget.iconData == null && widget.icon == null
                ? const Icon(Icons.error, size: 24)
                : widget.iconData == null
                    ? DynamicIconViewer(
                        filePath: widget.icon ?? '',
                        size: widget.iconSize ?? 24,
                        color: effectiveIconColor.withValues(alpha: 0.5),
                      )
                    : Icon(
                        widget.iconData,
                        size: widget.iconSize ?? 24,
                        color: effectiveIconColor.withValues(alpha: 0.5),
                      ),
          ),
        ),
      );
    }

    return buttonContent;
  }
}
