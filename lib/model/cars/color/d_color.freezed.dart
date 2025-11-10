// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'd_color.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DColor _$DColorFromJson(Map<String, dynamic> json) {
  return _DColor.fromJson(json);
}

/// @nodoc
mixin _$DColor {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'color_code')
  String? get colorCode => throw _privateConstructorUsedError;

  /// Serializes this DColor to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DColor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DColorCopyWith<DColor> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DColorCopyWith<$Res> {
  factory $DColorCopyWith(DColor value, $Res Function(DColor) then) =
      _$DColorCopyWithImpl<$Res, DColor>;
  @useResult
  $Res call(
      {int? id, String? name, @JsonKey(name: 'color_code') String? colorCode});
}

/// @nodoc
class _$DColorCopyWithImpl<$Res, $Val extends DColor>
    implements $DColorCopyWith<$Res> {
  _$DColorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DColor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? colorCode = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      colorCode: freezed == colorCode
          ? _value.colorCode
          : colorCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DColorImplCopyWith<$Res> implements $DColorCopyWith<$Res> {
  factory _$$DColorImplCopyWith(
          _$DColorImpl value, $Res Function(_$DColorImpl) then) =
      __$$DColorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id, String? name, @JsonKey(name: 'color_code') String? colorCode});
}

/// @nodoc
class __$$DColorImplCopyWithImpl<$Res>
    extends _$DColorCopyWithImpl<$Res, _$DColorImpl>
    implements _$$DColorImplCopyWith<$Res> {
  __$$DColorImplCopyWithImpl(
      _$DColorImpl _value, $Res Function(_$DColorImpl) _then)
      : super(_value, _then);

  /// Create a copy of DColor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? colorCode = freezed,
  }) {
    return _then(_$DColorImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      colorCode: freezed == colorCode
          ? _value.colorCode
          : colorCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DColorImpl implements _DColor {
  const _$DColorImpl(
      {this.id, this.name, @JsonKey(name: 'color_code') this.colorCode});

  factory _$DColorImpl.fromJson(Map<String, dynamic> json) =>
      _$$DColorImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  @JsonKey(name: 'color_code')
  final String? colorCode;

  @override
  String toString() {
    return 'DColor(id: $id, name: $name, colorCode: $colorCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DColorImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.colorCode, colorCode) ||
                other.colorCode == colorCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, colorCode);

  /// Create a copy of DColor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DColorImplCopyWith<_$DColorImpl> get copyWith =>
      __$$DColorImplCopyWithImpl<_$DColorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DColorImplToJson(
      this,
    );
  }
}

abstract class _DColor implements DColor {
  const factory _DColor(
      {final int? id,
      final String? name,
      @JsonKey(name: 'color_code') final String? colorCode}) = _$DColorImpl;

  factory _DColor.fromJson(Map<String, dynamic> json) = _$DColorImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  @JsonKey(name: 'color_code')
  String? get colorCode;

  /// Create a copy of DColor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DColorImplCopyWith<_$DColorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
