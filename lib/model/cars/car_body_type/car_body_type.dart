import 'package:freezed_annotation/freezed_annotation.dart';

part 'car_body_type.freezed.dart';
part 'car_body_type.g.dart';

@freezed
class CarBodyType with _$CarBodyType {
  const factory CarBodyType({
    int? id,
    String? name,
  }) = _CarBodyType;

  factory CarBodyType.fromJson(Map<String, dynamic> json) =>
      _$CarBodyTypeFromJson(json);
}
