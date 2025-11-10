import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../utils/constants/colors.dart'; // Adjust import path as needed

class GlobalPinInput extends StatefulWidget {
  // Core properties
  final int length;
  final TextEditingController controller;

  // Styling properties matching GlobalTextFormField
  final Color focusedBorderColor;
  final Color? fillColor;
  final bool filled;
  final bool enableBlur;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final double width;
  final double height;

  // Functionality properties
  final Function(String)? onCompleted;
  final Function(String)? onChanged;
  final bool enabled;
  final String? errorText;
  final HapticFeedbackType hapticFeedbackType;

  // Header properties matching GlobalTextFormField
  final String? identifier;
  final String? infoLabel;
  final VoidCallback? onInfoLabelTap;

  // Validation properties
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;

  // Focus properties
  final bool autofocus;
  final FocusNode? focusNode;

  // Additional styling
  final TextStyle? textStyle;
  final Color? cursorColor;
  final double? spacing;

  const GlobalPinInput({
    super.key,
    required this.length,
    required this.controller,
    this.focusedBorderColor = Colors.black,
    this.fillColor,
    this.filled = false,
    this.enableBlur = false,
    this.borderRadius,
    this.contentPadding,
    this.width = 56,
    this.height = 60,
    this.onCompleted,
    this.onChanged,
    this.enabled = true,
    this.errorText,
    this.hapticFeedbackType = HapticFeedbackType.lightImpact,
    this.identifier,
    this.infoLabel,
    this.onInfoLabelTap,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.autofocus = false,
    this.focusNode,
    this.textStyle,
    this.cursorColor,
    this.spacing,
  });

  @override
  State<GlobalPinInput> createState() => _GlobalPinInputState();
}

class _GlobalPinInputState extends State<GlobalPinInput> {
  late FocusNode _focusNode;
  String? _localErrorText;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  // Get effective colors and styles
  Color get _effectiveFillColor {
    return widget.fillColor ??
        (widget.enableBlur ? Colors.white : MyColors.white);
  }

  BorderRadius get _effectiveBorderRadius {
    return widget.borderRadius ?? BorderRadius.circular(12);
  }

  TextStyle get _effectiveTextStyle {
    return widget.textStyle ??
        Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: widget.enabled ? MyColors.white : MyColors.grey,
            ) ??
        const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
        );
  }

  Color get _effectiveCursorColor {
    return widget.cursorColor ?? Theme.of(context).colorScheme.primary;
  }

  // Get effective error text
  String? get _effectiveErrorText {
    return widget.errorText ?? _localErrorText;
  }

  // Handle validation
  void _handleValidation(String value) {
    if (widget.validator != null) {
      final error = widget.validator!(value);
      if (mounted && error != _localErrorText) {
        setState(() {
          _localErrorText = error;
        });
      }
    }
  }

  // Handle pin changes
  void _handleOnChanged(String value) {
    widget.onChanged?.call(value);
    _handleValidation(value);
  }

  // Handle pin completion
  void _handleOnCompleted(String value) {
    widget.onCompleted?.call(value);
    _handleValidation(value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          _buildPinInput(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    if (widget.identifier == null && widget.infoLabel == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.identifier != null)
            Expanded(
              child: Text(
                widget.identifier!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          if (widget.infoLabel != null) _buildInfoIcon(),
        ],
      ),
    );
  }

  Widget _buildInfoIcon() {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: widget.onInfoLabelTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(
          Icons.info_outline,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildPinInput(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: widget.width,
      height: widget.height,
      textStyle: _effectiveTextStyle,
      decoration: BoxDecoration(
        color: Colors.transparent, // Transparent to work with blur
        borderRadius: _effectiveBorderRadius,
        border: Border.all(
          color: MyColors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
    );

    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          // Blur background for each pin field
          if (widget.enableBlur) _buildBlurBackground(),

          // PIN input widget
          Pinput(
            length: widget.length,
            controller: widget.controller,
            defaultPinTheme: defaultPinTheme,
            hapticFeedbackType: widget.hapticFeedbackType,
            enabled: widget.enabled,
            autofocus: widget.autofocus,
            focusNode: _focusNode,
            onCompleted: _handleOnCompleted,
            onChanged: _handleOnChanged,
            validator: widget.validator,
            separatorBuilder: widget.spacing != null
                ? (index) => SizedBox(width: widget.spacing!)
                : null,

            // Cursor styling matching GlobalTextFormField
            cursor: _buildCursor(),

            // Focused state
            focusedPinTheme: _buildFocusedTheme(defaultPinTheme),

            // Submitted state
            submittedPinTheme: _buildSubmittedTheme(defaultPinTheme),

            // Error state matching GlobalTextFormField
            errorPinTheme: _buildErrorTheme(defaultPinTheme),

            // Error text styling
            errorText: _effectiveErrorText,
            errorTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: MyColors.error,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurBackground() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        widget.length,
        (index) => ClipRRect(
          borderRadius: _effectiveBorderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              width: widget.width - 5,
              height: widget.height,
              decoration: BoxDecoration(
                color: _effectiveFillColor,
                borderRadius: _effectiveBorderRadius,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCursor() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 9),
          width: 24,
          height: 2,
          color: _effectiveCursorColor,
        ),
      ],
    );
  }

  PinTheme _buildFocusedTheme(PinTheme defaultTheme) {
    return defaultTheme.copyWith(
      decoration: defaultTheme.decoration!.copyWith(
        borderRadius: _effectiveBorderRadius,
        border: Border.all(
          color: widget.focusedBorderColor,
          width: 2,
        ),
      ),
    );
  }

  PinTheme _buildSubmittedTheme(PinTheme defaultTheme) {
    return defaultTheme.copyWith(
      decoration: defaultTheme.decoration!.copyWith(
        borderRadius: _effectiveBorderRadius,
        border: Border.all(
          color: widget.focusedBorderColor.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
    );
  }

  PinTheme _buildErrorTheme(PinTheme defaultTheme) {
    return defaultTheme.copyBorderWith(
      border: Border.all(
        color: MyColors.error,
        width: 2,
      ),
    );
  }

  // Public methods for external control
  void requestFocus() {
    _focusNode.requestFocus();
  }

  void unfocus() {
    _focusNode.unfocus();
  }

  bool get hasFocus => _focusNode.hasFocus;

  String get value => widget.controller.text;

  void clear() {
    widget.controller.clear();
  }

  void setValue(String value) {
    widget.controller.text = value;
  }
}
