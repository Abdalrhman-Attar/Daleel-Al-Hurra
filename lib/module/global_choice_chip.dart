import 'package:flutter/material.dart';

class GlobalChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final bool enabled;
  final TextStyle? labelStyle;
  final Widget? avatar;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? disabledColor;
  final Color? selectedLabelColor;
  final Color? disabledLabelColor;
  final EdgeInsetsGeometry? labelPadding;
  final BorderRadius? borderRadius;
  final BorderSide? side;

  const GlobalChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.enabled = true,
    this.labelStyle,
    this.avatar,
    this.backgroundColor,
    this.selectedColor,
    this.disabledColor,
    this.selectedLabelColor,
    this.disabledLabelColor,
    this.labelPadding,
    this.borderRadius,
    this.side,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = enabled && onSelected != null;
    final effectiveBackground = !isEnabled
        ? (disabledColor ?? theme.disabledColor)
        : (selected
            ? (selectedColor ?? theme.colorScheme.primary)
            : (backgroundColor ?? theme.chipTheme.backgroundColor));
    final effectiveLabelColor = !isEnabled
        ? (disabledLabelColor ?? theme.disabledColor)
        : (selected
            ? (selectedLabelColor ??
                theme.chipTheme.secondaryLabelStyle?.color!)
            : (labelStyle?.color ?? theme.chipTheme.labelStyle?.color!));

    return ChoiceChip(
      label: Text(
        label,
        style: labelStyle ??
            theme.chipTheme.labelStyle?.copyWith(
              color: effectiveLabelColor,
            ),
      ),
      avatar: avatar,
      selected: selected,
      onSelected: isEnabled ? onSelected : null,
      backgroundColor: effectiveBackground,
      selectedColor: effectiveBackground,
      disabledColor: effectiveBackground,
      labelPadding: labelPadding,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        side: side ?? BorderSide.none,
      ),
    );
  }
}
