import 'package:freezed_annotation/freezed_annotation.dart';

part 'car_category.freezed.dart';
part 'car_category.g.dart';

@freezed
class CarCategory with _$CarCategory {
  const factory CarCategory({
    int? id,
    String? name,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'is_featured') bool? isFeatured,
    @JsonKey(name: 'is_active') bool? isActive,
  }) = _CarCategory;

  factory CarCategory.fromJson(Map<String, dynamic> json) =>
      _$CarCategoryFromJson(json);
}
