// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CarCategoryImpl _$$CarCategoryImplFromJson(Map<String, dynamic> json) =>
    _$CarCategoryImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      imageUrl: json['image_url'] as String?,
      isFeatured: json['is_featured'] as bool?,
      isActive: json['is_active'] as bool?,
    );

Map<String, dynamic> _$$CarCategoryImplToJson(_$CarCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image_url': instance.imageUrl,
      'is_featured': instance.isFeatured,
      'is_active': instance.isActive,
    };
