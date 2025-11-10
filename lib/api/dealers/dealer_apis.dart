import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;

import '../../features/my_cars/controllers/add_car_controller.dart';
import '../../model/api/api_response.dart';
import '../../model/cars/car/car.dart';
import '../../model/cars/car_brand/car_brand.dart';
import '../../stores/user_data_store.dart';
import '../../utils/constants/api_constants.dart';
import '../api_wrapper.dart';

class DealerApis extends ApiWrapper {
  Future<ApiResponse<List<Car>>> getCars({
    int? perPage,
    int? page,
    String? query,
    String? categoryId,
    String? brandId,
    String? brandModelId,
    String? bodyTypeId,
    String? transmission,
    String? fuelType,
    String? drivetrain,
    String? condition,
    int? year,
    int? yearFrom,
    int? yearTo,
    double? price,
    double? priceMin,
    double? priceMax,
    int? mileageKm,
    int? mileageMin,
    int? mileageMax,
    int? horsepower,
    int? horsepowerMin,
    int? horsepowerMax,
    int? doors,
    int? seats,
    bool? featured,
    bool? status,
    String? sortAndOrderBy,
  }) async {
    final queryParameters = <String, dynamic>{
      'vendor_id': Get.find<UserDataStore>().id,
      if (perPage != null) 'per_page': perPage,
      if (page != null) 'page': page,
      if (query != null) 'query': query,
      if (categoryId != null) 'category_id': categoryId,
      if (brandId != null) 'brand_id': brandId,
      if (brandModelId != null) 'brand_model_id': brandModelId,
      if (bodyTypeId != null) 'body_type_id': bodyTypeId,
      if (transmission != null) 'transmission': transmission,
      if (fuelType != null) 'fuel_type': fuelType,
      if (drivetrain != null) 'drivetrain': drivetrain,
      if (condition != null) 'condition': condition,
      if (year != null) 'year': year,
      if (yearFrom != null) 'year_from': yearFrom,
      if (yearTo != null) 'year_to': yearTo,
      if (price != null) 'price': price,
      if (priceMin != null) 'price_min': priceMin,
      if (priceMax != null) 'price_max': priceMax,
      if (mileageKm != null) 'mileage_km': mileageKm,
      if (mileageMin != null) 'mileage_min': mileageMin,
      if (mileageMax != null) 'mileage_max': mileageMax,
      if (horsepower != null) 'horsepower': horsepower,
      if (horsepowerMin != null) 'hp_min': horsepowerMin,
      if (horsepowerMax != null) 'hp_max': horsepowerMax,
      if (doors != null) 'doors': doors,
      if (seats != null) 'seats': seats,
      if (featured != null) 'featured': featured,
      if (status != null) 'status': status,
      if (sortAndOrderBy != null) 'sort': sortAndOrderBy,
    };
    try {
      final response = await apiService.getPaginatedList<Car>(
        ApiConstants.cars,
        fromJson: Car.fromJson,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      logger.e('Failed to get cars: $e');
      return ApiResponse<List<Car>>.error(
          statusCode: 500, message: 'Failed to get cars: ${e.toString()}');
    }
  }

  Future<ApiResponse<Car>> addCar({
    required int categoryId,
    required int brandId,
    required int brandModelId,
    required int bodyTypeId,
    required String title,
    required String description,
    required String transmission,
    required String fuelType,
    required String drivetrain,
    required String condition,
    required String year,
    required String price,
    required String downPayment,
    required String mileage,
    required String horsepower,
    required String doors,
    required String seats,
    required File coverImage,
    required List<File> images,
    File? video,
    required List<SelectedColor> colors,
  }) async {
    final formData = FormData.fromMap({
      'category_id': categoryId,
      'brand_id': brandId,
      'brand_model_id': brandModelId,
      'body_type_id': bodyTypeId,
      'title': title,
      'description': description,
      'transmission': transmission,
      'fuel_type': fuelType,
      'drivetrain': drivetrain,
      'condition': condition,
      'year': year,
      'price': price,
      'down_payment': downPayment,
      'mileage_km': mileage,
      'horsepower': horsepower,
      'doors': doors,
      'seats': seats,
      'cover_image': await MultipartFile.fromFile(coverImage.path),
      'images[]': await Future.wait(
          images.map((e) => MultipartFile.fromFile(e.path)).toList()),
      if (video != null) 'video': await MultipartFile.fromFile(video.path),
      // Send colors metadata (without images) as JSON
      'colors': jsonEncode(colors
          .map((color) => {
                'color_id': color.color.id,
                'color': color.color.toJson(),
                'type': color.type,
              })
          .toList()),
    });

    // Add color images as separate MultipartFile entries
    for (var i = 0; i < colors.length; i++) {
      final colorImages = colors[i].images;
      for (var j = 0; j < colorImages.length; j++) {
        // Try alternative key: colors[i][images][j]
        formData.files.add(MapEntry(
          'colors[$i][images][$j]',
          await MultipartFile.fromFile(colorImages[j].path),
        ));
      }
    }

    try {
      final response = await apiService.post<Car>(
        ApiConstants.dealerCars,
        data: formData,
        fromJson: Car.fromJson,
      );
      return response;
    } catch (e) {
      logger.e('Failed to add car: $e');
      return ApiResponse<Car>.error(
          statusCode: 500, message: 'Failed to add car: ${e.toString()}');
    }
  }

  Future<ApiResponse<Car>> updateCar({
    required int carId,
    required int categoryId,
    required int brandId,
    required int brandModelId,
    required int bodyTypeId,
    required String title,
    required String description,
    required String transmission,
    required String fuelType,
    required String drivetrain,
    required String condition,
    required String year,
    required String price,
    required String mileage,
    required String downPayment,
    required String horsepower,
    required String doors,
    required String seats,
    required File coverImage,
    required List<File> images,
    File? video,
    required List<SelectedColor> colors,
  }) async {
    final formData = FormData.fromMap({
      'category_id': categoryId,
      'brand_id': brandId,
      'brand_model_id': brandModelId,
      'body_type_id': bodyTypeId,
      'title': title,
      'description': description,
      'transmission': transmission,
      'fuel_type': fuelType,
      'drivetrain': drivetrain,
      'condition': condition,
      'year': year,
      'price': price,
      'mileage_km': mileage,
      'down_payment': downPayment,
      'horsepower': horsepower,
      'doors': doors,
      'seats': seats,
      'cover_image': await MultipartFile.fromFile(coverImage.path),
      'images[]': await Future.wait(
          images.map((e) => MultipartFile.fromFile(e.path)).toList()),
      if (video != null) 'video': await MultipartFile.fromFile(video.path),
      // Send colors metadata (without images) as JSON
      'colors': jsonEncode(colors
          .map((color) => {
                'color_id': color.color.id,
                'color': color.color.toJson(),
                'type': color.type,
              })
          .toList()),
    });

    // Add color images as separate MultipartFile entries
    for (var i = 0; i < colors.length; i++) {
      final colorImages = colors[i].images;
      for (var j = 0; j < colorImages.length; j++) {
        // Try alternative key: colors[i][images][j]
        formData.files.add(MapEntry(
          'colors[$i][images][$j]',
          await MultipartFile.fromFile(colorImages[j].path),
        ));
      }
    }

    try {
      final response = await apiService.post<Car>(
        '${ApiConstants.dealerCars}/$carId',
        data: formData,
        fromJson: Car.fromJson,
      );
      return response;
    } catch (e) {
      logger.e('Failed to update car: $e');
      return ApiResponse<Car>.error(
          statusCode: 500, message: 'Failed to update car: ${e.toString()}');
    }
  }

  Future<ApiResponse<Car>> deleteCar({
    required int carId,
  }) async {
    try {
      final response = await apiService.delete<Car>(
        '${ApiConstants.dealerCars}/$carId',
      );
      return response;
    } catch (e) {
      logger.e('Failed to delete car: $e');
      return ApiResponse<Car>.error(
          statusCode: 500, message: 'Failed to delete car: ${e.toString()}');
    }
  }

  Future<ApiResponse<Car>> updateCarStatus({
    required String carId,
    required int status,
  }) async {
    final data = <String, dynamic>{
      'status': status,
    };
    try {
      final response = await apiService.post<Car>(
        ApiConstants.updateCarStatus.replaceAll('{carId}', carId),
        data: data,
        fromJson: Car.fromJson,
      );
      return response;
    } catch (e) {
      logger.e('Failed to update car status: $e');
      return ApiResponse<Car>.error(
          statusCode: 500,
          message: 'Failed to update car status: ${e.toString()}');
    }
  }

  Future<ApiResponse<List<CarBrand>>> getDealerBrands() async {
    try {
      final response = await apiService.getPaginatedList<CarBrand>(
        ApiConstants.dealerBrands,
        fromJson: CarBrand.fromJson,
      );
      return response;
    } catch (e) {
      logger.e('Failed to get dealer brands: $e');
      return ApiResponse<List<CarBrand>>.error(
          statusCode: 500,
          message: 'Failed to get dealer brands: ${e.toString()}');
    }
  }

  Future<ApiResponse> addDealerBrand({
    required String brandId,
  }) async {
    try {
      final response = await apiService.post(
        ApiConstants.addDealerBrand,
        queryParameters: {
          'brand_id': brandId,
        },
      );
      return response;
    } catch (e) {
      logger.e('Failed to add dealer brand: $e');
      return ApiResponse.error(
          statusCode: 500,
          message: 'Failed to add dealer brand: ${e.toString()}');
    }
  }

  Future<ApiResponse> removeDealerBrand({
    required String brandId,
  }) async {
    try {
      final response = await apiService.delete(
        ApiConstants.removeDealerBrand,
        queryParameters: {
          'brand_id': brandId,
        },
      );
      return response;
    } catch (e) {
      logger.e('Failed to remove dealer brand: $e');
      return ApiResponse<CarBrand>.error(
          statusCode: 500,
          message: 'Failed to remove dealer brand: ${e.toString()}');
    }
  }
}
