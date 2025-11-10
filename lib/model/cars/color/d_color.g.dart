// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'd_color.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DColorImpl _$$DColorImplFromJson(Map<String, dynamic> json) => _$DColorImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      colorCode: json['color_code'] as String?,
    );

Map<String, dynamic> _$$DColorImplToJson(_$DColorImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color_code': instance.colorCode,
    };
