import '../../model/api/api_response.dart';
import '../../model/general/language/language.dart';
import '../../model/general/page_model/page_model.dart';
import '../../utils/constants/api_constants.dart';
import '../api_wrapper.dart';

class GeneralApis extends ApiWrapper {
  Future<ApiResponse<List<Language>>> getLanguages() async {
    try {
      final response = await apiService.getList<Language>(
        ApiConstants.languages,
        fromJson: Language.fromJson,
      );
      return response;
    } catch (e) {
      logger.e('Failed to get languages: $e');
      return ApiResponse<List<Language>>.error(
          statusCode: 500, message: 'Failed to get languages: ${e.toString()}');
    }
  }

  Future<ApiResponse> getSettings() async {
    try {
      final response = await apiService.get(ApiConstants.settings);

      return response;
    } catch (e) {
      logger.e('Failed to get settings: $e');
      return ApiResponse.error(
          statusCode: 500, message: 'Failed to get settings: ${e.toString()}');
    }
  }

  Future<ApiResponse<List<PageModel>>> getPages() async {
    try {
      final response = await apiService.getPaginatedList<PageModel>(
        ApiConstants.pages,
        fromJson: PageModel.fromJson,
      );
      return response;
    } catch (e) {
      logger.e('Failed to get pages: $e');
      return ApiResponse<List<PageModel>>.error(
          statusCode: 500, message: 'Failed to get pages: ${e.toString()}');
    }
  }

  Future<ApiResponse> getTranslations() async {
    try {
      final response = await apiService.get(
        ApiConstants.translations,
        queryParameters: {'group': 'app'},
      );

      return response;
    } catch (e) {
      logger.e('Failed to get translations: $e');
      return ApiResponse.error(
          statusCode: 500,
          message: 'Failed to get translations: ${e.toString()}');
    }
  }

  Future<ApiResponse> fetchTranslations(List<String> keys) async {
    try {
      final queryParameters = <String, dynamic>{
        'group': 'app',
        'keys[]': keys,
      };

      final response = await apiService.get(
        ApiConstants.translations,
        queryParameters: queryParameters,
      );

      return response;
    } catch (e) {
      logger.e('Failed to fetch translations: $e');
      return ApiResponse.error(
          statusCode: 500,
          message: 'Failed to fetch translations: ${e.toString()}');
    }
  }

  Future<ApiResponse> addTranslations(List<String> keys) async {
    return fetchTranslations(keys);
  }

  // Future<ApiResponse> send({
  //   String? email,
  //   String? phoneNumber,
  //   String? name,
  //   String? subject,
  //   String? message,
  //   String? type,
  // }) async {
  //   final data = <String, dynamic>{
  //     if (email != null) 'email': email,
  //     if (phoneNumber != null) 'phone_number': phoneNumber,
  //     if (name != null) 'name': name,
  //     if (subject != null) 'subject': subject,
  //     if (message != null) 'message': message,
  //     if (type != null) 'type': type,
  //   };

  //   try {
  //     final response = await apiService.post(
  //       ApiConstants.contactUs,
  //       data: data,
  //     );

  //     return response;
  //   } catch (e) {
  //     logger.e('Failed to login: $e');
  //     return ApiResponse<Login>.error(
  //       statusCode: 500,
  //       message: 'Failed to login: ${e.toString()}',
  //     );
  //   }
  // }
}
