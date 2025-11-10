import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api/auth/auth_apis.dart';
import '../../../services/download_service.dart';
import '../../../services/image_picker_service.dart';
import '../../../stores/user_data_store.dart';
import '../../../utils/loggers/custom_logger.dart';

class UpdateProfileController extends GetxController {
  final RxBool _isLoading = false.obs;
  final RxBool _isEditing = false.obs;
  bool get isEditing => _isEditing.value;
  bool get isLoading => _isLoading.value;

  set isLoading(bool loading) => _isLoading.value = loading;
  set isEditing(bool editing) => _isEditing.value = editing;
  final Rx<GlobalKey<FormState>> _formKey = GlobalKey<FormState>().obs;
  final RxString _oldLogo = RxString(Get.find<UserDataStore>().profileImage);
  final Rx<File?> _newLogo = Rx<File?>(null);

  // Getters for UI
  String? get profileImage => newLogo != null ? null : oldLogo;
  File? get logoFile => newLogo;

  final Rx<TextEditingController> _firstNameController = TextEditingController(
    text: Get.find<UserDataStore>().firstName,
  ).obs;
  final Rx<TextEditingController> _lastNameController = TextEditingController(
    text: Get.find<UserDataStore>().lastName,
  ).obs;

  final Rx<TextEditingController> _phoneNumberController = TextEditingController(
    text: Get.find<UserDataStore>().phoneNumber,
  ).obs;
  final Rx<TextEditingController> _storeNameController = TextEditingController(
    text: Get.find<UserDataStore>().storeName,
  ).obs;
  final Rx<TextEditingController> _addressController = TextEditingController(
    text: Get.find<UserDataStore>().address,
  ).obs;
  final Rx<TextEditingController> _latitudeController = TextEditingController(
    text: Get.find<UserDataStore>().latitude,
  ).obs;
  final Rx<TextEditingController> _longitudeController = TextEditingController(
    text: Get.find<UserDataStore>().longitude,
  ).obs;

  GlobalKey<FormState> get formKey => _formKey.value;

  String? get oldLogo => _oldLogo.value;

  TextEditingController get firstNameController => _firstNameController.value;
  TextEditingController get lastNameController => _lastNameController.value;
  TextEditingController get phoneNumberController => _phoneNumberController.value;
  TextEditingController get storeNameController => _storeNameController.value;
  TextEditingController get addressController => _addressController.value;
  TextEditingController get latitudeController => _latitudeController.value;
  TextEditingController get longitudeController => _longitudeController.value;
  File? get newLogo => _newLogo.value;

  // setters
  set oldLogo(String? logo) => _oldLogo.value = logo ?? '';
  set newLogo(File? logo) => _newLogo.value = logo;

  Future<void> toggleEdit() async {
    isEditing = !isEditing;
    if (!isEditing) {
      // Validate location before saving
      if (latitudeController.text.isEmpty || longitudeController.text.isEmpty) {
        // Re-enable editing mode if validation fails
        isEditing = true;
        Get.snackbar(
          'Validation Error',
          'Please select a location',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      // Save changes when exiting edit mode
      await updateProfile();
    }
  }

  void clearControllers() {
    firstNameController.clear();
    lastNameController.clear();
    phoneNumberController.clear();
    storeNameController.clear();
    addressController.clear();
    latitudeController.clear();
    longitudeController.clear();
    oldLogo = '';
    newLogo = null;
  }

  void clearForm() => formKey.currentState?.reset();

  void clearLoading() => isLoading = false;
  @override
  void onInit() {
    super.onInit();
    _formKey.value = GlobalKey<FormState>();
    clearControllers();
    firstNameController.text = Get.find<UserDataStore>().firstName;
    lastNameController.text = Get.find<UserDataStore>().lastName;
    phoneNumberController.text = Get.find<UserDataStore>().phoneNumber;
    storeNameController.text = Get.find<UserDataStore>().storeName;
    addressController.text = Get.find<UserDataStore>().address;
    latitudeController.text = Get.find<UserDataStore>().latitude;
    longitudeController.text = Get.find<UserDataStore>().longitude;
    oldLogo = Get.find<UserDataStore>().profileImage;
    clearForm();
    clearLoading();
  }

  Future<void> updateProfile() async {
    isLoading = true;

    try {
      // Get logo file (download if it's a URL)
      var logoFile = newLogo;
      if (logoFile == null && oldLogo != null && oldLogo!.isNotEmpty && DownloadService.isValidUrl(oldLogo!)) {
        logoFile = await DownloadService.downloadImageFromUrl(oldLogo!);
      }

      // Format phone number with country code if not already formatted
      var formattedPhoneNumber = phoneNumberController.text.trim();
      if (!formattedPhoneNumber.startsWith('+')) {
        // Remove leading 0 if present for Jordanian numbers
        if (formattedPhoneNumber.startsWith('0')) {
          formattedPhoneNumber = formattedPhoneNumber.substring(1);
        }
        // Add Jordanian country code (+962)
        formattedPhoneNumber = '+962$formattedPhoneNumber';
      }

      return await AuthApis()
          .updateProfile(
        phoneNumber: formattedPhoneNumber,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        storeName: storeNameController.text,
        address: addressController.text,
        latitude: latitudeController.text,
        longitude: longitudeController.text,
        logo: logoFile,
      )
          .then((value) async {
        if (value.isSuccess) {
          final userDataStore = Get.find<UserDataStore>();
          final userData = value.data;

          if (userData != null) {
            userDataStore.id = userData.id;
            userDataStore.firstName = userData.firstName;
            userDataStore.lastName = userData.lastName;
            userDataStore.phoneNumber = userData.phoneNumber;
            userDataStore.profileImage = userData.logo;
            userDataStore.storeName = userData.storeName;
            userDataStore.address = userData.address;
            userDataStore.latitude = userData.latitude;
            userDataStore.longitude = userData.longitude;
            userDataStore.userType = userData.userType;
            userDataStore.status = userData.status;
            userDataStore.brands = userData.brands;
          }

          clearControllers();
          firstNameController.text = userDataStore.firstName;
          lastNameController.text = userDataStore.lastName;
          phoneNumberController.text = userDataStore.phoneNumber;
          oldLogo = userDataStore.profileImage;

          clearForm();
          isLoading = false;
        }
      });
    } catch (e) {
      logger.e('Failed to update profile: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> pickLogoImage() async {
    final source = await ImagePickerService.showImageSourceDialog(context: Get.context!);
    if (source != null) {
      final image = await ImagePickerService.pickImage(
        context: Get.context!,
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image != null) {
        newLogo = image;
        // Clear old logo when new one is selected
        oldLogo = null;
      }
    }
  }

  Future<void> pickCommercialRegisterImage() async {
    final source = await ImagePickerService.showImageSourceDialog(context: Get.context!);
    if (source != null) {
      // TODO: Implement commercial register image picking
      await ImagePickerService.pickImage(
        context: Get.context!,
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
    }
  }

  void removeLogoImage() {
    newLogo = null;
    oldLogo = null;
  }
}
