// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dealer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Dealer _$DealerFromJson(Map<String, dynamic> json) {
  return _Dealer.fromJson(json);
}

/// @nodoc
mixin _$Dealer {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String? get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String? get lastName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'email_verified_at')
  String? get emailVerifiedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone_number')
  String? get phoneNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone_number_verified')
  bool? get phoneNumberVerified => throw _privateConstructorUsedError;
  String? get logo => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_name')
  String? get storeName => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get latitude => throw _privateConstructorUsedError;
  String? get longitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_type')
  int? get userType => throw _privateConstructorUsedError;
  @JsonKey(name: 'commercial_register_image')
  String? get commercialRegisterImage => throw _privateConstructorUsedError;
  List<CarBrand>? get brands => throw _privateConstructorUsedError;

  /// Serializes this Dealer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Dealer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DealerCopyWith<Dealer> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DealerCopyWith<$Res> {
  factory $DealerCopyWith(Dealer value, $Res Function(Dealer) then) =
      _$DealerCopyWithImpl<$Res, Dealer>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      String? email,
      @JsonKey(name: 'email_verified_at') String? emailVerifiedAt,
      @JsonKey(name: 'phone_number') String? phoneNumber,
      @JsonKey(name: 'phone_number_verified') bool? phoneNumberVerified,
      String? logo,
      @JsonKey(name: 'store_name') String? storeName,
      String? address,
      String? latitude,
      String? longitude,
      @JsonKey(name: 'user_type') int? userType,
      @JsonKey(name: 'commercial_register_image')
      String? commercialRegisterImage,
      List<CarBrand>? brands});
}

/// @nodoc
class _$DealerCopyWithImpl<$Res, $Val extends Dealer>
    implements $DealerCopyWith<$Res> {
  _$DealerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Dealer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = freezed,
    Object? emailVerifiedAt = freezed,
    Object? phoneNumber = freezed,
    Object? phoneNumberVerified = freezed,
    Object? logo = freezed,
    Object? storeName = freezed,
    Object? address = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? userType = freezed,
    Object? commercialRegisterImage = freezed,
    Object? brands = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      emailVerifiedAt: freezed == emailVerifiedAt
          ? _value.emailVerifiedAt
          : emailVerifiedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumberVerified: freezed == phoneNumberVerified
          ? _value.phoneNumberVerified
          : phoneNumberVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      logo: freezed == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String?,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as String?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as String?,
      userType: freezed == userType
          ? _value.userType
          : userType // ignore: cast_nullable_to_non_nullable
              as int?,
      commercialRegisterImage: freezed == commercialRegisterImage
          ? _value.commercialRegisterImage
          : commercialRegisterImage // ignore: cast_nullable_to_non_nullable
              as String?,
      brands: freezed == brands
          ? _value.brands
          : brands // ignore: cast_nullable_to_non_nullable
              as List<CarBrand>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DealerImplCopyWith<$Res> implements $DealerCopyWith<$Res> {
  factory _$$DealerImplCopyWith(
          _$DealerImpl value, $Res Function(_$DealerImpl) then) =
      __$$DealerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      String? email,
      @JsonKey(name: 'email_verified_at') String? emailVerifiedAt,
      @JsonKey(name: 'phone_number') String? phoneNumber,
      @JsonKey(name: 'phone_number_verified') bool? phoneNumberVerified,
      String? logo,
      @JsonKey(name: 'store_name') String? storeName,
      String? address,
      String? latitude,
      String? longitude,
      @JsonKey(name: 'user_type') int? userType,
      @JsonKey(name: 'commercial_register_image')
      String? commercialRegisterImage,
      List<CarBrand>? brands});
}

