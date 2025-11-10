// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'car_color.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CarColor _$CarColorFromJson(Map<String, dynamic> json) {
  return _CarColor.fromJson(json);
}

/// @nodoc
mixin _$CarColor {
  int? get id => throw _privateConstructorUsedError;
  DColor? get color => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  @JsonKey(fromJson: imageUrlsFromJson)
  List<String>? get images => throw _privateConstructorUsedError;

  /// Serializes this CarColor to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CarColor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CarColorCopyWith<CarColor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CarColorCopyWith<$Res> {
  factory $CarColorCopyWith(CarColor value, $Res Function(CarColor) then) =
      _$CarColorCopyWithImpl<$Res, CarColor>;
  @useResult
  $Res call(
      {int? id,
      DColor? color,
      String? type,
      @JsonKey(fromJson: imageUrlsFromJson) List<String>? images});

  $DColorCopyWith<$Res>? get color;
}

/// @nodoc
class _$CarColorCopyWithImpl<$Res, $Val extends CarColor>
    implements $CarColorCopyWith<$Res> {
  _$CarColorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CarColor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? color = freezed,
    Object? type = freezed,
    Object? images = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as DColor?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }

  /// Create a copy of CarColor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DColorCopyWith<$Res>? get color {
    if (_value.color == null) {
      return null;
    }

    return $DColorCopyWith<$Res>(_value.color!, (value) {
      return _then(_value.copyWith(color: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CarColorImplCopyWith<$Res>
    implements $CarColorCopyWith<$Res> {
  factory _$$CarColorImplCopyWith(
          _$CarColorImpl value, $Res Function(_$CarColorImpl) then) =
      __$$CarColorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      DColor? color,
      String? type,
      @JsonKey(fromJson: imageUrlsFromJson) List<String>? images});

  @override
  $DColorCopyWith<$Res>? get color;
}

/// @nodoc
class __$$CarColorImplCopyWithImpl<$Res>
    extends _$CarColorCopyWithImpl<$Res, _$CarColorImpl>
    implements _$$CarColorImplCopyWith<$Res> {
  __$$CarColorImplCopyWithImpl(
      _$CarColorImpl _value, $Res Function(_$CarColorImpl) _then)
      : super(_value, _then);

  /// Create a copy of CarColor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? color = freezed,
    Object? type = freezed,
    Object? images = freezed,
  }) {
    return _then(_$CarColorImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as DColor?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CarColorImpl implements _CarColor {
  const _$CarColorImpl(
      {this.id,
      this.color,
      this.type,
      @JsonKey(fromJson: imageUrlsFromJson) final List<String>? images})
      : _images = images;

  factory _$CarColorImpl.fromJson(Map<String, dynamic> json) =>
      _$$CarColorImplFromJson(json);

  @override
  final int? id;
  @override
  final DColor? color;
  @override
  final String? type;
  final List<String>? _images;
  @override
  @JsonKey(fromJson: imageUrlsFromJson)
  List<String>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CarColor(id: $id, color: $color, type: $type, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CarColorImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._images, _images));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, color, type,
      const DeepCollectionEquality().hash(_images));

  /// Create a copy of CarColor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CarColorImplCopyWith<_$CarColorImpl> get copyWith =>
      __$$CarColorImplCopyWithImpl<_$CarColorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CarColorImplToJson(
      this,
    );
  }
}

abstract class _CarColor implements CarColor {
  const factory _CarColor(
          {final int? id,
          final DColor? color,
          final String? type,
          @JsonKey(fromJson: imageUrlsFromJson) final List<String>? images}) =
      _$CarColorImpl;

  factory _CarColor.fromJson(Map<String, dynamic> json) =
      _$CarColorImpl.fromJson;

  @override
  int? get id;
  @override
  DColor? get color;
  @override
  String? get type;
  @override
  @JsonKey(fromJson: imageUrlsFromJson)
  List<String>? get images;

  /// Create a copy of CarColor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CarColorImplCopyWith<_$CarColorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
