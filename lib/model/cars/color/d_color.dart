import 'package:freezed_annotation/freezed_annotation.dart';

part 'd_color.freezed.dart';
part 'd_color.g.dart';

@freezed
class DColor with _$DColor {
  const factory DColor({
    int? id,
    String? name,
    @JsonKey(name: 'color_code') String? colorCode,
  }) = _DColor;

  factory DColor.fromJson(Map<String, dynamic> json) => _$DColorFromJson(json);
}
