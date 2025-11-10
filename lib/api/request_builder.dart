import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide MultipartFile, FormData, Response;
import 'package:logger/logger.dart';

import '../controllers/locale/locale.dart';
import '../model/api/api_exception.dart';
import '../model/api/api_response.dart';
import '../services/remote_config_service.dart';
import '../stores/preferences_store.dart';
import '../stores/secure_store.dart';
import '../utils/constants/api_constants.dart';
import '../utils/constants/enums.dart';

// ANSI Color codes for terminal output
class LogColors {
  static const String reset = '\x1B[0m';
  static const String green = '\x1B[32m';
  static const String brown = '\x1B[33m';
  static const String red = '\x1B[31m';
  static const String blue = '\x1B[34m';
  static const String cyan = '\x1B[36m';
  static const String magenta = '\x1B[35m';
  static const String yellow = '\x1B[93m';
  static const String gray = '\x1B[90m';
  static const String white = '\x1B[97m';

  // Bold versions
  static const String boldGreen = '\x1B[1;32m';
  static const String boldBrown = '\x1B[1;33m';
  static const String boldRed = '\x1B[1;31m';
  static const String boldBlue = '\x1B[1;34m';
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static String baseUrl = ApiConstants.baseUrl;
  static const Duration timeoutDuration = Duration(seconds: 30);

  ApiService._internal() {
    _initializeDio();
  }

