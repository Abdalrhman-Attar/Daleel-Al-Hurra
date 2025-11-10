// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'car_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CarCategory _$CarCategoryFromJson(Map<String, dynamic> json) {
  return _CarCategory.fromJson(json);
}

/// @nodoc
mixin _$CarCategory {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_featured')
  bool? get isFeatured => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool? get isActive => throw _privateConstructorUsedError;

  /// Serializes this CarCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CarCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CarCategoryCopyWith<CarCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CarCategoryCopyWith<$Res> {
  factory $CarCategoryCopyWith(
          CarCategory value, $Res Function(CarCategory) then) =
      _$CarCategoryCopyWithImpl<$Res, CarCategory>;
  @useResult
  $Res call(
      {int? id,
      String? name,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'is_featured') bool? isFeatured,
      @JsonKey(name: 'is_active') bool? isActive});
}

/// @nodoc
class _$CarCategoryCopyWithImpl<$Res, $Val extends CarCategory>
    implements $CarCategoryCopyWith<$Res> {
  _$CarCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CarCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? imageUrl = freezed,
    Object? isFeatured = freezed,
    Object? isActive = freezed,
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
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isFeatured: freezed == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CarCategoryImplCopyWith<$Res>
    implements $CarCategoryCopyWith<$Res> {
  factory _$$CarCategoryImplCopyWith(
          _$CarCategoryImpl value, $Res Function(_$CarCategoryImpl) then) =
      __$$CarCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? name,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'is_featured') bool? isFeatured,
      @JsonKey(name: 'is_active') bool? isActive});
}

/// @nodoc
class __$$CarCategoryImplCopyWithImpl<$Res>
    extends _$CarCategoryCopyWithImpl<$Res, _$CarCategoryImpl>
    implements _$$CarCategoryImplCopyWith<$Res> {
  __$$CarCategoryImplCopyWithImpl(
      _$CarCategoryImpl _value, $Res Function(_$CarCategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of CarCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? imageUrl = freezed,
    Object? isFeatured = freezed,
    Object? isActive = freezed,
  }) {
    return _then(_$CarCategoryImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isFeatured: freezed == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CarCategoryImpl implements _CarCategory {
  const _$CarCategoryImpl(
      {this.id,
      this.name,
      @JsonKey(name: 'image_url') this.imageUrl,
      @JsonKey(name: 'is_featured') this.isFeatured,
      @JsonKey(name: 'is_active') this.isActive});

  factory _$CarCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CarCategoryImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @JsonKey(name: 'is_featured')
  final bool? isFeatured;
  @override
  @JsonKey(name: 'is_active')
  final bool? isActive;

  @override
  String toString() {
    return 'CarCategory(id: $id, name: $name, imageUrl: $imageUrl, isFeatured: $isFeatured, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CarCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, imageUrl, isFeatured, isActive);

  /// Create a copy of CarCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CarCategoryImplCopyWith<_$CarCategoryImpl> get copyWith =>
      __$$CarCategoryImplCopyWithImpl<_$CarCategoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CarCategoryImplToJson(
      this,
    );
  }
}

abstract class _CarCategory implements CarCategory {
  const factory _CarCategory(
      {final int? id,
      final String? name,
      @JsonKey(name: 'image_url') final String? imageUrl,
      @JsonKey(name: 'is_featured') final bool? isFeatured,
      @JsonKey(name: 'is_active') final bool? isActive}) = _$CarCategoryImpl;

  factory _CarCategory.fromJson(Map<String, dynamic> json) =
      _$CarCategoryImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  @JsonKey(name: 'is_featured')
  bool? get isFeatured;
  @override
  @JsonKey(name: 'is_active')
  bool? get isActive;

  /// Create a copy of CarCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CarCategoryImplCopyWith<_$CarCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
