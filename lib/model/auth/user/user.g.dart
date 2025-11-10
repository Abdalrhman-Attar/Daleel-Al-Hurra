// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: (json['id'] as num?)?.toInt(),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      phoneNumberVerified: json['phone_number_verified'] as bool?,
      logo: json['logo'] as String?,
      storeName: json['store_name'] as String?,
      address: json['address'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      userType: (json['user_type'] as num?)?.toInt(),
      status: json['status'] as bool?,
      brands: (json['brands'] as List<dynamic>?)
          ?.map((e) => CarBrand.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'phone_number': instance.phoneNumber,
      'phone_number_verified': instance.phoneNumberVerified,
      'logo': instance.logo,
      'store_name': instance.storeName,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'user_type': instance.userType,
      'status': instance.status,
      'brands': instance.brands,
    };
