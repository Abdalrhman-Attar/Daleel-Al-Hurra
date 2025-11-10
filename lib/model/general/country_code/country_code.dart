import 'package:freezed_annotation/freezed_annotation.dart';

part 'country_code.freezed.dart';
part 'country_code.g.dart';

@freezed
class CountryCode with _$CountryCode {
  const factory CountryCode({
    String? name,
    String? code,
    String? flag,
    String? dialCode,
  }) = _CountryCode;

  factory CountryCode.fromJson(Map<String, dynamic> json) =>
      _$CountryCodeFromJson(json);
}
