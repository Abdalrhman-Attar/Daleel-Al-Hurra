import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../utils/helpers/helper_functions.dart';
import '../brand_model/brand_model.dart';
import '../car_body_type/car_body_type.dart';
import '../car_brand/car_brand.dart';
import '../car_category/car_category.dart';
import '../car_color/car_color.dart';
import '../dealer/dealer.dart';

part 'car.freezed.dart';
part 'car.g.dart';

// int to string converter
class StringConverter implements JsonConverter<String?, dynamic> {
  const StringConverter();

  @override
  String? fromJson(dynamic json) {
    if (json == null) return null;
    return json.toString();
  }

  @override
  dynamic toJson(String? object) => object;
}

class DoubleConverter implements JsonConverter<double?, dynamic> {
  const DoubleConverter();

  @override
  double? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is double) return json;
    if (json is int) return json.toDouble();
    if (json is String) {
      if (json.isEmpty) return null;
      return double.tryParse(json);
    }
    throw FormatException('Invalid double format: $json');
  }

  @override
  dynamic toJson(double? object) => object;
}

class IntConverter implements JsonConverter<int?, dynamic> {
  const IntConverter();

  @override
  int? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is int) return json;
    if (json is double) return json.toInt();
    if (json is String) {
      if (json.isEmpty) return null;
      return int.tryParse(json);
    }
    throw FormatException('Invalid int format: $json');
  }

  @override
  dynamic toJson(int? object) => object;
}

@freezed
class Car with _$Car {
  const factory Car({
    int? id,
    String? title,
    String? description,
    @JsonKey(name: 'cover_image') String? coverImage,
    @JsonKey(fromJson: imageUrlsFromJson) List<String>? images,
    String? video,
    int? year,
    String? transmission,
    @JsonKey(name: 'fuel_type') String? fuelType,
    String? drivetrain,
    int? horsepower,
    int? doors,
    int? seats,
    @JsonKey(name: 'mileage_km') @StringConverter() String? mileageKm,
    double? price,
    @JsonKey(name: 'down_payment') @IntConverter() int? downPayment,
    String? condition,
    CarCategory? category,
    CarBrand? brand,
    BrandModel? brandModel,
    CarBodyType? bodyType,
    @JsonKey(name: 'vendor') Dealer? dealer,
    List<CarColor>? colors,
    @JsonKey(name: 'is_active') bool? isActive,
  }) = _Car;

  factory Car.fromJson(Map<String, dynamic> json) => _$CarFromJson(json);
}

List<String> imageUrlsFromJson(dynamic json) {
  if (json is List) {
    return json
        .map((e) => e['image_url'] as String?)
        .whereType<String>()
        .where((url) => HelperFunctions().isValidImageUrl(url))
        .toList();
  }
  return [];
}
