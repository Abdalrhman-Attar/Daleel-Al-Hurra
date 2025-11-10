import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/location_picker_widget.dart';
import '../../../../main.dart';
import '../../../../module/global_elevated_button.dart';
import '../../../../module/global_text_field.dart';
import '../../../../services/translation_service.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/formatters/formatter.dart';
import '../../controllers/register_controller.dart';
import '../../views/otp_page.dart';

class RegisterForm extends StatelessWidget {
  RegisterForm({super.key});

  final RegisterController _registerController = Get.put(RegisterController());

  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return Get.find<TranslationService>().tr('first name required');
    }
    if (value.length < 2) {
      return Get.find<TranslationService>().tr('first name too short');
    }
    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return Get.find<TranslationService>().tr('last name required');
    }
    if (value.length < 2) {
      return Get.find<TranslationService>().tr('last name too short');
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return Get.find<TranslationService>().tr('phone required');
    }

    // Remove any non-digit characters except the leading +
    final cleanValue = value.replaceAll(RegExp(r'[^\d+]'), '');

    // Check if it's already in international format
    if (cleanValue.startsWith('+')) {
      final phoneRegex = RegExp(r'^\+\d{10,15}$');
      if (!phoneRegex.hasMatch(cleanValue)) {
        return Get.find<TranslationService>().tr('invalid phone');
      }
      return null;
    }

    // Check if it's a local Jordanian number (9 digits, optionally starting with 0)
    if (cleanValue.length == 9 || (cleanValue.length == 10 && cleanValue.startsWith('0'))) {
      // Remove leading 0 if present
      final numberWithoutZero = cleanValue.startsWith('0') ? cleanValue.substring(1) : cleanValue;

      // Check if it's a valid Jordanian mobile number (starts with 7)
      if (numberWithoutZero.startsWith('7') && numberWithoutZero.length == 9) {
        return null;
      }
    }

    return Get.find<TranslationService>().tr('invalid phone');
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return Get.find<TranslationService>().tr('password required');
    }
    if (value.length < 6) {
      return Get.find<TranslationService>().tr('password too short');
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return Get.find<TranslationService>().tr('confirm password required');
    }
    if (value != _registerController.passwordController.text) {
      return Get.find<TranslationService>().tr('passwords do not match');
    }
    return null;
  }

  String? _validateStoreName(String? value) {
    if (value == null || value.isEmpty) {
      return Get.find<TranslationService>().tr('store name required');
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return Get.find<TranslationService>().tr('address required');
    }
    return null;
  }

  String? _validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return Get.find<TranslationService>().tr('location required');
    }

    final lat = double.tryParse(_registerController.latitude);
    final lng = double.tryParse(_registerController.longitude);

    if (lat == null || lng == null) {
      return Get.find<TranslationService>().tr('invalid location coordinates');
    }

    // Validate latitude range (-90 to 90)
    if (lat < -90 || lat > 90) {
      return Get.find<TranslationService>().tr('invalid latitude');
    }

    // Validate longitude range (-180 to 180)
    if (lng < -180 || lng > 180) {
      return Get.find<TranslationService>().tr('invalid longitude');
    }

    return null;
  }

  Future<void> _handleRegister(BuildContext context) async {
    // format phone number to be like this +962799741516
    // 0798344241 => +962798344241
    // 798344241 => +962798344241
    // +962798344241 => +962798344241

    final formattedPhoneNumber = Formatter.formatPhoneNumber(_registerController.phoneNumberController.text);
    _registerController.phoneNumberController.text = formattedPhoneNumber;

    // Validate the main form
    final isFormValid = _registerController.formKey.currentState?.validate() ?? false;

    // Validate location separately
    final isLocationValid = _validateLocation('${_registerController.latitude},${_registerController.longitude}') == null;
    if (isFormValid && isLocationValid) {
      _registerController.isLoading = true;
      await Future.delayed(const Duration(seconds: 1), () async {
        if (await _registerController.register()) {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const OtpPage()),
          );
        }
      });
      _registerController.isLoading = false;
    } else if (!isLocationValid) {
      // Show error for location validation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Get.find<TranslationService>().tr('location required')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Form(
        key: _registerController.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // First Name and Last Name row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GlobalTextFormField(
                    controller: _registerController.firstNameController,
                    hint: Get.find<TranslationService>().tr('first name'),
                    keyboardType: TextInputType.name,
                    validator: _validateFirstName,
                    validationMode: ValidationMode.onInteraction,
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    enableBlur: true,
                    fillColor: Colors.white.withValues(alpha: 0.1),
                    filled: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GlobalTextFormField(
                    controller: _registerController.lastNameController,
                    hint: Get.find<TranslationService>().tr('last name'),
                    keyboardType: TextInputType.name,
                    validator: _validateLastName,
                    validationMode: ValidationMode.onInteraction,
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    enableBlur: true,
                    fillColor: Colors.white.withValues(alpha: 0.1),
                    filled: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Phone number field
            GlobalTextFormField(
              controller: _registerController.phoneNumberController,
              hint: Get.find<TranslationService>().tr('enter phone'),
              validator: _validatePhone,
              validationMode: ValidationMode.onInteraction,
              enableBlur: true,
              fillColor: Colors.white.withValues(alpha: 0.1),
              filled: true,
              textColor: Colors.white.withValues(alpha: 0.7),
            ),

            const SizedBox(height: 16),

            // Password field
            GlobalTextFormField(
              controller: _registerController.passwordController,
              hint: Get.find<TranslationService>().tr('enter password'),
              obscureText: true,
              validator: _validatePassword,
              validationMode: ValidationMode.onInteraction,
              prefixIcon: Icon(
                Icons.lock_outline,
                color: Colors.white.withValues(alpha: 0.7),
              ),
              enableBlur: true,
              fillColor: Colors.white.withValues(alpha: 0.1),
              filled: true,
            ),
            const SizedBox(height: 16),

            // Confirm Password field
            GlobalTextFormField(
              controller: _registerController.confirmPasswordController,
              hint: Get.find<TranslationService>().tr('confirm password'),
              obscureText: true,
              validator: _validateConfirmPassword,
              validationMode: ValidationMode.onInteraction,
              prefixIcon: Icon(
                Icons.lock_outline,
                color: Colors.white.withValues(alpha: 0.7),
              ),
              fillColor: Colors.white.withValues(alpha: 0.1),
              filled: true,
              enableBlur: true,
            ),

            const SizedBox(height: 16),

            GlobalTextFormField(
              controller: _registerController.storeNameController,
              hint: Get.find<TranslationService>().tr('store name'),
              keyboardType: TextInputType.name,
              validator: _validateStoreName,
              validationMode: ValidationMode.onInteraction,
              prefixIcon: Icon(
                Icons.store_outlined,
                color: Colors.white.withValues(alpha: 0.7),
              ),
              enableBlur: true,
              fillColor: Colors.white.withValues(alpha: 0.1),
              filled: true,
            ),

            const SizedBox(height: 16),

            GlobalTextFormField(
              controller: _registerController.addressController,
              hint: Get.find<TranslationService>().tr('address'),
              keyboardType: TextInputType.streetAddress,
              validator: _validateAddress,
              validationMode: ValidationMode.onInteraction,
              prefixIcon: Icon(
                Icons.location_on_outlined,
                color: Colors.white.withValues(alpha: 0.7),
              ),
              enableBlur: true,
              fillColor: Colors.white.withValues(alpha: 0.1),
              filled: true,
            ),

            const SizedBox(height: 16),

            // Location picker section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Get.find<TranslationService>().tr('select location'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    final initialLat = _registerController.latitude.isNotEmpty ? double.tryParse(_registerController.latitude) : null;
                    final initialLng = _registerController.longitude.isNotEmpty ? double.tryParse(_registerController.longitude) : null;

                    showModalBottomSheet(
                      context: navigatorKey.currentContext!,
                      isScrollControlled: true,
                      isDismissible: false, // Prevent accidental dismissal
                      enableDrag: false, // Disable drag to allow map gestures
                      backgroundColor: Colors.transparent,
                      builder: (BuildContext context) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.9,
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: Column(
                            children: [
                              // Header
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      tr('select location'),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      icon: const Icon(Icons.close),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                ),
                              ),
                              // Map Content
                              Expanded(
                                child: LocationPickerWidget(
                                  onLocationSelected: (latitude, longitude) {
                                    _registerController.latitude = latitude.toString();
                                    _registerController.longitude = longitude.toString();
                                  },
                                  initialLatitude: initialLat,
                                  initialLongitude: initialLng,
                                  hintText: Get.find<TranslationService>().tr('select location'),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.map,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Obx(
                            () => Text(
                              _registerController.latitude.isNotEmpty && _registerController.longitude.isNotEmpty ? 'Lat: ${_registerController.latitude}, Lng: ${_registerController.longitude}' : Get.find<TranslationService>().tr('tap to select location'),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white.withValues(alpha: 0.5),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Register button
            GlobalElevatedButton(
              text: _registerController.isLoading ? Get.find<TranslationService>().tr('creating account') : Get.find<TranslationService>().tr('create account'),
              isLoading: _registerController.isLoading,
              onPressed: () async => await _handleRegister(context),
              backgroundColor: MyColors.primary,
              borderRadius: BorderRadius.circular(50.0),
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              isMinimumWidth: false,
            ),
          ],
        ),
      ),
    );
  }
}
