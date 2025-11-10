import '../../utils/constants/enums.dart';

class ApiException implements Exception {
  final String message;
  final ApiErrorType type;
  final int statusCode;
  final dynamic data;
  final List<String>? errors;

  const ApiException({
    required this.message,
    required this.type,
    required this.statusCode,
    this.data,
    this.errors,
  });

  factory ApiException.fromJson(Map<String, dynamic> json, int statusCode) {
    var message = 'Server error';

    // Extract error message from various possible fields
    if (json.containsKey('message')) {
      message = json['message'].toString();
    } else if (json.containsKey('error')) {
      message = json['error'].toString();
    } else if (json.containsKey('msg')) {
      message = json['msg'].toString();
    } else if (json.containsKey('detail')) {
      message = json['detail'].toString();
    } else if (json.containsKey('errors') && json['errors'] is String) {
      message = json['errors'].toString();
    } else if (json.containsKey('error_description')) {
      message = json['error_description'].toString();
    }

    // Handle validation errors
    List<String>? errors;
    if (json.containsKey('errors') && json['errors'] is List) {
      errors = List<String>.from(json['errors']);
    } else if (json.containsKey('errors') && json['errors'] is Map) {
      errors = (json['errors'] as Map).values.map((e) => e.toString()).toList();
    }

    return ApiException(
      message: message,
      type: _getErrorType(statusCode),
      statusCode: statusCode,
      data: json,
      errors: errors,
    );
  }

  static ApiErrorType _getErrorType(int statusCode) {
    switch (statusCode) {
      case 400:
        return ApiErrorType.badRequest;
      case 401:
        return ApiErrorType.unauthorized;
      case 403:
        return ApiErrorType.forbidden;
      case 404:
        return ApiErrorType.notFound;
      case 422:
        return ApiErrorType.validation;
      case 429:
        return ApiErrorType.rateLimited;
      case 500:
      case 502:
      case 503:
      case 504:
        return ApiErrorType.server;
      default:
        return ApiErrorType.unknown;
    }
  }

  @override
  String toString() {
    return 'ApiException(message: $message, type: $type, statusCode: $statusCode, data: $data)';
  }
}
