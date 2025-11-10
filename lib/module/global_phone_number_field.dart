import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/locale/locale.dart';
import '../model/general/country_code/country_code.dart';
import '../services/country_codes_service.dart';
import '../utils/constants/colors.dart';
import 'global_drop_down.dart';
import 'global_text_field.dart';

class GlobalPhoneNumberField extends StatefulWidget {
  final String? identifier;
  final String? label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final int? maxLength;
  final void Function(String)? onChanged;
  final String? infoLabel;
  final VoidCallback? onInfoLabelTap;
  final void Function(PointerDownEvent)? onTapOutside;
  final void Function(String)? onFieldSubmitted;
  final VoidCallback? onTap;
  final bool alignmentIsEditable;
  final TextInputAction? textInputAction;
  final String? errorText;
  final BorderRadius? borderRadius;
  final double? height;
  final bool autofocus;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final bool filled;
  final bool enableBlur;
  final bool readOnly;
  final Color? textColor;
  final Color? iconColor;
  final Color? borderColor;
  // Enhanced validation properties
  final ValidationMode validationMode;
  final bool deferToParentForm;
  final Duration validationDelay;
  final bool showErrorImmediately;

  // Country code properties
  final CountryCode? initialCountryCode;
  final void Function(CountryCode)? onCountryCodeChanged;
  final List<CountryCode>? allowedCountries;

  const GlobalPhoneNumberField({
    super.key,
    this.identifier,
    this.label,
    required this.hint,
    required this.controller,
    this.validator,
    this.enabled = true,
    this.maxLength,
    this.onChanged,
    this.infoLabel,
    this.onInfoLabelTap,
    this.onTapOutside,
    this.onFieldSubmitted,
    this.onTap,
    this.alignmentIsEditable = true,
    this.textInputAction,
    this.errorText,
    this.borderRadius,
    this.height,
    this.autofocus = false,
    this.focusNode,
    this.contentPadding,
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
    this.initialCountryCode,
    this.onCountryCodeChanged,
    this.allowedCountries,
    this.borderColor,
  });

  @override
  State<GlobalPhoneNumberField> createState() => _GlobalPhoneNumberFieldState();
}

class _GlobalPhoneNumberFieldState extends State<GlobalPhoneNumberField> {
  late CountryCode _selectedCountryCode;
  late TextEditingController _phoneController;
  late FocusNode _phoneFocusNode;
  LocaleController? _localeController;

  // Validation state
  String? _localErrorText;
  bool _hasInteracted = false;
  Timer? _validationTimer;

  @override
  void initState() {
    super.initState();
    _initializeLocaleController();
    _initializeCountryCode();
    _initializeControllers();
    _phoneController.addListener(_updateTextDirection);
    _updateTextDirection();
  }

