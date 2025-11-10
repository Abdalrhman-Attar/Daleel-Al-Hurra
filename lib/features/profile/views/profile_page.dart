import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/layouts/bottom_nav_layout/bottom_nav_page.dart';
import '../../../common/widgets/location_picker_widget.dart';
import '../../../main.dart';
import '../../../module/global_dialog.dart';
import '../../../module/global_icon_button.dart';
import '../../../module/global_image.dart';
import '../../../module/global_text_button.dart';
import '../../../module/global_text_field.dart';
import '../../../services/translation_service.dart';
import '../../../splash_screen.dart';
import '../../../stores/secure_store.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/enums.dart';
import '../../settings/views/settings_page.dart';
import '../controllers/delete_account_controller.dart';
import '../controllers/update_profile_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final DeleteAccountController _deleteAccountController = Get.put(DeleteAccountController());
  final UpdateProfileController _updateProfileController = Get.put(UpdateProfileController());

  @override
  void initState() {
    super.initState();
    _updateProfileController.onInit();
  }

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

  // String? _validateEmail(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return Get.find<TranslationService>().tr('email required');
  //   }
  //   final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  //   if (!emailRegex.hasMatch(value)) {
  //     return Get.find<TranslationService>().tr('invalid email');
  //   }
  //   return null;
  // }

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

  // String? _validateLocation(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return Get.find<TranslationService>().tr('location required');
  //   }

  //   final lat = double.tryParse(_updateProfileController.latitudeController.text);
  //   final lng = double.tryParse(_updateProfileController.longitudeController.text);

  //   if (lat == null || lng == null) {
  //     return Get.find<TranslationService>().tr('invalid location coordinates');
  //   }

  //   // Validate latitude range (-90 to 90)
  //   if (lat < -90 || lat > 90) {
  //     return Get.find<TranslationService>().tr('invalid latitude');
  //   }

  //   // Validate longitude range (-180 to 180)
  //   if (lng < -180 || lng > 180) {
  //     return Get.find<TranslationService>().tr('invalid longitude');
  //   }

  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Get.find<TranslationService>().tr('profile'),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: MyColors.background,
        surfaceTintColor: MyColors.background,
        // foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Obx(
              () => GlobalIconButton(
                iconData: _updateProfileController.isEditing ? Icons.save : Icons.edit,
                isLoading: _updateProfileController.isLoading,
                borderRadius: BorderRadius.circular(50.0),
                onPressed: () async {
                  await _updateProfileController.toggleEdit();
                },
                iconColor: MyColors.iconPrimary,
                buttonSize: 35.0,
                iconSize: 25.0,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Header
            Card(
              color: MyColors.transparent,
              surfaceTintColor: MyColors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              margin: const EdgeInsets.all(0),
              elevation: 0.0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Profile Image
                    GestureDetector(
                      onTap: _updateProfileController.isEditing ? _updateProfileController.pickLogoImage : null,
                      child: Obx(() => Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 2,
                                  ),
                                ),
                                child: _updateProfileController.logoFile != null
                                    ? GlobalImage(
                                        file: _updateProfileController.logoFile!,
                                        type: ImageType.file,
                                        width: 90,
                                        height: 90,
                                        borderRadius: 50,
                                      )
                                    : _updateProfileController.profileImage != null && _updateProfileController.profileImage!.isNotEmpty
                                        ? GlobalImage(
                                            type: ImageType.network,
                                            width: 90,
                                            height: 90,
                                            borderRadius: 50,
                                            url: _updateProfileController.profileImage!,
                                          )
                                        : Container(
                                            width: 90,
                                            height: 90,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.withValues(alpha: 0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.person,
                                              size: 40,
                                              color: Colors.grey.withValues(alpha: 0.6),
                                            ),
                                          ),
                              ),
                              // Image Type Indicator (OLD/NEW)
                              if (_updateProfileController.isEditing && (_updateProfileController.logoFile != null || (_updateProfileController.profileImage != null && _updateProfileController.profileImage!.isNotEmpty)))
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _updateProfileController.logoFile != null ? Colors.green.withValues(alpha: 0.9) : Colors.orange.withValues(alpha: 0.9),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      _updateProfileController.logoFile != null ? 'NEW' : 'OLD',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                              if (_updateProfileController.isEditing)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Camera Button
                                      GestureDetector(
                                        onTap: _updateProfileController.pickLogoImage,
                                        child: CircleAvatar(
                                          radius: 18,
                                          backgroundColor: MyColors.primary,
                                          child: const Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // Remove Button
                                      if (_updateProfileController.logoFile != null || (_updateProfileController.profileImage != null && _updateProfileController.profileImage!.isNotEmpty))
                                        GestureDetector(
                                          onTap: _updateProfileController.removeLogoImage,
                                          child: const CircleAvatar(
                                            radius: 18,
                                            backgroundColor: Colors.red,
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Profile Information
            Obx(
              () => Card(
                color: MyColors.white,
                surfaceTintColor: MyColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                margin: const EdgeInsets.all(0),
                elevation: 0.5,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Get.find<TranslationService>().tr('personal information'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Last Name
                      // First Name and Last Name row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: GlobalTextFormField(
                              controller: _updateProfileController.firstNameController,
                              hint: Get.find<TranslationService>().tr('first name'),
                              keyboardType: TextInputType.name,
                              enabled: _updateProfileController.isEditing,
                              validator: _validateFirstName,
                              validationMode: ValidationMode.onInteraction,
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: _updateProfileController.isEditing ? MyColors.textPrimary.withValues(alpha: 0.7) : MyColors.grey,
                              ),
                              enableBlur: true,
                              fillColor: Colors.white.withValues(alpha: 0.1),
                              filled: true,
                              textColor: MyColors.textPrimary,
                              iconColor: MyColors.textPrimary.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GlobalTextFormField(
                              controller: _updateProfileController.lastNameController,
                              hint: Get.find<TranslationService>().tr('last name'),
                              enabled: _updateProfileController.isEditing,
                              keyboardType: TextInputType.name,
                              validator: _validateLastName,
                              validationMode: ValidationMode.onInteraction,
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: _updateProfileController.isEditing ? MyColors.textPrimary.withValues(alpha: 0.7) : MyColors.grey,
                              ),
                              enableBlur: true,
                              fillColor: Colors.white.withValues(alpha: 0.1),
                              filled: true,
                              textColor: MyColors.textPrimary,
                              iconColor: MyColors.textPrimary.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Phone number field
                      GlobalTextFormField(
                        controller: _updateProfileController.phoneNumberController,
                        hint: Get.find<TranslationService>().tr('enter phone'),
                        enabled: _updateProfileController.isEditing,
                        validator: _validatePhone,
                        validationMode: ValidationMode.onInteraction,
                        enableBlur: true,
                        fillColor: Colors.white.withValues(alpha: 0.1),
                        filled: true,
                        textColor: MyColors.textPrimary,
                        iconColor: MyColors.textPrimary.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Obx(
              () => Card(
                color: MyColors.white,
                surfaceTintColor: MyColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                margin: const EdgeInsets.all(0),
                elevation: 0.5,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Get.find<TranslationService>().tr('store information'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Store Name
                      GlobalTextFormField(
                        controller: _updateProfileController.storeNameController,
                        hint: Get.find<TranslationService>().tr('store name'),
                        enabled: _updateProfileController.isEditing,
                        keyboardType: TextInputType.name,
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: _updateProfileController.isEditing ? MyColors.textPrimary.withValues(alpha: 0.7) : MyColors.grey,
                        ),
                        enableBlur: true,
                        fillColor: Colors.white.withValues(alpha: 0.1),
                        filled: true,
                        textColor: MyColors.textPrimary,
                        iconColor: MyColors.textPrimary.withValues(alpha: 0.7),
                        validator: _validateStoreName,
                        validationMode: ValidationMode.onInteraction,
                      ),
                      const SizedBox(height: 16),
                      // Address
                      GlobalTextFormField(
                        controller: _updateProfileController.addressController,
                        hint: Get.find<TranslationService>().tr('address'),
                        enabled: _updateProfileController.isEditing,
                        keyboardType: TextInputType.name,
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          color: _updateProfileController.isEditing ? MyColors.textPrimary.withValues(alpha: 0.7) : MyColors.grey,
                        ),
                        enableBlur: true,
                        fillColor: Colors.white.withValues(alpha: 0.1),
                        filled: true,
                        textColor: MyColors.textPrimary,
                        iconColor: MyColors.textPrimary.withValues(alpha: 0.7),
                        validator: _validateAddress,
                        validationMode: ValidationMode.onInteraction,
                      ),

                      const SizedBox(height: 16),

                      // Location Picker
                      if (_updateProfileController.isEditing) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Get.find<TranslationService>().tr('select location'),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () {
                                final initialLat = _updateProfileController.latitudeController.text.isNotEmpty ? double.tryParse(_updateProfileController.latitudeController.text) : null;
                                final initialLng = _updateProfileController.longitudeController.text.isNotEmpty ? double.tryParse(_updateProfileController.longitudeController.text) : null;

                                showModalBottomSheet(
                                  context: navigatorKey.currentContext!,
                                  isScrollControlled: true,
                                  isDismissible: false,
                                  enableDrag: false,
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
                                                  Get.find<TranslationService>().tr('select location'),
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
                                                _updateProfileController.latitudeController.text = latitude.toString();
                                                _updateProfileController.longitudeController.text = longitude.toString();
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
                                    color: Colors.grey.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.map,
                                      color: MyColors.textPrimary.withValues(alpha: 0.7),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Obx(
                                        () => Text(
                                          _updateProfileController.latitudeController.text.isNotEmpty && _updateProfileController.longitudeController.text.isNotEmpty
                                              ? 'Lat: ${_updateProfileController.latitudeController.text}, Lng: ${_updateProfileController.longitudeController.text}'
                                              : Get.find<TranslationService>().tr('tap to select location'),
                                          style: TextStyle(
                                            color: MyColors.textPrimary.withValues(alpha: 0.7),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey.withValues(alpha: 0.5),
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        // Display current location in read-only mode
                        if (_updateProfileController.latitudeController.text.isNotEmpty && _updateProfileController.longitudeController.text.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: MyColors.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Get.find<TranslationService>().tr('current location'),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Lat: ${_updateProfileController.latitudeController.text}, Lng: ${_updateProfileController.longitudeController.text}',
                                        style: TextStyle(
                                          color: MyColors.textPrimary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Account Actions
            Card(
              color: MyColors.white,
              surfaceTintColor: MyColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              margin: const EdgeInsets.all(0),
              elevation: 0.5,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // ListTile(
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(10.0),
                    //   ),
                    //   leading: Icon(Icons.security, color: Colors.blue.shade600),
                    //   title: const Text('Change Password'),
                    //   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    //   onTap: () {
                    //     // Navigate to change password
                    //   },
                    // ),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      leading: Icon(Icons.logout, color: MyColors.error),
                      title: Text(Get.find<TranslationService>().tr('logout'), style: TextStyle(color: MyColors.error)),
                      onTap: () {
                        showLogoutConfirmationDialog(context).then((value) {
                          if (value == true) {
                            Get.find<BottomNavController>().changeTab(0);

                            Get.find<SecureStore>().clearAuthToken();
                            Get.offAll(() => const SplashScreen());
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            GlobalTextButton(
              text: Get.find<TranslationService>().tr('delete account'),
              isLoading: _deleteAccountController.isLoading,
              onPressed: () => _showDeleteAccountDialog(context),
              textStyle: TextStyle(
                color: Colors.red.shade600,
                fontWeight: FontWeight.bold,
              ),
              borderRadius: BorderRadius.circular(50.0),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteAccountDialog(BuildContext context) async {
    final result = await showDeleteAccountConfirmationDialog(context);
    if (result == true) {
      if (await _deleteAccountController.deleteAccount()) {
        await Get.offAll(() => const SplashScreen());
      }
    }
  }
}

Future<bool?> showDeleteAccountConfirmationDialog(BuildContext context) async {
  bool? result;
  await GlobalDialog.show(
    context: context,
    title: tr('delete account'),
    message: tr('delete account confirmation'),
    confirmText: tr('delete account'),
    cancelText: tr('cancel'),
    onConfirm: () => result = true,
    onCancel: () => result = false,
    barrierDismissible: false,
    dialogType: DialogType.confirmation,
  );
  return result;
}
