// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_color.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CarColorImpl _$$CarColorImplFromJson(Map<String, dynamic> json) =>
    _$CarColorImpl(
      id: (json['id'] as num?)?.toInt(),
      color: json['color'] == null
          ? null
          : DColor.fromJson(json['color'] as Map<String, dynamic>),
      type: json['type'] as String?,
      images: imageUrlsFromJson(json['images']),
    );

Map<String, dynamic> _$$CarColorImplToJson(_$CarColorImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'color': instance.color,
      'type': instance.type,
      'images': instance.images,
    };
