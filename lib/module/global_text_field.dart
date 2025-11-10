import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/locale/locale.dart';
import '../utils/constants/colors.dart';
import 'dynamic_icon_viewer.dart';

enum ValidationMode {
  none,
  onSubmit,
  realTime,
  onFocusLoss,
  onInteraction,
}

class GlobalTextFormField extends StatefulWidget {
  final String? identifier;
  final String? label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool enabled;
  final int? maxLength;
  final IconData? suffixIcon;
  final String icon;
  final Widget? suffixIconWidget;
  final void Function(String)? onChanged;
  final String? infoLabel;
  final VoidCallback? onInfoLabelTap;
  final void Function(PointerDownEvent)? onTapOutside;
  final void Function(String)? onFieldSubmitted;
  final VoidCallback? onTap;
  final bool obscureText;
  final bool alignmentIsEditable;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final bool suffixIconTapable;
  final VoidCallback? onSuffixIconTap;
  final String? errorText;
  final BorderRadius? borderRadius;
  final int? maxLines;
  final double? height;
  final bool autofocus;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final bool showCounter;
  final Widget? prefixIcon;
  final Color? fillColor;
  final bool filled;
  final bool enableBlur;
  final bool readOnly;
  final Color? textColor;
  final Color? iconColor;

  // Enhanced validation properties
  final ValidationMode validationMode;
  final bool deferToParentForm;
  final Duration validationDelay;
  final bool showErrorImmediately;

  const GlobalTextFormField({
    super.key,
    this.identifier,
    this.label,
    required this.hint,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.icon = '',
    this.maxLength,
    this.suffixIcon,
    this.suffixIconWidget,
    this.onChanged,
    this.infoLabel,
    this.onInfoLabelTap,
    this.onTapOutside,
    this.onFieldSubmitted,
    this.onTap,
    this.obscureText = false,
    this.alignmentIsEditable = true,
    this.inputFormatters,
    this.textInputAction,
    this.suffixIconTapable = false,
    this.onSuffixIconTap,
    this.errorText,
    this.borderRadius,
    this.maxLines = 1,
    this.height,
    this.autofocus = false,
    this.focusNode,
    this.contentPadding,
    this.showCounter = false,
    this.prefixIcon,
    this.fillColor,
    this.filled = false,
    this.validationMode = ValidationMode.onSubmit,
    this.deferToParentForm = true,
    this.validationDelay = const Duration(milliseconds: 500),
    this.showErrorImmediately = false,
    this.enableBlur = false,
    this.readOnly = false,
    this.textColor,
    this.iconColor,
  });

  @override
  State<GlobalTextFormField> createState() => _GlobalTextFormFieldState();
}

class _GlobalTextFormFieldState extends State<GlobalTextFormField> {
  late bool _obscureText;
  TextAlign _textAlign = TextAlign.left;
  LocaleController? _localeController;