  @override
  void dispose() {
    _phoneController.removeListener(_updateTextDirection);
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

  void _initializeCountryCode() {
    _selectedCountryCode =
        widget.initialCountryCode ?? CountryCodesService.getDefaultCountry();
  }

  void _initializeControllers() {
    _phoneController = widget.controller;
    _phoneFocusNode = widget.focusNode ?? FocusNode();
  }

  void _updateTextDirection() {
    if (!mounted || !widget.alignmentIsEditable) return;

    final text = _phoneController.text;

    // Check RTL from locale controller first
    if (_localeController?.getIsRtl() == true) {
      // RTL is handled by the GlobalTextFormField
    } else if (text.isNotEmpty) {
      // Check if first character is Arabic/RTL
      // RTL is handled by the GlobalTextFormField
    }

    // Note: We don't need to set state here as the text direction is handled by the GlobalTextFormField
  }

  // bool _isRtlCharacter(String char) {
  //   // Extended RTL character detection
  //   return RegExp(
  //           r'^[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]')
  //       .hasMatch(char);
  // }

  // Enhanced validation methods
  void _performValidation([String? value]) {
    if (widget.validator == null ||
        widget.validationMode == ValidationMode.none) {
      return;
    }

    final currentValue = value ?? _phoneController.text;
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

  void _onCountryCodeChanged(CountryCode? countryCode) {
    if (countryCode != null) {
      setState(() {
        _selectedCountryCode = countryCode;
      });
      widget.onCountryCodeChanged?.call(countryCode);
    }
  }

  String _getFullPhoneNumber() {
    final phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isEmpty) return '';

    // Remove leading zeros
    var cleanNumber = phoneNumber;
    if (cleanNumber.startsWith('0')) {
      cleanNumber = cleanNumber.substring(1);
    }

    // Return full international format
    return _selectedCountryCode.dialCode! + cleanNumber;
  }

  void _handlePhoneNumberChanged(String value) {
    if (!_hasInteracted) {
      setState(() => _hasInteracted = true);
    }

    // Call the original onChanged with the full phone number
    final fullPhoneNumber = _getFullPhoneNumber();
    widget.onChanged?.call(fullPhoneNumber);
    _handleValidationTrigger(value);
  }

  void _handleTapOutside(PointerDownEvent event) {
    widget.onTapOutside?.call(event);
    FocusScope.of(context).unfocus();

    // Trigger validation on focus loss if configured
    _handleValidationTrigger(_phoneController.text, isOnFocusLoss: true);
  }

  List<DropdownItem<CountryCode>> _getCountryDropdownItems() {
    final countries =
        widget.allowedCountries ?? CountryCodesService.countryCodes;
    return countries
        .map((country) => DropdownItem<CountryCode>(
              value: country,
              label: '${country.flag} ${country.name} (${country.dialCode})',
              icon: Text(country.flag!, style: const TextStyle(fontSize: 16)),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildHeader(context),
        _buildPhoneNumberField(context),
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

  Widget _buildPhoneNumberField(BuildContext context) {
    return Row(
      children: [
        // Country Code Dropdown

        // Phone Number Text Field
        Expanded(
          flex: 4,
          child: GlobalTextFormField(
            controller: _phoneController,
            hint: widget.hint,
            keyboardType: TextInputType.phone,
            enabled: widget.enabled,
            maxLength: widget.maxLength,
            onChanged: _handlePhoneNumberChanged,
            onTapOutside: _handleTapOutside,
            onFieldSubmitted: widget.onFieldSubmitted,
            onTap: widget.onTap,
            alignmentIsEditable: widget.alignmentIsEditable,
            textInputAction: widget.textInputAction,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            errorText: widget.errorText ?? _localErrorText,
            borderRadius: widget.borderRadius,
            height: widget.height,
            autofocus: widget.autofocus,
            focusNode: _phoneFocusNode,
            contentPadding: widget.contentPadding,
            fillColor: widget.fillColor,
            filled: widget.filled,
            validationMode: widget.validationMode,
            deferToParentForm: widget.deferToParentForm,
            validationDelay: widget.validationDelay,
            showErrorImmediately: widget.showErrorImmediately,
            enableBlur: widget.enableBlur,
            readOnly: widget.readOnly,
            textColor: widget.textColor,
            iconColor: widget.iconColor,
            prefixIcon: Icon(
              Icons.phone_outlined,
              color: widget.iconColor ??
                  (widget.enabled
                      ? MyColors.white.withValues(alpha: 0.7)
                      : MyColors.grey),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: GlobalDropdown<CountryCode>(
            items: _getCountryDropdownItems(),
            selectedValue: _selectedCountryCode,
            onChanged: _onCountryCodeChanged,
            hint: _selectedCountryCode.flag!,
            enabled: widget.enabled,
            maxHeight: 300,
            enableSearch: true,
            searchIdentifier: 'Search countries...',
            fillColor: widget.fillColor,
            filled: widget.filled,
            borderRadius: widget.borderRadius,
            backgroundColor: widget.fillColor,
            borderColor: widget.borderColor,
            height: widget.height,
            contentPadding: widget.contentPadding,
            enableBlur: widget.enableBlur,
            textColor: widget.textColor,
            iconColor: widget.iconColor,
          ),
        ),
      ],
    );
  }

  // Getter for the full phone number
  String get fullPhoneNumber => _getFullPhoneNumber();

  // Getter for the selected country code
  CountryCode get selectedCountryCode => _selectedCountryCode;
}