  void _initializeDio() {
    final xApiToken = RemoteConfigService.apiToken;
    final languageCode = _resolveLanguageCode();

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: timeoutDuration,
        receiveTimeout: timeoutDuration,
        validateStatus: (status) => status != null && status >= 200 && status < 600, // Accept all responses except network errors
        responseType: ResponseType.plain,
        contentType: 'application/json',
        headers: <String, dynamic>{
          'X-API-TOKEN': xApiToken,
          'Accept-Language': languageCode,
          'Accept': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      _dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
          return client;
        },
      );
    }

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Ensure language header is always up-to-date per request
        options.headers['Accept-Language'] = _resolveLanguageCode();
        await _addAuthorizationHeader(options);
        _logRequest(options);
        handler.next(options);
      },
      onResponse: (response, handler) {
        _logResponse(response);
        handler.next(response);
      },
      onError: (error, handler) {
        _logError(error);
        handler.next(error);
      },
    ));
  }

  String _resolveLanguageCode() {
    try {
      if (Get.isRegistered<PreferencesStore>()) {
        final code = Get.find<PreferencesStore>().language.locale;
        if (code != null && code.isNotEmpty) return code;
      }
      if (Get.isRegistered<LocaleController>()) {
        final code = Get.find<LocaleController>().getLanguageCode();
        if (code.isNotEmpty) return code;
      }
    } catch (_) {}

    try {
      final code = PlatformDispatcher.instance.locale.languageCode;
      if (code.isNotEmpty) return code;
    } catch (_) {}

    return 'en';
  }

  String _resolveToken() {
    try {
      if (Get.isRegistered<SecureStore>()) {
        final token = Get.find<SecureStore>().authToken;
        if (token.isNotEmpty) return token;
      }
    } catch (_) {}
    return '';
  }

  Future<void> _addAuthorizationHeader(RequestOptions options) async {
    try {
      final token = _resolveToken();
      if (token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      _logger.e('Failed to add authorization header: $e');
    }
  }

  // Generic request method for single objects
  Future<ApiResponse<T>> request<T>({
    required String endpoint,
    required RequestType type,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, String>? headers,
    bool isMultipart = false,
    Map<String, MultipartFile>? files,
    T Function(Map<String, dynamic>)? fromJson,
    Duration? timeout,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await _makeRequest(
        endpoint: endpoint,
        type: type,
        queryParameters: queryParameters,
        data: data,
        headers: headers,
        isMultipart: isMultipart,
        files: files,
        timeout: timeout,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return _handleSingleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleDioException<T>(e);
    } catch (e, stackTrace) {
      _logger.e('Unexpected error', error: e, stackTrace: stackTrace);
      return ApiResponse<T>.error(
        statusCode: 500,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  // Generic request method with custom authorization token
  Future<ApiResponse<T>> requestWithCustomAuth<T>({
    required String endpoint,
    required RequestType type,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, String>? headers,
    bool isMultipart = false,
    Map<String, MultipartFile>? files,
    T Function(Map<String, dynamic>)? fromJson,
    Duration? timeout,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
    required String customAuthToken,
  }) async {
    try {
      final response = await _makeRequestWithCustomAuth(
        endpoint: endpoint,
        type: type,
        queryParameters: queryParameters,
        data: data,
        headers: headers,
        isMultipart: isMultipart,
        files: files,
        timeout: timeout,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        customAuthToken: customAuthToken,
      );

      return _handleSingleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleDioException<T>(e);
    } catch (e, stackTrace) {
      _logger.e('Unexpected error', error: e, stackTrace: stackTrace);
      return ApiResponse<T>.error(
        statusCode: 500,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  // Request method for lists (non-paginated)
  Future<ApiResponse<List<T>>> requestList<T>({
    required String endpoint,
    required RequestType type,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, String>? headers,
    bool isMultipart = false,
    Map<String, MultipartFile>? files,
    T Function(Map<String, dynamic>)? fromJson,
    Duration? timeout,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await _makeRequest(
        endpoint: endpoint,
        type: type,
        queryParameters: queryParameters,
        data: data,
        headers: headers,
        isMultipart: isMultipart,
        files: files,
        timeout: timeout,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return _handleListResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleDioException<List<T>>(e);
    } catch (e, stackTrace) {
      _logger.e('Unexpected error', error: e, stackTrace: stackTrace);
      return ApiResponse<List<T>>.error(
        statusCode: 500,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  // Request method for paginated lists
  Future<ApiResponse<List<T>>> requestPaginatedList<T>({
    required String endpoint,
    required RequestType type,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, String>? headers,
    bool isMultipart = false,
    Map<String, MultipartFile>? files,
    T Function(Map<String, dynamic>)? fromJson,
    Duration? timeout,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await _makeRequest(
        endpoint: endpoint,
        type: type,
        queryParameters: queryParameters,
        data: data,
        headers: headers,
        isMultipart: isMultipart,
        files: files,
        timeout: timeout,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return _handlePaginatedResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleDioException<List<T>>(e);
    } catch (e, stackTrace) {
      _logger.e('Unexpected error', error: e, stackTrace: stackTrace);
      return ApiResponse<List<T>>.error(
        statusCode: 500,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  Future<Response> _makeRequest({
    required String endpoint,
    required RequestType type,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, String>? headers,
    bool isMultipart = false,
    Map<String, MultipartFile>? files,
    Duration? timeout,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    final options = Options(
      headers: headers,
      responseType: ResponseType.plain,
      method: _getMethodString(type),
      contentType: isMultipart ? 'multipart/form-data' : 'application/json',
    );

    if (timeout != null) {
      options.sendTimeout = timeout;
      options.receiveTimeout = timeout;
    }

    dynamic requestData = data;
    if (isMultipart) {
      requestData = await _createFormData(data, files);
    }

    return await _dio.request(
      endpoint,
      data: requestData,
      queryParameters: queryParameters,
      options: options,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response> _makeRequestWithCustomAuth({
    required String endpoint,
    required RequestType type,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, String>? headers,
    bool isMultipart = false,
    Map<String, MultipartFile>? files,
    Duration? timeout,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
    required String customAuthToken,
  }) async {
    // Create headers with custom authorization token
    final requestHeaders = headers ?? {};
    if (customAuthToken.isNotEmpty) {
      requestHeaders['Authorization'] = 'Bearer $customAuthToken';
    }

    final options = Options(
      headers: requestHeaders,
      responseType: ResponseType.plain,
      method: _getMethodString(type),
      contentType: isMultipart ? 'multipart/form-data' : 'application/json',
    );

    if (timeout != null) {
      options.sendTimeout = timeout;
      options.receiveTimeout = timeout;
    }

    dynamic requestData = data;
    if (isMultipart) {
      requestData = await _createFormData(data, files);
    }

    return await _dio.request(
      endpoint,
      data: requestData,
      queryParameters: queryParameters,
      options: options,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<FormData> _createFormData(dynamic data, Map<String, MultipartFile>? files) async {
    final formData = FormData();

    if (data is Map<String, dynamic>) {
      for (final entry in data.entries) {
        final value = entry.value;
        if (value != null) {
          formData.fields.add(MapEntry(entry.key, value.toString()));
        }
      }
    }

    if (files != null) {
      formData.files.addAll(files.entries);
    }

    return formData;
  }

  ApiResponse<T> _handleSingleResponse<T>(
    Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    try {
      final statusCode = response.statusCode ?? 500;
      final decodedData = _parseResponse(response.data);

      // Return full response for all status codes, only check if server error for error handling
      if (decodedData is Map<String, dynamic>) {
        if (fromJson != null) {
          return ApiResponse<T>.fromJson(decodedData, (data) => fromJson(data as Map<String, dynamic>));
        } else {
          return ApiResponse<T>.fromJson(decodedData, (data) => data as T);
        }
      }

      // If we can't parse the response as expected, treat it as raw data
      return ApiResponse<T>(
        status: statusCode >= 200 && statusCode < 300,
        statusCode: statusCode,
        message: statusCode >= 200 && statusCode < 300 ? 'Success' : 'Request completed with status $statusCode',
        data: decodedData as T?,
      );
    } catch (e, stackTrace) {
      _logger.e('Response handling error: $e', error: e, stackTrace: stackTrace);
      return ApiResponse<T>.error(
        statusCode: 500,
        message: 'Failed to handle response: $e',
      );
    }
  }

  ApiResponse<List<T>> _handleListResponse<T>(
    Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    try {
      final statusCode = response.statusCode ?? 500;
      final decodedData = _parseResponse(response.data);

      // Return full response for all status codes
      if (decodedData is Map<String, dynamic>) {
        if (fromJson != null) {
          return ApiResponse<List<T>>.fromListJson(
            decodedData,
            (data) => data.map((item) => fromJson(item as Map<String, dynamic>)).toList(),
          );
        } else {
          return ApiResponse<List<T>>.fromListJson(decodedData, (data) => data.cast<T>());
        }
      }

      // Handle raw array response
      if (decodedData is List) {
        if (fromJson != null) {
          final items = decodedData.map((item) => fromJson(item as Map<String, dynamic>)).toList();
          return ApiResponse<List<T>>(
            status: statusCode >= 200 && statusCode < 300,
            statusCode: statusCode,
            message: statusCode >= 200 && statusCode < 300 ? 'Success' : 'Request completed with status $statusCode',
            data: items,
          );
        } else {
          return ApiResponse<List<T>>(
            status: statusCode >= 200 && statusCode < 300,
            statusCode: statusCode,
            message: statusCode >= 200 && statusCode < 300 ? 'Success' : 'Request completed with status $statusCode',
            data: decodedData.cast<T>(),
          );
        }
      }

      return ApiResponse<List<T>>(
        status: statusCode >= 200 && statusCode < 300,
        statusCode: statusCode,
        message: statusCode >= 200 && statusCode < 300 ? 'Success' : 'Request completed with status $statusCode',
        data: null,
      );
    } catch (e, stackTrace) {
      _logger.e('Response handling error: $e', error: e, stackTrace: stackTrace);
      return ApiResponse<List<T>>.error(
        statusCode: 500,
        message: 'Failed to handle response: $e',
      );
    }
  }

  ApiResponse<List<T>> _handlePaginatedResponse<T>(
    Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    try {
      final statusCode = response.statusCode ?? 500;
      final decodedData = _parseResponse(response.data);

      // Return full response for all status codes
      if (decodedData is Map<String, dynamic>) {
        if (fromJson != null) {
          return ApiResponse<List<T>>.fromPaginatedJson(
            decodedData,
            (data) => data.map((item) => fromJson(item as Map<String, dynamic>)).toList(),
          );
        } else {
          return ApiResponse<List<T>>.fromPaginatedJson(decodedData, (data) => data.cast<T>());
        }
      }

      return ApiResponse<List<T>>(
        status: statusCode >= 200 && statusCode < 300,
        statusCode: statusCode,
        message: statusCode >= 200 && statusCode < 300 ? 'Success' : 'Request completed with status $statusCode',
        data: null,
      );
    } catch (e, stackTrace) {
      _logger.e('Response handling error: $e', error: e, stackTrace: stackTrace);
      return ApiResponse<List<T>>.error(
        statusCode: 500,
        message: 'Failed to handle response: $e',
      );
    }
  }

  ApiResponse<T> _handleDioException<T>(DioException error) {
    _logger.e('Dio error: ${error.type}');

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiResponse<T>.error(
          statusCode: 408,
          message: 'Request timed out. Please check your internet connection.',
        );
      case DioExceptionType.connectionError:
        return ApiResponse<T>.error(
          statusCode: 503,
          message: 'Network connection unavailable. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        if (error.response != null) {
          final statusCode = error.response!.statusCode ?? 500;

          // Only treat server errors (5xx) as actual errors
          if (statusCode >= 500) {
            final exception = _createApiExceptionFromResponse(
              statusCode,
              _parseResponse(error.response!.data),
            );
            return ApiResponse<T>.error(
              statusCode: exception.statusCode,
              message: exception.message,
              data: exception.data,
            );
          }

          // For client errors (4xx), return the full response
          final decodedData = _parseResponse(error.response!.data);
          if (decodedData is Map<String, dynamic>) {
            return ApiResponse<T>.fromJson(decodedData, (data) => data as T);
          }

          return ApiResponse<T>(
            status: false,
            statusCode: statusCode,
            message: 'Client error: $statusCode',
            data: decodedData as T?,
          );
        }
        return ApiResponse<T>.error(
          statusCode: 500,
          message: 'Bad response from server',
        );
      case DioExceptionType.cancel:
        return ApiResponse<T>.error(
          statusCode: 499,
          message: 'Request was cancelled',
        );
      case DioExceptionType.unknown:
      default:
        return ApiResponse<T>.error(
          statusCode: 500,
          message: error.message ?? 'An unexpected network error occurred',
        );
    }
  }

  dynamic _parseResponse(dynamic data) {
    if (data is String) {
      return _parseJsonString(data);
    }
    return data;
  }

  dynamic _parseJsonString(String rawData) {
    try {
      final trimmed = rawData.trim();
      if (trimmed.isEmpty) return null;

      var cleaned = trimmed;
      if (cleaned.startsWith('\uFEFF')) {
        cleaned = cleaned.substring(1);
      }

      final firstBrace = cleaned.indexOf('{');
      final firstBracket = cleaned.indexOf('[');

      var startIndex = -1;
      if (firstBrace >= 0 && firstBracket >= 0) {
        startIndex = firstBrace < firstBracket ? firstBrace : firstBracket;
      } else if (firstBrace >= 0) {
        startIndex = firstBrace;
      } else if (firstBracket >= 0) {
        startIndex = firstBracket;
      }

      if (startIndex >= 0) {
        final jsonPart = cleaned.substring(startIndex);
        return jsonDecode(jsonPart);
      }

      return jsonDecode(cleaned);
    } catch (e) {
      _logger.w('Failed to parse JSON: $e');
      return rawData;
    }
  }

  ApiException _createApiExceptionFromResponse(int statusCode, dynamic data) {
    if (data is Map<String, dynamic>) {
      return ApiException.fromJson(data, statusCode);
    }

    return ApiException(
      message: data?.toString() ?? 'Server error',
      type: _getErrorType(statusCode),
      statusCode: statusCode,
      data: data,
      errors: data is Map<String, dynamic> ? data['errors'] as List<String>? : null,
    );
  }

  String _getMethodString(RequestType type) => type.name.toUpperCase();

  ApiErrorType _getErrorType(int statusCode) {
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

  // Convenience methods for different HTTP methods

  // Single object methods
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
    Duration? timeout,
  }) =>
      request<T>(
        endpoint: endpoint,
        type: RequestType.get,
        queryParameters: queryParameters,
        headers: headers,
        fromJson: fromJson,
        timeout: timeout,
      );

  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
    Duration? timeout,
  }) =>
      request<T>(
        endpoint: endpoint,
        type: RequestType.post,
        data: data,
        queryParameters: queryParameters,
        headers: headers,
        fromJson: fromJson,
        timeout: timeout,
      );

  /// Post method with custom authorization token (bypasses automatic token from SecureStore)
  Future<ApiResponse<T>> postWithCustomAuth<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
    Duration? timeout,
    required String customAuthToken,
  }) =>
      requestWithCustomAuth<T>(
        endpoint: endpoint,
        type: RequestType.post,
        data: data,
        queryParameters: queryParameters,
        headers: headers,
        fromJson: fromJson,
        timeout: timeout,
        customAuthToken: customAuthToken,
      );

  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
    Duration? timeout,
  }) =>
      request<T>(
        endpoint: endpoint,
        type: RequestType.put,
        data: data,
        queryParameters: queryParameters,
        headers: headers,
        fromJson: fromJson,
        timeout: timeout,
      );

  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
    Duration? timeout,
  }) =>
      request<T>(
        endpoint: endpoint,
        type: RequestType.delete,
        queryParameters: queryParameters,
        headers: headers,
        fromJson: fromJson,
        timeout: timeout,
      );

  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
    Duration? timeout,
  }) =>
      request<T>(
        endpoint: endpoint,
        type: RequestType.patch,
        data: data,
        queryParameters: queryParameters,
        headers: headers,
        fromJson: fromJson,
        timeout: timeout,
      );

  // List methods (non-paginated)
  Future<ApiResponse<List<T>>> getList<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
    Duration? timeout,
  }) =>
      requestList<T>(
        endpoint: endpoint,
        type: RequestType.get,
        queryParameters: queryParameters,
        headers: headers,
        fromJson: fromJson,
        timeout: timeout,
      );

  Future<ApiResponse<List<T>>> postList<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
    Duration? timeout,
  }) =>
      requestList<T>(
        endpoint: endpoint,
        type: RequestType.post,
        data: data,
        queryParameters: queryParameters,
        headers: headers,
        fromJson: fromJson,
        timeout: timeout,
      );

  // Paginated list methods
  Future<ApiResponse<List<T>>> getPaginatedList<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
    Duration? timeout,
  }) =>
      requestPaginatedList<T>(
        endpoint: endpoint,
        type: RequestType.get,
        queryParameters: queryParameters,
        headers: headers,
        fromJson: fromJson,
        timeout: timeout,
      );

  Future<ApiResponse<List<T>>> postPaginatedList<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
    Duration? timeout,
  }) =>
      requestPaginatedList<T>(
        endpoint: endpoint,
        type: RequestType.post,
        data: data,
        queryParameters: queryParameters,
        headers: headers,
        fromJson: fromJson,
        timeout: timeout,
      );

  void _logRequest(RequestOptions options) {
    if (!kDebugMode) return;

    try {
      final headers = Map<String, dynamic>.from(options.headers);
      if (headers.containsKey('Authorization')) {
        headers['Authorization'] = 'Bearer ***';
      }
      if (headers.containsKey('X-API-TOKEN')) {
        headers['X-API-TOKEN'] = '***';
      }

      final message = '''🚀 [${options.method}] ${options.uri}
📋 Headers: ${_formatJsonForLogging(headers)}
📦 Data: ${options.data is FormData ? 'FormData (multipart)' : _formatJsonForLogging(options.data)}
🔍 Query: ${_formatJsonForLogging(options.queryParameters)}''';

      final coloredLines = message.split('\n').map((line) => '${LogColors.brown}$line${LogColors.reset}').join('\n');
      _logger.i(coloredLines);
    } catch (e) {
      _logger.e('Error logging request: $e');
    }
  }

  void _logResponse(Response response) {
    if (!kDebugMode) return;

    try {
      final statusCode = response.statusCode ?? 0;
      final isSuccess = statusCode >= 200 && statusCode < 300;
      final statusEmoji = isSuccess ? '✅' : '❌';
      final responseColor = isSuccess ? LogColors.green : LogColors.red;

      dynamic responseData = response.data;
      if (responseData is String) {
        responseData = _parseJsonString(responseData);
      }

      final message = '''$statusEmoji [${response.statusCode}] ${response.requestOptions.uri}
📄 Response: ${_formatJsonForLogging(responseData, maxLength: 5000)}''';

      final coloredLines = message.split('\n').map((line) => '$responseColor$line${LogColors.reset}').join('\n');
      _logger.i(coloredLines);
    } catch (e) {
      _logger.e('Error logging response: $e');
    }
  }

  void _logError(DioException error) {
    if (!kDebugMode) return;

    try {
      dynamic errorData = error.response?.data;
      if (errorData is String) {
        errorData = _parseJsonString(errorData);
      }

      final coloredMessage = '''${LogColors.red}💥 [${error.response?.statusCode ?? 'N/A'}] ${error.requestOptions.uri}
🔥 DioError Type: ${error.type}
📝 Error Message: ${error.message}
⚠️ Underlying Error: ${error.error}
📄 Response: ${_formatJsonForLogging(errorData, maxLength: 2000)}${LogColors.reset}''';

      _logger.e(coloredMessage);
    } catch (e) {
      _logger.e('Error logging error: $e');
    }
  }

  String _formatJsonForLogging(dynamic data, {int maxLength = 3000}) {
    if (data == null) return 'null';

    try {
      String jsonString;

      if (data is String) {
        try {
          final parsed = jsonDecode(data);
          jsonString = _prettyPrintJson(parsed);
        } catch (e) {
          jsonString = data;
        }
      } else {
        jsonString = _prettyPrintJson(data);
      }

      if (jsonString.length > maxLength) {
        final truncated = jsonString.substring(0, maxLength);
        final lastNewline = truncated.lastIndexOf('\n');
        if (lastNewline > maxLength - 200) {
          return '${truncated.substring(0, lastNewline)}\n  ...\n  [Response truncated - ${jsonString.length - maxLength} more characters]';
        }
        return '$truncated\n...\n[Response truncated - ${jsonString.length - maxLength} more characters]';
      }

      return jsonString;
    } catch (e) {
      return data.toString();
    }
  }

  String _prettyPrintJson(dynamic data) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(data);
    } catch (e) {
      return data.toString();
    }
  }

  void dispose() {
    _dio.close();
  }
}
