import 'package:flutter/material.dart';

import '../utils/constants/colors.dart';

class GlobalSlider extends StatefulWidget {
  final String? identifier;
  final String? label;
  final double min;
  final double max;
  final double value;
  final void Function(double) onChanged;
  final int? divisions;
  final String? minLabel;
  final String? maxLabel;
  final bool enabled;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final String? Function(double)? valueFormatter;
  final bool showLabels;
  final bool showCurrentValue;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const GlobalSlider({
    super.key,
    this.identifier,
    this.label,
    required this.min,
    required this.max,
    required this.value,
    required this.onChanged,
    this.divisions,
    this.minLabel,
    this.maxLabel,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.valueFormatter,
    this.showLabels = true,
    this.showCurrentValue = true,
    this.padding,
    this.height,
    this.labelStyle,
    this.valueStyle,
  })  : assert(min < max),
        assert(value >= min && value <= max);

  @override
  State<GlobalSlider> createState() => _GlobalSliderState();
}

class _GlobalSliderState extends State<GlobalSlider> with SingleTickerProviderStateMixin {
  late double _currentValue;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(GlobalSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setState(() {
        _currentValue = widget.value;
      });
    }
  }

  String _formatValue(double value) {
    if (widget.valueFormatter != null) {
      return widget.valueFormatter!(value) ?? value.toString();
    }
    return value.toStringAsFixed(widget.divisions == null ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: widget.enabled ? MyColors.white : colorScheme.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: MyColors.grey.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: MyColors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with label and current value
              if (widget.identifier != null || widget.label != null) _buildHeader(theme, colorScheme),

              if (widget.identifier != null || widget.label != null) const SizedBox(height: 8),

              // Slider with enhanced styling
              _buildSliderSection(theme, colorScheme),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Label
        Expanded(
          child: Text(
            widget.identifier ?? widget.label ?? '',
            style: widget.labelStyle ??
                theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: widget.enabled ? colorScheme.onSurface : colorScheme.onSurface.withValues(alpha: 0.5),
                ),
          ),
        ),

        const SizedBox(width: 12),

        // Current value badge
        if (widget.showCurrentValue)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: widget.enabled ? (widget.activeColor ?? colorScheme.primary).withValues(alpha: 0.08) : colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.enabled ? (widget.activeColor ?? colorScheme.primary).withValues(alpha: 0.2) : colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Text(
              _formatValue(_currentValue),
              style: widget.valueStyle ??
                  theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: widget.enabled ? (widget.activeColor ?? colorScheme.primary) : colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
            ),
          ),
      ],
    );
  }

  Widget _buildSliderSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        // Min/Max labels - aligned with slider track
        if (widget.showLabels)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLabel(
                  widget.minLabel ?? _formatValue(widget.min),
                  theme,
                  colorScheme,
                ),
                _buildLabel(
                  widget.maxLabel ?? _formatValue(widget.max),
                  theme,
                  colorScheme,
                ),
              ],
            ),
          ),

        if (widget.showLabels) const SizedBox(height: 4),

        // Enhanced slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: widget.enabled ? (widget.activeColor ?? colorScheme.primary) : colorScheme.outline.withValues(alpha: 0.3),
            inactiveTrackColor: widget.enabled ? (widget.inactiveColor ?? colorScheme.outline.withValues(alpha: 0.2)) : colorScheme.outline.withValues(alpha: 0.1),
            thumbColor: widget.enabled ? (widget.thumbColor ?? colorScheme.surface) : colorScheme.surface.withValues(alpha: 0.5),
            overlayColor: widget.enabled ? (widget.activeColor ?? colorScheme.primary).withValues(alpha: 0.08) : Colors.transparent,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 10,
              disabledThumbRadius: 8,
              elevation: 2,
            ),
            trackHeight: 4,
            trackShape: const RoundedRectSliderTrackShape(),
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: widget.activeColor ?? colorScheme.primary,
            valueIndicatorTextStyle: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
            showValueIndicator: ShowValueIndicator.onlyForDiscrete,
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            value: _currentValue,
            min: widget.min,
            max: widget.max,
            divisions: widget.divisions,
            label: widget.divisions != null ? _formatValue(_currentValue) : null,
            onChanged: widget.enabled
                ? (double value) {
                    setState(() {
                      _currentValue = value;
                    });
                    widget.onChanged(value);
                  }
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 10,
          color: widget.enabled ? colorScheme.onSurfaceVariant : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class GlobalSliderRange extends StatefulWidget {
  final String? identifier;
  final String? label;
  final double min;
  final double max;
  final RangeValues values;
  final void Function(RangeValues) onChanged;
  final int? divisions;
  final String? minLabel;
  final String? maxLabel;
  final bool enabled;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final String? Function(double)? valueFormatter;
  final bool showLabels;
  final bool showCurrentValues;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  GlobalSliderRange({
    super.key,
    this.identifier,
    this.label,
    required this.min,
    required this.max,
    required this.values,
    required this.onChanged,
    this.divisions,
    this.minLabel,
    this.maxLabel,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.valueFormatter,
    this.showLabels = true,
    this.showCurrentValues = true,
    this.padding,
    this.height,
    this.labelStyle,
    this.valueStyle,
  })  : assert(min < max),
        assert(values.start >= min && values.end <= max);

  @override
  State<GlobalSliderRange> createState() => _GlobalSliderRangeState();
}

