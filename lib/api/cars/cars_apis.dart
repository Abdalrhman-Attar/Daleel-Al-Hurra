import '../../model/api/api_response.dart';
import '../../model/cars/brand_model/brand_model.dart';
import '../../model/cars/car/car.dart';
import '../../model/cars/car_body_type/car_body_type.dart';
import '../../model/cars/car_brand/car_brand.dart';
import '../../model/cars/car_category/car_category.dart';
import '../../model/cars/color/d_color.dart';
import '../../model/cars/dealer/dealer.dart';
import '../../utils/constants/api_constants.dart';
import '../api_wrapper.dart';

class CarsApis extends ApiWrapper {
  Future<ApiResponse<List<DColor>>> getCarColors({
    bool? featured,
    String? name,
    int? perPage,
    int? page,
  }) async {
    final queryParameters = <String, dynamic>{
      if (featured != null) 'featured': featured,
      if (name != null) 'name': name,
      if (perPage != null) 'per_page': perPage,
      if (page != null) 'page': page,
    };
    try {
      final response = await apiService.getPaginatedList<DColor>(
        ApiConstants.carColors,
        fromJson: DColor.fromJson,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      logger.e('Failed to get car colors: $e');
      return ApiResponse<List<DColor>>.error(
          statusCode: 500, message: 'Failed to get cars: ${e.toString()}');
    }
  }

  Future<ApiResponse<List<CarCategory>>> getCarCategories({
    bool? featured,
    String? name,
  }) async {
    final queryParameters = <String, dynamic>{
      if (featured != null) 'featured': featured,
      if (name != null) 'name': name,
    };
    try {
      final response = await apiService.getPaginatedList<CarCategory>(
        ApiConstants.carCategories,
        fromJson: CarCategory.fromJson,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      logger.e('Failed to get car categories: $e');
      return ApiResponse<List<CarCategory>>.error(
          statusCode: 500,
          message: 'Failed to get car categories: ${e.toString()}');
    }
  }

  Future<ApiResponse<List<Dealer>>> getDealers({
    String? name,
    int? perPage,
    int? page,
  }) async {
    final queryParameters = <String, dynamic>{
      if (perPage != null) 'per_page': perPage,
      if (name != null) 'name': name,
      if (page != null) 'page': page,
    };
    try {
      final response = await apiService.getPaginatedList<Dealer>(
        ApiConstants.carDealers,
        fromJson: Dealer.fromJson,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      logger.e('Failed to get dealers: $e');
      return ApiResponse<List<Dealer>>.error(
          statusCode: 500, message: 'Failed to get dealers: ${e.toString()}');
    }
  }

  /// Get a single dealer by ID
  Future<ApiResponse<Dealer>> getDealerById(int dealerId) async {
    try {
      final response = await apiService.get<Dealer>(
        '${ApiConstants.carDealers}/$dealerId',
        fromJson: Dealer.fromJson,
      );
      return response;
    } catch (e) {
      logger.e('Failed to get dealer by ID $dealerId: $e');
      return ApiResponse<Dealer>.error(
          statusCode: 500, message: 'Failed to get dealer: ${e.toString()}');
    }
  }

  Future<ApiResponse<List<CarBodyType>>> getCarBodyTypes({
    bool? featured,
    String? name,
    int? perPage,
    int? page,
  }) async {
    final queryParameters = <String, dynamic>{
      if (featured != null) 'featured': featured,
      if (perPage != null) 'per_page': perPage,
      if (name != null) 'name': name,
      if (page != null) 'page': page,
    };
    try {
      final response = await apiService.getPaginatedList<CarBodyType>(
        ApiConstants.carBodyTypes,
        fromJson: CarBodyType.fromJson,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      logger.e('Failed to get car body types: $e');
      return ApiResponse<List<CarBodyType>>.error(
          statusCode: 500,
          message: 'Failed to get car body types: ${e.toString()}');
    }
  }

  Future<ApiResponse<List<CarBrand>>> getCarBrands({
    bool? featured,
    String? name,
    int? perPage,
    int? page,
  }) async {
    final queryParameters = <String, dynamic>{
      if (featured != null) 'featured': featured,
      if (perPage != null) 'per_page': perPage,
      if (name != null) 'name': name,
      if (page != null) 'page': page,
    };
    try {
      final response = await apiService.getPaginatedList<CarBrand>(
        ApiConstants.carBrands,
        fromJson: CarBrand.fromJson,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      logger.e('Failed to get car brands: $e');
      return ApiResponse<List<CarBrand>>.error(
          statusCode: 500,
          message: 'Failed to get car brands: ${e.toString()}');
    }
  }

  Future<ApiResponse<List<BrandModel>>> getBrandModels({
    required String brandId,
    String? name,
    int? perPage,
    int? page,
  }) async {
    final queryParameters = <String, dynamic>{
      'brand_id': brandId,
      if (perPage != null) 'per_page': perPage,
      if (name != null) 'name': name,
      if (page != null) 'page': page,
    };
    try {
      final response = await apiService.getPaginatedList<BrandModel>(
        ApiConstants.carBrandModels,
        fromJson: BrandModel.fromJson,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      logger.e('Failed to get brand models: $e');
      return ApiResponse<List<BrandModel>>.error(
          statusCode: 500,
          message: 'Failed to get brand models: ${e.toString()}');
    }
  }

  Future<ApiResponse<List<Car>>> getCars({
    int? perPage,
    int? page,
    String? query,
    String? categoryId,
    String? dealerId,
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
    int? engineCc,
    int? engineCcMin,
    int? engineCcMax,
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
      if (perPage != null) 'per_page': perPage,
      if (page != null) 'page': page,
      if (query != null) 'query': query,
      if (categoryId != null) 'category_id': categoryId,
      if (dealerId != null) 'vendor_id': dealerId,
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
      if (engineCc != null) 'engine_cc': engineCc,
      if (engineCcMin != null) 'engine_cc_min': engineCcMin,
      if (engineCcMax != null) 'engine_cc_max': engineCcMax,
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

  /// Get a single car by ID
  Future<ApiResponse<Car>> getCarById(int carId) async {
    try {
      final response = await apiService.get<Car>(
        '${ApiConstants.cars}/details',
        fromJson: Car.fromJson,
        queryParameters: {
          'id': carId,
        },
      );
      return response;
    } catch (e) {
      logger.e('Failed to get car by ID $carId: $e');
      return ApiResponse<Car>.error(
          statusCode: 500, message: 'Failed to get car: ${e.toString()}');
    }
  }
}
