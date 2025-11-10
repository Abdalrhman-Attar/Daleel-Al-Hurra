// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginImpl _$$LoginImplFromJson(Map<String, dynamic> json) => _$LoginImpl(
      token: json['token'] as String?,
      loginType: json['login_by'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$LoginImplToJson(_$LoginImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'login_by': instance.loginType,
      'user': instance.user,
    };
