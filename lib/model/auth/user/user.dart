import 'package:freezed_annotation/freezed_annotation.dart';

import '../../cars/car_brand/car_brand.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    int? id,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'phone_number_verified') bool? phoneNumberVerified,
    String? logo,
    @JsonKey(name: 'store_name') String? storeName,
    String? address,
    String? latitude,
    String? longitude,
    @JsonKey(name: 'user_type') int? userType,
    bool? status,
    List<CarBrand>? brands,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
