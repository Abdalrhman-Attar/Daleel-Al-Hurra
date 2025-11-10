import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api/auth/auth_apis.dart';
import '../../../module/toast.dart';
import '../../../stores/preferences_store.dart';
import '../../../stores/secure_store.dart';
import '../../../stores/user_data_store.dart';

class LoginController extends GetxController {
  final RxBool _isLoading = false.obs;
  final RxString _temporaryToken = ''.obs;

  final Rx<GlobalKey<FormState>> _formKey = GlobalKey<FormState>().obs;
  final Rx<TextEditingController> _phoneNumberController =
      TextEditingController().obs;
  final Rx<TextEditingController> _passwordController =
      TextEditingController().obs;

  bool get isLoading => _isLoading.value;
  String get temporaryToken => _temporaryToken.value;

  GlobalKey<FormState> get formKey => _formKey.value;

  TextEditingController get phoneNumberController =>
      _phoneNumberController.value;
  TextEditingController get passwordController => _passwordController.value;

  set isLoading(bool loading) => _isLoading.value = loading;

  void clearControllers() {
    phoneNumberController.clear();
    passwordController.clear();
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
  }

  /// Login function return values:
  /// 0: Login failed
  /// 1: Login successful and user is verified (navigate to BottomNavPage)
  /// 2: Login successful but user is not verified (navigate to OTP page)
  Future<int> login() async {
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

      final response = await AuthApis().login(
        emailOrPhone: formattedPhoneNumber,
        password: passwordController.text,
      );
      if (response.statusCode == 403) {
        // phone number not verified
        final userData = response.data!.user;
        final token = response.data!.token ?? '';

        // Store user data
        final userDataStore = Get.find<UserDataStore>();
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

        // User is not verified - store token temporarily and navigate to OTP page
        _temporaryToken.value = token;

        isLoading = false;

        Toast.s(response.message ?? 'Please verify your phone number');
        return 2;
      }
      if (response.isSuccess && response.data != null) {
        final userData = response.data!.user;
        final token = response.data!.token ?? '';

        // Store user data
        final userDataStore = Get.find<UserDataStore>();
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

        // Check if user is verified
        final isVerified = userData?.phoneNumberVerified ?? false;
        debugPrint('isVerified: $isVerified');
        if (isVerified) {
          // User is verified - save token permanently and navigate to BottomNavPage
          Get.find<SecureStore>().authToken = token;
          Get.find<PreferencesStore>().isLoggedIn = true;
          debugPrint('SecureStore: ${Get.find<SecureStore>().authToken}');

          clearForm();
          clearControllers();
          isLoading = false;

          Toast.s(response.message ?? 'Login successful');
          return 1; // Verified user
        } else {
          // User is not verified - store token temporarily and navigate to OTP page
          _temporaryToken.value = token;

          clearForm();
          clearControllers();
          isLoading = false;

          Toast.s(response.message ?? 'Please verify your phone number');
          return 2; // Unverified user - needs OTP
        }
      }

      // Login failed - show errors
      final errors = response.errors ?? [];
      for (var i = 0; i < errors.length; i++) {
        Future.delayed(Duration(milliseconds: i * 500), () {
          Toast.e(response.message ?? 'Login failed');
        });
      }
      return 0; // Login failed
    } catch (e) {
      return 0; // Login failed
    } finally {
      isLoading = false;
    }
  }

  /// Request OTP for unverified users (sends OTP to phone)
  Future<bool> requestOtpForVerification() async {
    if (temporaryToken.isEmpty) {
      return false; // No temporary token available
    }

    isLoading = true;

    try {
      final response = await AuthApis().checkVerificationStatus(
        identity: Get.find<UserDataStore>().phoneNumber,
      );

      if (response.isSuccess) {
        Toast.s('OTP sent to your phone number');
        return true;
      }

      Toast.e('Failed to send OTP', description: response.message);
      return false;
    } catch (e) {
      Toast.e('Failed to send OTP', description: e.toString());
      return false;
    } finally {
      isLoading = false;
    }
  }

  /// Verify OTP using temporary token (for unverified login users)
  Future<bool> verifyOtpWithTemporaryToken({
    required String code,
  }) async {
    if (temporaryToken.isEmpty) {
      return false; // No token available for verification
    }

    isLoading = true;

    try {
      final response = await AuthApis().verifyOtpWithToken(
        type: 'phone',
        code: code,
        token: temporaryToken,
      );

      if (response.isSuccess) {
        // OTP verification successful - now save token permanently
        _saveTemporaryTokenPermanently();
        Get.find<PreferencesStore>().isLoggedIn = true;
        Toast.s('Phone number verified successfully');
        return true;
      }

      Toast.e('Invalid OTP code', description: response.message);
      return false;
    } catch (e) {
      Toast.e('Verification failed', description: e.toString());
      return false;
    } finally {
      isLoading = false;
    }
  }

  /// Save the temporary token permanently to secure store after successful verification
  void _saveTemporaryTokenPermanently() {
    if (temporaryToken.isNotEmpty) {
      Get.find<SecureStore>().authToken = temporaryToken;
      debugPrint(
          'Temporary token saved permanently: ${Get.find<SecureStore>().authToken}');
    }
  }

  /// Clear the temporary token (call this when verification fails or user navigates away)
  void clearTemporaryToken() {
    _temporaryToken.value = '';
  }

  /// Check if user has a temporary token available for verification
  bool get hasTemporaryToken => temporaryToken.isNotEmpty;
}
