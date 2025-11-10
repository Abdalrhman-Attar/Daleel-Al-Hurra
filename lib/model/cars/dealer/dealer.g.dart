// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dealer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DealerImpl _$$DealerImplFromJson(Map<String, dynamic> json) => _$DealerImpl(
      id: (json['id'] as num?)?.toInt(),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      emailVerifiedAt: json['email_verified_at'] as String?,
      phoneNumber: json['phone_number'] as String?,
      phoneNumberVerified: json['phone_number_verified'] as bool?,
      logo: json['logo'] as String?,
      storeName: json['store_name'] as String?,
      address: json['address'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      userType: (json['user_type'] as num?)?.toInt(),
      commercialRegisterImage: json['commercial_register_image'] as String?,
      brands: (json['brands'] as List<dynamic>?)
          ?.map((e) => CarBrand.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$DealerImplToJson(_$DealerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'email_verified_at': instance.emailVerifiedAt,
      'phone_number': instance.phoneNumber,
      'phone_number_verified': instance.phoneNumberVerified,
      'logo': instance.logo,
      'store_name': instance.storeName,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'user_type': instance.userType,
      'commercial_register_image': instance.commercialRegisterImage,
      'brands': instance.brands,
    };
