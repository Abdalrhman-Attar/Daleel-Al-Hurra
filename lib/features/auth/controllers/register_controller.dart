import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api/auth/auth_apis.dart';
import '../../../module/toast.dart';
import '../../../stores/secure_store.dart';
import '../../../stores/user_data_store.dart';

class RegisterController extends GetxController {
  final RxBool _isLoading = false.obs;
  final RxString _temporaryToken = ''.obs;

  bool get isLoading => _isLoading.value;
  String get temporaryToken => _temporaryToken.value;

  set isLoading(bool loading) => _isLoading.value = loading;

  final Rx<GlobalKey<FormState>> _formKey = GlobalKey<FormState>().obs;
  final Rx<TextEditingController> _firstNameController =
      TextEditingController().obs;
  final Rx<TextEditingController> _lastNameController =
      TextEditingController().obs;
  final Rx<TextEditingController> _phoneNumberController =
      TextEditingController().obs;
  final Rx<TextEditingController> _passwordController =
      TextEditingController().obs;
  final Rx<TextEditingController> _confirmPasswordController =
      TextEditingController().obs;
  final Rx<TextEditingController> _storeNameController =
      TextEditingController().obs;
  final Rx<TextEditingController> _addressController =
      TextEditingController().obs;
  final Rx<TextEditingController> _latitudeController =
      TextEditingController().obs;
  final Rx<TextEditingController> _longitudeController =
      TextEditingController().obs;

  // Reactive strings for latitude and longitude to make them reactive
  final RxString _latitude = ''.obs;
  final RxString _longitude = ''.obs;

  GlobalKey<FormState> get formKey => _formKey.value;
  TextEditingController get firstNameController => _firstNameController.value;
  TextEditingController get lastNameController => _lastNameController.value;
  TextEditingController get phoneNumberController =>
      _phoneNumberController.value;
  TextEditingController get passwordController => _passwordController.value;
  TextEditingController get confirmPasswordController =>
      _confirmPasswordController.value;
  TextEditingController get storeNameController => _storeNameController.value;
  TextEditingController get addressController => _addressController.value;
  TextEditingController get latitudeController => _latitudeController.value;
  TextEditingController get longitudeController => _longitudeController.value;

  // Reactive getters for latitude and longitude
  String get latitude => _latitude.value;
  String get longitude => _longitude.value;

  set latitude(String value) {
    _latitude.value = value;
    _latitudeController.value.text = value;
  }

  set longitude(String value) {
    _longitude.value = value;
    _longitudeController.value.text = value;
  }

  void clearControllers() {
    firstNameController.clear();
    lastNameController.clear();
    phoneNumberController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    storeNameController.clear();
    addressController.clear();
    latitudeController.clear();
    longitudeController.clear();
    _latitude.value = '';
    _longitude.value = '';
  }

  void clearForm() => formKey.currentState?.reset();

  void clearLoading() => isLoading = false;

  @override
  void onInit() {
    super.onInit();
    _formKey.value = GlobalKey<FormState>();
    clearControllers();
    clearForm();
    clearLoading();

    // Add listeners to sync TextEditingController changes with reactive values
    _latitudeController.value.addListener(() {
      if (_latitudeController.value.text != _latitude.value) {
        _latitude.value = _latitudeController.value.text;
      }
    });

    _longitudeController.value.addListener(() {
      if (_longitudeController.value.text != _longitude.value) {
        _longitude.value = _longitudeController.value.text;
      }
    });
  }

  Future<bool> register() async {
    isLoading = true;

    try {
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

      final response = await AuthApis().register(
        phoneNumber: formattedPhoneNumber,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        password: passwordController.text,
        storeName: storeNameController.text,
        address: addressController.text,
        latitude: latitudeController.text,
        longitude: longitudeController.text,
      );

      if (response.isSuccess && response.data != null) {
        // Store token temporarily for OTP verification (don't save to secure store yet)
        _temporaryToken.value = response.data!.token ?? '';

        final userDataStore = Get.find<UserDataStore>();
        final userData = response.data!.user;

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
        clearForm();
        isLoading = false;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
    }
  }

  /// Verify OTP using the temporary token from registration
  Future<bool> verifyOtp({
    required String type,
    required String code,
  }) async {
    if (temporaryToken.isEmpty) {
      return false; // No token available for verification
    }

    isLoading = true;

    try {
      final response = await AuthApis().verifyOtpWithToken(
        type: type,
        code: code,
        token: temporaryToken,
      );

      if (response.isSuccess) {
        // OTP verification successful - now save token permanently
        _saveTokenPermanently();
        return true;
      }

      // Check if OTP is expired/invalid (422 status code)
      if (response.statusCode == 422) {
        // Show error message for expired OTP
        Toast.e('OTP code expired or invalid');
        return false; // Return false since verification failed
      }

      return false;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
    }
  }

  /// Resend OTP code for registration
  Future<void> resendOtp() async {
    try {
      final response = await AuthApis().checkVerificationStatus(
        identity: Get.find<UserDataStore>().phoneNumber,
      );

      if (response.isSuccess) {
        // Show success message that new code has been sent
        Toast.s('New verification code sent',
            description: 'Please check your phone');
      } else {
        // Show error if resend failed
        Toast.e('Failed to send new code', description: 'Please try again');
      }
    } catch (e) {
      Toast.e('Error sending new code');
    }
  }

  /// Save the temporary token permanently to secure store after successful verification
  void _saveTokenPermanently() {
    if (temporaryToken.isNotEmpty) {
      Get.find<SecureStore>().authToken = temporaryToken;
    }
  }

  /// Clear the temporary token (call this when verification fails or user navigates away)
  void clearTemporaryToken() {
    _temporaryToken.value = '';
  }

  /// Check if user has a temporary token available for verification
  bool get hasTemporaryToken => temporaryToken.isNotEmpty;
}