class _GlobalSliderRangeState extends State<GlobalSliderRange> with SingleTickerProviderStateMixin {
  late RangeValues _currentValues;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _currentValues = widget.values;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(GlobalSliderRange oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.values != widget.values) {
      setState(() {
        _currentValues = widget.values;
      });
    }
  }

  String _formatValue(double value) {
    if (widget.valueFormatter != null) {
      return widget.valueFormatter!(value) ?? value.toString();
    }
    return value.toStringAsFixed(widget.divisions == null ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: widget.enabled ? MyColors.white : colorScheme.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: MyColors.grey.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: MyColors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with label and current values
              if (widget.identifier != null || widget.label != null) _buildHeader(theme, colorScheme),

              if (widget.identifier != null || widget.label != null) const SizedBox(height: 8),

              // Range slider with enhanced styling
              _buildSliderSection(theme, colorScheme),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Label
        Expanded(
          child: Text(
            widget.identifier ?? widget.label ?? '',
            style: widget.labelStyle ??
                theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: widget.enabled ? colorScheme.onSurface : colorScheme.onSurface.withValues(alpha: 0.5),
                ),
          ),
        ),

        const SizedBox(width: 12),

        // Current values badge
        if (widget.showCurrentValues)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: widget.enabled ? (widget.activeColor ?? colorScheme.primary).withValues(alpha: 0.08) : colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.enabled ? (widget.activeColor ?? colorScheme.primary).withValues(alpha: 0.2) : colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Text(
              '${_formatValue(_currentValues.start)} - ${_formatValue(_currentValues.end)}',
              style: widget.valueStyle ??
                  theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: widget.enabled ? (widget.activeColor ?? colorScheme.primary) : colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
            ),
          ),
      ],
    );
  }

  Widget _buildSliderSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        // Min/Max labels - aligned with slider track
        if (widget.showLabels)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildRangeLabel(
                  widget.minLabel ?? _formatValue(widget.min),
                  theme,
                  colorScheme,
                ),
                _buildRangeLabel(
                  widget.maxLabel ?? _formatValue(widget.max),
                  theme,
                  colorScheme,
                ),
              ],
            ),
          ),

        if (widget.showLabels) const SizedBox(height: 4),

        // Enhanced range slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: widget.enabled ? (widget.activeColor ?? colorScheme.primary) : colorScheme.outline.withValues(alpha: 0.3),
            inactiveTrackColor: widget.enabled ? (widget.inactiveColor ?? colorScheme.outline.withValues(alpha: 0.2)) : colorScheme.outline.withValues(alpha: 0.1),
            thumbColor: widget.enabled ? (widget.thumbColor ?? colorScheme.surface) : colorScheme.surface.withValues(alpha: 0.5),
            overlayColor: widget.enabled ? (widget.activeColor ?? colorScheme.primary).withValues(alpha: 0.08) : Colors.transparent,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 10,
              disabledThumbRadius: 8,
              elevation: 2,
            ),
            rangeThumbShape: const RoundRangeSliderThumbShape(
              enabledThumbRadius: 10,
              disabledThumbRadius: 8,
              elevation: 2,
            ),
            trackHeight: 4,
            rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: widget.activeColor ?? colorScheme.primary,
            valueIndicatorTextStyle: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
            showValueIndicator: ShowValueIndicator.onlyForDiscrete,
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: RangeSlider(
            values: _currentValues,
            min: widget.min,
            max: widget.max,
            divisions: widget.divisions,
            labels: widget.divisions != null
                ? RangeLabels(
                    _formatValue(_currentValues.start),
                    _formatValue(_currentValues.end),
                  )
                : null,
            onChanged: widget.enabled
                ? (RangeValues values) {
                    setState(() {
                      _currentValues = values;
                    });
                    widget.onChanged(values);
                  }
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildRangeLabel(String text, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 10,
          color: widget.enabled ? colorScheme.onSurfaceVariant : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
