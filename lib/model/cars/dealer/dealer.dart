import 'package:freezed_annotation/freezed_annotation.dart';

import '../car_brand/car_brand.dart';

part 'dealer.freezed.dart';
part 'dealer.g.dart';

@freezed
class Dealer with _$Dealer {
  const factory Dealer({
    int? id,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    String? email,
    @JsonKey(name: 'email_verified_at') String? emailVerifiedAt,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'phone_number_verified') bool? phoneNumberVerified,
    String? logo,
    @JsonKey(name: 'store_name') String? storeName,
    String? address,
    String? latitude,
    String? longitude,
    @JsonKey(name: 'user_type') int? userType,
    @JsonKey(name: 'commercial_register_image') String? commercialRegisterImage,
    List<CarBrand>? brands,
  }) = _Dealer;

  factory Dealer.fromJson(Map<String, dynamic> json) => _$DealerFromJson(json);
}
