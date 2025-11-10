import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;

import '../../model/api/api_response.dart';
import '../../model/auth/info/info.dart';
import '../../model/auth/login/login.dart';
import '../../model/auth/register/register.dart';
import '../../model/auth/user/user.dart';
import '../../stores/secure_store.dart';
import '../../utils/constants/api_constants.dart';
import '../api_wrapper.dart';

class AuthApis extends ApiWrapper {
  Future<ApiResponse<Login>> login({
    required String emailOrPhone,
    required String password,
  }) async {
    final fcmToken = Get.find<SecureStore>().fcmToken;

    final queryParameters = <String, dynamic>{
      'email_or_phone': emailOrPhone,
      'password': password,
      'fcm_token': fcmToken.isEmpty ? 'fcmToken' : fcmToken,
      'remember': true,
    };

    try {
      final response = await apiService.post<Login>(
        ApiConstants.login,
        queryParameters: queryParameters,
        fromJson: Login.fromJson,
      );

      return response;
    } catch (e) {
      logger.e('Failed to login: $e');
      return ApiResponse<Login>.error(
        statusCode: 500,
        message: 'Failed to login: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse<Register>> register({
    required String phoneNumber,
    required String password,
    String? firstName,
    String? lastName,
    String? storeName,
    String? address,
    String? latitude,
    String? longitude,
  }) async {
    final fcmToken = Get.find<SecureStore>().fcmToken;
    final queryParameters = <String, dynamic>{
      'phone_number': phoneNumber,
      'password': password,
      'fcm_token': fcmToken.isEmpty ? 'fcmToken' : fcmToken,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (storeName != null) 'store_name': storeName,
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'type': 1,
    };

    try {
      final response = await apiService.post<Register>(
        ApiConstants.register,
        queryParameters: queryParameters,
        fromJson: Register.fromJson,
      );

      return response;
    } catch (e) {
      logger.e('Failed to register: $e');
      return ApiResponse<Register>.error(
        statusCode: 500,
        message: 'Failed to register: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse<Register>> socialLogin({
    required String email,
    required String provider,
    required String providerId,
    required String firstName,
    required String lastName,
  }) async {
    final fcmToken = Get.find<SecureStore>().fcmToken;
    final queryParameters = <String, dynamic>{
      'email': email,
      'provider': provider,
      'provider_id': providerId,
      'fcm_token': fcmToken.isEmpty ? 'fcmToken' : fcmToken,
      'first_name': firstName,
      'last_name': lastName,
    };

    try {
      final response = await apiService.post<Register>(
        ApiConstants.socialLogin,
        queryParameters: queryParameters,
        fromJson: Register.fromJson,
      );

      return response;
    } catch (e) {
      logger.e('Failed to social login: $e');
      return ApiResponse<Register>.error(
        statusCode: 500,
        message: 'Failed to social login: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse<User>> verifyOtp({
    required String type,
    required String code,
  }) async {
    final data = <String, dynamic>{
      'type': type,
      'code': code,
    };

    final queryParameters = <String, dynamic>{
      'type': type,
    };

    try {
      final response = await apiService.post<User>(
        ApiConstants.verifyOtp,
        data: data,
        queryParameters: queryParameters,
        fromJson: User.fromJson,
      );

      return response;
    } catch (e) {
      logger.e('Failed to verify OTP: $e');
      return ApiResponse<User>.error(
        statusCode: 500,
        message: 'Failed to verify OTP: ${e.toString()}',
      );
    }
  }

  /// Verify OTP using a custom token (for temporary token from registration)
  Future<ApiResponse<User>> verifyOtpWithToken({
    required String type,
    required String code,
    required String token,
  }) async {
    final data = <String, dynamic>{
      'type': type,
      'code': code,
    };

    final queryParameters = <String, dynamic>{
      'type': type,
    };

    try {
      final response = await apiService.postWithCustomAuth<User>(
        ApiConstants.verifyOtp,
        data: data,
        queryParameters: queryParameters,
        fromJson: User.fromJson,
        customAuthToken: token,
      );

      return response;
    } catch (e) {
      logger.e('Failed to verify OTP with custom token: $e');
      return ApiResponse<User>.error(
        statusCode: 500,
        message: 'Failed to verify OTP with custom token: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse> logout() async {
    try {
      final response = await apiService.post(ApiConstants.logout);

      return response;
    } catch (e) {
      logger.e('Failed to logout: $e');
      return ApiResponse.error(
        statusCode: 500,
        message: 'Failed to logout: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse<Info>> info() async {
    try {
      final response = await apiService.get<Info>(
        ApiConstants.info,
        fromJson: Info.fromJson,
      );

      return response;
    } catch (e) {
      logger.e('Failed to get info: $e');
      return ApiResponse.error(
        statusCode: 500,
        message: 'Failed to get info: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse<User>> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImage,
    String? storeName,
    String? address,
    String? latitude,
    String? longitude,
    File? logo,
  }) async {
    final formData = FormData.fromMap({
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (logo != null) 'logo': await MultipartFile.fromFile(logo.path),
      if (storeName != null) 'store_name': storeName,
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    });

    try {
      final response = await apiService.post<User>(
        ApiConstants.updateProfile,
        data: formData,
        fromJson: User.fromJson,
      );

      return response;
    } catch (e) {
      logger.e('Failed to update profile: $e');
      return ApiResponse<User>.error(
        statusCode: 500,
        message: 'Failed to update profile: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse> requestReset({required String identity}) async {
    final queryParameters = <String, dynamic>{
      'identity': identity,
    };

    try {
      final response = await apiService.post(
        ApiConstants.requestReset,
        queryParameters: queryParameters,
      );

      return response;
    } catch (e) {
      logger.e('Failed to request password reset: $e');
      return ApiResponse.error(
        statusCode: 500,
        message: 'Failed to request password reset: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse> resetPassword({
    required String identity,
    required String code,
    required String newPassword,
  }) async {
    final queryParameters = <String, dynamic>{
      'identity': identity,
      'code': code,
      'password': newPassword,
      'password_confirmation': newPassword,
    };

    try {
      final response = await apiService.post(
        ApiConstants.resetPassword,
        queryParameters: queryParameters,
      );

      return response;
    } catch (e) {
      logger.e('Failed to reset password: $e');
      return ApiResponse.error(
        statusCode: 500,
        message: 'Failed to reset password: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse> checkVerificationStatus({
    required String identity,
  }) async {
    try {
      final response = await apiService.post(
        ApiConstants.checkVerificationStatus,
        data: {
          'identity': identity,
        },
      );

      return response;
    } catch (e) {
      logger.e('Failed to check verification status: $e');
      return ApiResponse.error(
        statusCode: 500,
        message: 'Failed to check verification status: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final queryParameters = <String, dynamic>{
      'current_password': currentPassword,
      'new_password': newPassword,
    };

    try {
      final response = await apiService.post(
        ApiConstants.changePassword,
        queryParameters: queryParameters,
      );

      return response;
    } catch (e) {
      logger.e('Failed to change password: $e');
      return ApiResponse.error(
        statusCode: 500,
        message: 'Failed to change password: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse> deleteAccount() async {
    try {
      final response = await apiService.delete(ApiConstants.deleteAccount);

      return response;
    } catch (e) {
      logger.e('Failed to delete account: $e');
      return ApiResponse.error(
        statusCode: 500,
        message: 'Failed to delete account: ${e.toString()}',
      );
    }
  }
}
