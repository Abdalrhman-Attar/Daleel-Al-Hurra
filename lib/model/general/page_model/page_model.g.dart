// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PageModelImpl _$$PageModelImplFromJson(Map<String, dynamic> json) =>
    _$PageModelImpl(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      content: json['content'] as String?,
      slug: json['slug'] as String?,
      image: json['image'] as String?,
      isActive: json['is_active'] as bool?,
    );

Map<String, dynamic> _$$PageModelImplToJson(_$PageModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'slug': instance.slug,
      'image': instance.image,
      'is_active': instance.isActive,
    };
