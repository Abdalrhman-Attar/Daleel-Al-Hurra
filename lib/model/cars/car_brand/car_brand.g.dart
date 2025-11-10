// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_brand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CarBrandImpl _$$CarBrandImplFromJson(Map<String, dynamic> json) =>
    _$CarBrandImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      imageUrl: json['image_url'] as String?,
    );

Map<String, dynamic> _$$CarBrandImplToJson(_$CarBrandImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image_url': instance.imageUrl,
    };