  // Validation state
  String? _localErrorText;
  bool _hasInteracted = false;
  Timer? _validationTimer;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _initializeLocaleController();
    widget.controller.addListener(_updateTextDirection);
    _updateTextDirection();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateTextDirection);
    _validationTimer?.cancel();
    super.dispose();
  }

  void _initializeLocaleController() {
    try {
      _localeController = Get.find<LocaleController>();
    } catch (e) {
      // Handle case where LocaleController is not registered
    }
  }

  void _updateTextDirection() {
    if (!mounted || !widget.alignmentIsEditable) return;

    final text = widget.controller.text;
    var newAlign = TextAlign.left;

    // Check RTL from locale controller first
    if (_localeController?.getIsRtl() == true) {
      newAlign = TextAlign.right;
    } else if (text.isNotEmpty) {
      // Check if first character is Arabic/RTL
      final firstChar = text.characters.first;
      final isRtl = _isRtlCharacter(firstChar);
      newAlign = isRtl ? TextAlign.right : TextAlign.left;
    }

    if (_textAlign != newAlign) {
      setState(() {
        _textAlign = newAlign;
      });
    }
  }

  bool _isRtlCharacter(String char) {
    // Extended RTL character detection
    return RegExp(
            r'^[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]')
        .hasMatch(char);
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // Enhanced validation methods
  void _performValidation([String? value]) {
    if (widget.validator == null ||
        widget.validationMode == ValidationMode.none) {
      return;
    }

    final currentValue = value ?? widget.controller.text;
    final error = widget.validator!(currentValue);

    if (mounted) {
      setState(() {
        _localErrorText = error;
      });
    }
  }

  void _scheduleValidation(String value) {
    if (widget.validationMode != ValidationMode.realTime) return;

    _validationTimer?.cancel();

    _validationTimer = Timer(widget.validationDelay, () {
      _performValidation(value);
    });
  }

  void _handleValidationTrigger(String value, {bool isOnFocusLoss = false}) {
    switch (widget.validationMode) {
      case ValidationMode.none:
        break;
      case ValidationMode.onSubmit:
        // Let the form handle validation
        break;
      case ValidationMode.realTime:
        _scheduleValidation(value);
        break;
      case ValidationMode.onFocusLoss:
        if (isOnFocusLoss) _performValidation(value);
        break;
      case ValidationMode.onInteraction:
        if (_hasInteracted) {
          if (isOnFocusLoss) {
            _performValidation(value);
          } else {
            _scheduleValidation(value);
          }
        }
        break;
    }
  }

  String? _getEffectiveValidator(String? value) {
    // Priority: external errorText > local validation > parent form validation
    if (widget.errorText != null) {
      return widget.errorText;
    }

    // If we're deferring to parent form and haven't interacted, return null
    if (widget.deferToParentForm &&
        !_hasInteracted &&
        !widget.showErrorImmediately) {
      return widget.validator?.call(value);
    }

    // Use local validation if available
    if (_localErrorText != null) {
      return _localErrorText;
    }

    // Fall back to parent form validation
    return widget.validator?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildHeader(context),
        _buildTextField(context),
      ],
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
          color: widget.iconColor ??
              (widget.enabled
                  ? MyColors.textPrimary.withValues(alpha: 0.7)
                  : MyColors.grey),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          if (widget.enableBlur)
            ClipRRect(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  height: (widget.height) ?? 48,
                  decoration: BoxDecoration(
                    color: (widget.fillColor ?? Colors.white),
                    borderRadius:
                        widget.borderRadius ?? BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          TextFormField(
            autofocus: widget.autofocus,
            focusNode: widget.focusNode,
            controller: widget.controller,
            enabled: widget.enabled,
            obscureText: _obscureText,
            maxLength: widget.maxLength,
            maxLines: widget.maxLines,
            keyboardType: widget.keyboardType,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: widget.enabled
                      ? widget.textColor ?? MyColors.white
                      : MyColors.grey,
                ),
            textAlignVertical: TextAlignVertical.center,
            readOnly: widget.readOnly,
            textInputAction: widget.textInputAction,
            inputFormatters: widget.inputFormatters,
            textAlign:
                widget.alignmentIsEditable ? _textAlign : TextAlign.start,
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hint,
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: MyColors.grey,
                  ),
              hintTextDirection: _textAlign == TextAlign.right
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              errorText: widget.errorText ?? _localErrorText,
              counterText: widget.showCounter ? null : '',
              prefixIcon: widget.prefixIcon,
              suffixIcon: _buildSuffixIcon(),
              errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: MyColors.error,
                  ),
              border: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.transparent, // Important: transparent fill
              contentPadding: widget.contentPadding,
            ),
            onChanged: _handleOnChanged,
            onTap: widget.onTap,
            onTapOutside: _handleTapOutside,
            onFieldSubmitted: widget.onFieldSubmitted,
            validator: widget.deferToParentForm ? _getEffectiveValidator : null,
            autovalidateMode: _getAutovalidateMode(),
          ),
        ],
      ),
    );
  }

  AutovalidateMode _getAutovalidateMode() {
    if (widget.validationMode == ValidationMode.none) {
      return AutovalidateMode.disabled;
    }

    if (widget.deferToParentForm) {
      return AutovalidateMode.onUserInteraction;
    }

    switch (widget.validationMode) {
      case ValidationMode.onSubmit:
        return AutovalidateMode.disabled;
      case ValidationMode.realTime:
      case ValidationMode.onInteraction:
        return AutovalidateMode.onUserInteraction;
      case ValidationMode.onFocusLoss:
        return AutovalidateMode.disabled;
      case ValidationMode.none:
        return AutovalidateMode.disabled;
    }
  }

  void _handleOnChanged(String value) {
    if (!_hasInteracted) {
      setState(() => _hasInteracted = true);
    }

    widget.onChanged?.call(value);
    _handleValidationTrigger(value);
  }

  void _handleTapOutside(PointerDownEvent event) {
    widget.onTapOutside?.call(event);
    FocusScope.of(context).unfocus();

    // Trigger validation on focus loss if configured
    _handleValidationTrigger(widget.controller.text, isOnFocusLoss: true);
  }

  Widget? _buildSuffixIcon() {
    // Priority: obscureText toggle > custom suffixIcon > icon string
    if (widget.obscureText) {
      return _buildObscureToggle();
    }

    if (widget.suffixIcon != null) {
      return _buildCustomSuffixIcon();
    }

    if (widget.icon.isNotEmpty) {
      return _buildDynamicIcon();
    }

    if (widget.suffixIconWidget != null) {
      return widget.suffixIconWidget;
    }

    return null;
  }

  Widget _buildObscureToggle() {
    return IconButton(
      icon: Icon(
        _obscureText ? Icons.visibility_off : Icons.visibility,
        semanticLabel: _obscureText ? 'Show password' : 'Hide password',
        color: widget.iconColor ??
            (widget.enabled
                ? MyColors.white.withValues(alpha: 0.7)
                : MyColors.grey),
      ),
      onPressed: _toggleObscureText,
      tooltip: _obscureText ? 'Show password' : 'Hide password',
    );
  }

  Widget _buildCustomSuffixIcon() {
    return IconButton(
      icon: Icon(
        widget.suffixIcon,
        color: widget.iconColor ??
            (widget.enabled
                ? MyColors.textPrimary.withValues(alpha: 0.7)
                : MyColors.grey),
      ),
      onPressed: widget.suffixIconTapable ? widget.onSuffixIconTap : null,
    );
  }

  Widget _buildDynamicIcon() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DynamicIconViewer(
        filePath: widget.icon,
        color: widget.iconColor ??
            (widget.enabled
                ? MyColors.textPrimary.withValues(alpha: 0.7)
                : MyColors.grey),
      ),
    );
  }
}
