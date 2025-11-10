import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../utils/helpers/helper_functions.dart';
import '../color/d_color.dart';

part 'car_color.freezed.dart';
part 'car_color.g.dart';

@freezed
class CarColor with _$CarColor {
  const factory CarColor({
    int? id,
    DColor? color,
    String? type,
    @JsonKey(fromJson: imageUrlsFromJson) List<String>? images,
  }) = _CarColor;

  factory CarColor.fromJson(Map<String, dynamic> json) =>
      _$CarColorFromJson(json);
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
