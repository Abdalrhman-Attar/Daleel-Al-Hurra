// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LanguageImpl _$$LanguageImplFromJson(Map<String, dynamic> json) =>
    _$LanguageImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      locale: json['locale'] as String?,
      direction: json['direction'] as String?,
      flag: json['flag'] as String?,
      isDefault: json['is_default'] as bool?,
      isActive: json['is_active'] as bool?,
    );

Map<String, dynamic> _$$LanguageImplToJson(_$LanguageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'locale': instance.locale,
      'direction': instance.direction,
      'flag': instance.flag,
      'is_default': instance.isDefault,
      'is_active': instance.isActive,
    };
