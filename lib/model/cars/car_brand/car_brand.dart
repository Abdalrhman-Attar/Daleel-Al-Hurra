import 'package:freezed_annotation/freezed_annotation.dart';

part 'car_brand.freezed.dart';
part 'car_brand.g.dart';

@freezed
class CarBrand with _$CarBrand {
  const factory CarBrand({
    int? id,
    String? name,
    @JsonKey(name: 'image_url') String? imageUrl,
  }) = _CarBrand;

  factory CarBrand.fromJson(Map<String, dynamic> json) =>
      _$CarBrandFromJson(json);
}
