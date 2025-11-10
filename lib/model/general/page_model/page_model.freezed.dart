// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PageModel _$PageModelFromJson(Map<String, dynamic> json) {
  return _PageModel.fromJson(json);
}

/// @nodoc
mixin _$PageModel {
  int? get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  String? get slug => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool? get isActive => throw _privateConstructorUsedError;

  /// Serializes this PageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PageModelCopyWith<PageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PageModelCopyWith<$Res> {
  factory $PageModelCopyWith(PageModel value, $Res Function(PageModel) then) =
      _$PageModelCopyWithImpl<$Res, PageModel>;
  @useResult
  $Res call(
      {int? id,
      String? title,
      String? content,
      String? slug,
      String? image,
      @JsonKey(name: 'is_active') bool? isActive});
}

/// @nodoc
class _$PageModelCopyWithImpl<$Res, $Val extends PageModel>
    implements $PageModelCopyWith<$Res> {
  _$PageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? content = freezed,
    Object? slug = freezed,
    Object? image = freezed,
    Object? isActive = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PageModelImplCopyWith<$Res>
    implements $PageModelCopyWith<$Res> {
  factory _$$PageModelImplCopyWith(
          _$PageModelImpl value, $Res Function(_$PageModelImpl) then) =
      __$$PageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? title,
      String? content,
      String? slug,
      String? image,
      @JsonKey(name: 'is_active') bool? isActive});
}

/// @nodoc
class __$$PageModelImplCopyWithImpl<$Res>
    extends _$PageModelCopyWithImpl<$Res, _$PageModelImpl>
    implements _$$PageModelImplCopyWith<$Res> {
  __$$PageModelImplCopyWithImpl(
      _$PageModelImpl _value, $Res Function(_$PageModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? content = freezed,
    Object? slug = freezed,
    Object? image = freezed,
    Object? isActive = freezed,
  }) {
    return _then(_$PageModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PageModelImpl implements _PageModel {
  const _$PageModelImpl(
      {this.id,
      this.title,
      this.content,
      this.slug,
      this.image,
      @JsonKey(name: 'is_active') this.isActive});

  factory _$PageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PageModelImplFromJson(json);

  @override
  final int? id;
  @override
  final String? title;
  @override
  final String? content;
  @override
  final String? slug;
  @override
  final String? image;
  @override
  @JsonKey(name: 'is_active')
  final bool? isActive;

  @override
  String toString() {
    return 'PageModel(id: $id, title: $title, content: $content, slug: $slug, image: $image, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, content, slug, image, isActive);

  /// Create a copy of PageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PageModelImplCopyWith<_$PageModelImpl> get copyWith =>
      __$$PageModelImplCopyWithImpl<_$PageModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PageModelImplToJson(
      this,
    );
  }
}

abstract class _PageModel implements PageModel {
  const factory _PageModel(
      {final int? id,
      final String? title,
      final String? content,
      final String? slug,
      final String? image,
      @JsonKey(name: 'is_active') final bool? isActive}) = _$PageModelImpl;

  factory _PageModel.fromJson(Map<String, dynamic> json) =
      _$PageModelImpl.fromJson;

  @override
  int? get id;
  @override
  String? get title;
  @override
  String? get content;
  @override
  String? get slug;
  @override
  String? get image;
  @override
  @JsonKey(name: 'is_active')
  bool? get isActive;

  /// Create a copy of PageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PageModelImplCopyWith<_$PageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
