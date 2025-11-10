import 'package:freezed_annotation/freezed_annotation.dart';

part 'language.freezed.dart';
part 'language.g.dart';

@freezed
class Language with _$Language {
  const factory Language({
    int? id,
    String? name,
    String? locale,
    String? direction,
    String? flag,
    @JsonKey(name: 'is_default') bool? isDefault,
    @JsonKey(name: 'is_active') bool? isActive,
  }) = _Language;

  factory Language.fromJson(Map<String, dynamic> json) =>
      _$LanguageFromJson(json);
}