/// @nodoc
class __$$DealerImplCopyWithImpl<$Res>
    extends _$DealerCopyWithImpl<$Res, _$DealerImpl>
    implements _$$DealerImplCopyWith<$Res> {
  __$$DealerImplCopyWithImpl(
      _$DealerImpl _value, $Res Function(_$DealerImpl) _then)
      : super(_value, _then);

  /// Create a copy of Dealer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = freezed,
    Object? emailVerifiedAt = freezed,
    Object? phoneNumber = freezed,
    Object? phoneNumberVerified = freezed,
    Object? logo = freezed,
    Object? storeName = freezed,
    Object? address = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? userType = freezed,
    Object? commercialRegisterImage = freezed,
    Object? brands = freezed,
  }) {
    return _then(_$DealerImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      emailVerifiedAt: freezed == emailVerifiedAt
          ? _value.emailVerifiedAt
          : emailVerifiedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumberVerified: freezed == phoneNumberVerified
          ? _value.phoneNumberVerified
          : phoneNumberVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      logo: freezed == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String?,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as String?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as String?,
      userType: freezed == userType
          ? _value.userType
          : userType // ignore: cast_nullable_to_non_nullable
              as int?,
      commercialRegisterImage: freezed == commercialRegisterImage
          ? _value.commercialRegisterImage
          : commercialRegisterImage // ignore: cast_nullable_to_non_nullable
              as String?,
      brands: freezed == brands
          ? _value._brands
          : brands // ignore: cast_nullable_to_non_nullable
              as List<CarBrand>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DealerImpl implements _Dealer {
  const _$DealerImpl(
      {this.id,
      @JsonKey(name: 'first_name') this.firstName,
      @JsonKey(name: 'last_name') this.lastName,
      this.email,
      @JsonKey(name: 'email_verified_at') this.emailVerifiedAt,
      @JsonKey(name: 'phone_number') this.phoneNumber,
      @JsonKey(name: 'phone_number_verified') this.phoneNumberVerified,
      this.logo,
      @JsonKey(name: 'store_name') this.storeName,
      this.address,
      this.latitude,
      this.longitude,
      @JsonKey(name: 'user_type') this.userType,
      @JsonKey(name: 'commercial_register_image') this.commercialRegisterImage,
      final List<CarBrand>? brands})
      : _brands = brands;

  factory _$DealerImpl.fromJson(Map<String, dynamic> json) =>
      _$$DealerImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'first_name')
  final String? firstName;
  @override
  @JsonKey(name: 'last_name')
  final String? lastName;
  @override
  final String? email;
  @override
  @JsonKey(name: 'email_verified_at')
  final String? emailVerifiedAt;
  @override
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @override
  @JsonKey(name: 'phone_number_verified')
  final bool? phoneNumberVerified;
  @override
  final String? logo;
  @override
  @JsonKey(name: 'store_name')
  final String? storeName;
  @override
  final String? address;
  @override
  final String? latitude;
  @override
  final String? longitude;
  @override
  @JsonKey(name: 'user_type')
  final int? userType;
  @override
  @JsonKey(name: 'commercial_register_image')
  final String? commercialRegisterImage;
  final List<CarBrand>? _brands;
  @override
  List<CarBrand>? get brands {
    final value = _brands;
    if (value == null) return null;
    if (_brands is EqualUnmodifiableListView) return _brands;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Dealer(id: $id, firstName: $firstName, lastName: $lastName, email: $email, emailVerifiedAt: $emailVerifiedAt, phoneNumber: $phoneNumber, phoneNumberVerified: $phoneNumberVerified, logo: $logo, storeName: $storeName, address: $address, latitude: $latitude, longitude: $longitude, userType: $userType, commercialRegisterImage: $commercialRegisterImage, brands: $brands)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DealerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.emailVerifiedAt, emailVerifiedAt) ||
                other.emailVerifiedAt == emailVerifiedAt) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.phoneNumberVerified, phoneNumberVerified) ||
                other.phoneNumberVerified == phoneNumberVerified) &&
            (identical(other.logo, logo) || other.logo == logo) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.userType, userType) ||
                other.userType == userType) &&
            (identical(
                    other.commercialRegisterImage, commercialRegisterImage) ||
                other.commercialRegisterImage == commercialRegisterImage) &&
            const DeepCollectionEquality().equals(other._brands, _brands));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      firstName,
      lastName,
      email,
      emailVerifiedAt,
      phoneNumber,
      phoneNumberVerified,
      logo,
      storeName,
      address,
      latitude,
      longitude,
      userType,
      commercialRegisterImage,
      const DeepCollectionEquality().hash(_brands));

  /// Create a copy of Dealer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DealerImplCopyWith<_$DealerImpl> get copyWith =>
      __$$DealerImplCopyWithImpl<_$DealerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DealerImplToJson(
      this,
    );
  }
}

abstract class _Dealer implements Dealer {
  const factory _Dealer(
      {final int? id,
      @JsonKey(name: 'first_name') final String? firstName,
      @JsonKey(name: 'last_name') final String? lastName,
      final String? email,
      @JsonKey(name: 'email_verified_at') final String? emailVerifiedAt,
      @JsonKey(name: 'phone_number') final String? phoneNumber,
      @JsonKey(name: 'phone_number_verified') final bool? phoneNumberVerified,
      final String? logo,
      @JsonKey(name: 'store_name') final String? storeName,
      final String? address,
      final String? latitude,
      final String? longitude,
      @JsonKey(name: 'user_type') final int? userType,
      @JsonKey(name: 'commercial_register_image')
      final String? commercialRegisterImage,
      final List<CarBrand>? brands}) = _$DealerImpl;

  factory _Dealer.fromJson(Map<String, dynamic> json) = _$DealerImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'first_name')
  String? get firstName;
  @override
  @JsonKey(name: 'last_name')
  String? get lastName;
  @override
  String? get email;
  @override
  @JsonKey(name: 'email_verified_at')
  String? get emailVerifiedAt;
  @override
  @JsonKey(name: 'phone_number')
  String? get phoneNumber;
  @override
  @JsonKey(name: 'phone_number_verified')
  bool? get phoneNumberVerified;
  @override
  String? get logo;
  @override
  @JsonKey(name: 'store_name')
  String? get storeName;
  @override
  String? get address;
  @override
  String? get latitude;
  @override
  String? get longitude;
  @override
  @JsonKey(name: 'user_type')
  int? get userType;
  @override
  @JsonKey(name: 'commercial_register_image')
  String? get commercialRegisterImage;
  @override
  List<CarBrand>? get brands;

  /// Create a copy of Dealer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DealerImplCopyWith<_$DealerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
