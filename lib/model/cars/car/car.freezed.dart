// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'car.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Car _$CarFromJson(Map<String, dynamic> json) {
  return _Car.fromJson(json);
}

/// @nodoc
mixin _$Car {
  int? get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'cover_image')
  String? get coverImage => throw _privateConstructorUsedError;
  @JsonKey(fromJson: imageUrlsFromJson)
  List<String>? get images => throw _privateConstructorUsedError;
  String? get video => throw _privateConstructorUsedError;
  int? get year => throw _privateConstructorUsedError;
  String? get transmission => throw _privateConstructorUsedError;
  @JsonKey(name: 'fuel_type')
  String? get fuelType => throw _privateConstructorUsedError;
  String? get drivetrain => throw _privateConstructorUsedError;
  int? get horsepower => throw _privateConstructorUsedError;
  int? get doors => throw _privateConstructorUsedError;
  int? get seats => throw _privateConstructorUsedError;
  @JsonKey(name: 'mileage_km')
  @StringConverter()
  String? get mileageKm => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'down_payment')
  @IntConverter()
  int? get downPayment => throw _privateConstructorUsedError;
  String? get condition => throw _privateConstructorUsedError;
  CarCategory? get category => throw _privateConstructorUsedError;
  CarBrand? get brand => throw _privateConstructorUsedError;
  BrandModel? get brandModel => throw _privateConstructorUsedError;
  CarBodyType? get bodyType => throw _privateConstructorUsedError;
  @JsonKey(name: 'vendor')
  Dealer? get dealer => throw _privateConstructorUsedError;
  List<CarColor>? get colors => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool? get isActive => throw _privateConstructorUsedError;

  /// Serializes this Car to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Car
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CarCopyWith<Car> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CarCopyWith<$Res> {
  factory $CarCopyWith(Car value, $Res Function(Car) then) =
      _$CarCopyWithImpl<$Res, Car>;
  @useResult
  $Res call(
      {int? id,
      String? title,
      String? description,
      @JsonKey(name: 'cover_image') String? coverImage,
      @JsonKey(fromJson: imageUrlsFromJson) List<String>? images,
      String? video,
      int? year,
      String? transmission,
      @JsonKey(name: 'fuel_type') String? fuelType,
      String? drivetrain,
      int? horsepower,
      int? doors,
      int? seats,
      @JsonKey(name: 'mileage_km') @StringConverter() String? mileageKm,
      double? price,
      @JsonKey(name: 'down_payment') @IntConverter() int? downPayment,
      String? condition,
      CarCategory? category,
      CarBrand? brand,
      BrandModel? brandModel,
      CarBodyType? bodyType,
      @JsonKey(name: 'vendor') Dealer? dealer,
      List<CarColor>? colors,
      @JsonKey(name: 'is_active') bool? isActive});

  $CarCategoryCopyWith<$Res>? get category;
  $CarBrandCopyWith<$Res>? get brand;
  $BrandModelCopyWith<$Res>? get brandModel;
  $CarBodyTypeCopyWith<$Res>? get bodyType;
  $DealerCopyWith<$Res>? get dealer;
}

/// @nodoc
class _$CarCopyWithImpl<$Res, $Val extends Car> implements $CarCopyWith<$Res> {
  _$CarCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Car
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? coverImage = freezed,
    Object? images = freezed,
    Object? video = freezed,
    Object? year = freezed,
    Object? transmission = freezed,
    Object? fuelType = freezed,
    Object? drivetrain = freezed,
    Object? horsepower = freezed,
    Object? doors = freezed,
    Object? seats = freezed,
    Object? mileageKm = freezed,
    Object? price = freezed,
    Object? downPayment = freezed,
    Object? condition = freezed,
    Object? category = freezed,
    Object? brand = freezed,
    Object? brandModel = freezed,
    Object? bodyType = freezed,
    Object? dealer = freezed,
    Object? colors = freezed,
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImage: freezed == coverImage
          ? _value.coverImage
          : coverImage // ignore: cast_nullable_to_non_nullable
              as String?,
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      video: freezed == video
          ? _value.video
          : video // ignore: cast_nullable_to_non_nullable
              as String?,
      year: freezed == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int?,
      transmission: freezed == transmission
          ? _value.transmission
          : transmission // ignore: cast_nullable_to_non_nullable
              as String?,
      fuelType: freezed == fuelType
          ? _value.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String?,
      drivetrain: freezed == drivetrain
          ? _value.drivetrain
          : drivetrain // ignore: cast_nullable_to_non_nullable
              as String?,
      horsepower: freezed == horsepower
          ? _value.horsepower
          : horsepower // ignore: cast_nullable_to_non_nullable
              as int?,
      doors: freezed == doors
          ? _value.doors
          : doors // ignore: cast_nullable_to_non_nullable
              as int?,
      seats: freezed == seats
          ? _value.seats
          : seats // ignore: cast_nullable_to_non_nullable
              as int?,
      mileageKm: freezed == mileageKm
          ? _value.mileageKm
          : mileageKm // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      downPayment: freezed == downPayment
          ? _value.downPayment
          : downPayment // ignore: cast_nullable_to_non_nullable
              as int?,
      condition: freezed == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as CarCategory?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as CarBrand?,
      brandModel: freezed == brandModel
          ? _value.brandModel
          : brandModel // ignore: cast_nullable_to_non_nullable
              as BrandModel?,
      bodyType: freezed == bodyType
          ? _value.bodyType
          : bodyType // ignore: cast_nullable_to_non_nullable
              as CarBodyType?,
      dealer: freezed == dealer
          ? _value.dealer
          : dealer // ignore: cast_nullable_to_non_nullable
              as Dealer?,
      colors: freezed == colors
          ? _value.colors
          : colors // ignore: cast_nullable_to_non_nullable
              as List<CarColor>?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }

  /// Create a copy of Car
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CarCategoryCopyWith<$Res>? get category {
    if (_value.category == null) {
      return null;
    }

    return $CarCategoryCopyWith<$Res>(_value.category!, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }

  /// Create a copy of Car
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CarBrandCopyWith<$Res>? get brand {
    if (_value.brand == null) {
      return null;
    }

    return $CarBrandCopyWith<$Res>(_value.brand!, (value) {
      return _then(_value.copyWith(brand: value) as $Val);
    });
  }

  /// Create a copy of Car
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BrandModelCopyWith<$Res>? get brandModel {
    if (_value.brandModel == null) {
      return null;
    }

    return $BrandModelCopyWith<$Res>(_value.brandModel!, (value) {
      return _then(_value.copyWith(brandModel: value) as $Val);
    });
  }

  /// Create a copy of Car
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CarBodyTypeCopyWith<$Res>? get bodyType {
    if (_value.bodyType == null) {
      return null;
    }

    return $CarBodyTypeCopyWith<$Res>(_value.bodyType!, (value) {
      return _then(_value.copyWith(bodyType: value) as $Val);
    });
  }

  /// Create a copy of Car
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DealerCopyWith<$Res>? get dealer {
    if (_value.dealer == null) {
      return null;
    }

    return $DealerCopyWith<$Res>(_value.dealer!, (value) {
      return _then(_value.copyWith(dealer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CarImplCopyWith<$Res> implements $CarCopyWith<$Res> {
  factory _$$CarImplCopyWith(_$CarImpl value, $Res Function(_$CarImpl) then) =
      __$$CarImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? title,
      String? description,
      @JsonKey(name: 'cover_image') String? coverImage,
      @JsonKey(fromJson: imageUrlsFromJson) List<String>? images,
      String? video,
      int? year,
      String? transmission,
      @JsonKey(name: 'fuel_type') String? fuelType,
      String? drivetrain,
      int? horsepower,
      int? doors,
      int? seats,
      @JsonKey(name: 'mileage_km') @StringConverter() String? mileageKm,
      double? price,
      @JsonKey(name: 'down_payment') @IntConverter() int? downPayment,
      String? condition,
      CarCategory? category,
      CarBrand? brand,
      BrandModel? brandModel,
      CarBodyType? bodyType,
      @JsonKey(name: 'vendor') Dealer? dealer,
      List<CarColor>? colors,
      @JsonKey(name: 'is_active') bool? isActive});

  @override
  $CarCategoryCopyWith<$Res>? get category;
  @override
  $CarBrandCopyWith<$Res>? get brand;
  @override
  $BrandModelCopyWith<$Res>? get brandModel;
  @override
  $CarBodyTypeCopyWith<$Res>? get bodyType;
  @override
  $DealerCopyWith<$Res>? get dealer;
}

/// @nodoc
class __$$CarImplCopyWithImpl<$Res> extends _$CarCopyWithImpl<$Res, _$CarImpl>
    implements _$$CarImplCopyWith<$Res> {
  __$$CarImplCopyWithImpl(_$CarImpl _value, $Res Function(_$CarImpl) _then)
      : super(_value, _then);

  /// Create a copy of Car
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? coverImage = freezed,
    Object? images = freezed,
    Object? video = freezed,
    Object? year = freezed,
    Object? transmission = freezed,
    Object? fuelType = freezed,
    Object? drivetrain = freezed,
    Object? horsepower = freezed,
    Object? doors = freezed,
    Object? seats = freezed,
    Object? mileageKm = freezed,
    Object? price = freezed,
    Object? downPayment = freezed,
    Object? condition = freezed,
    Object? category = freezed,
    Object? brand = freezed,
    Object? brandModel = freezed,
    Object? bodyType = freezed,
    Object? dealer = freezed,
    Object? colors = freezed,
    Object? isActive = freezed,
  }) {
    return _then(_$CarImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImage: freezed == coverImage
          ? _value.coverImage
          : coverImage // ignore: cast_nullable_to_non_nullable
              as String?,
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      video: freezed == video
          ? _value.video
          : video // ignore: cast_nullable_to_non_nullable
              as String?,
      year: freezed == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int?,
      transmission: freezed == transmission
          ? _value.transmission
          : transmission // ignore: cast_nullable_to_non_nullable
              as String?,
      fuelType: freezed == fuelType
          ? _value.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String?,
      drivetrain: freezed == drivetrain
          ? _value.drivetrain
          : drivetrain // ignore: cast_nullable_to_non_nullable
              as String?,
      horsepower: freezed == horsepower
          ? _value.horsepower
          : horsepower // ignore: cast_nullable_to_non_nullable
              as int?,
      doors: freezed == doors
          ? _value.doors
          : doors // ignore: cast_nullable_to_non_nullable
              as int?,
      seats: freezed == seats
          ? _value.seats
          : seats // ignore: cast_nullable_to_non_nullable
              as int?,
      mileageKm: freezed == mileageKm
          ? _value.mileageKm
          : mileageKm // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      downPayment: freezed == downPayment
          ? _value.downPayment
          : downPayment // ignore: cast_nullable_to_non_nullable
              as int?,
      condition: freezed == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as CarCategory?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as CarBrand?,
      brandModel: freezed == brandModel
          ? _value.brandModel
          : brandModel // ignore: cast_nullable_to_non_nullable
              as BrandModel?,
      bodyType: freezed == bodyType
          ? _value.bodyType
          : bodyType // ignore: cast_nullable_to_non_nullable
              as CarBodyType?,
      dealer: freezed == dealer
          ? _value.dealer
          : dealer // ignore: cast_nullable_to_non_nullable
              as Dealer?,
      colors: freezed == colors
          ? _value._colors
          : colors // ignore: cast_nullable_to_non_nullable
              as List<CarColor>?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CarImpl implements _Car {
  const _$CarImpl(
      {this.id,
      this.title,
      this.description,
      @JsonKey(name: 'cover_image') this.coverImage,
      @JsonKey(fromJson: imageUrlsFromJson) final List<String>? images,
      this.video,
      this.year,
      this.transmission,
      @JsonKey(name: 'fuel_type') this.fuelType,
      this.drivetrain,
      this.horsepower,
      this.doors,
      this.seats,
      @JsonKey(name: 'mileage_km') @StringConverter() this.mileageKm,
      this.price,
      @JsonKey(name: 'down_payment') @IntConverter() this.downPayment,
      this.condition,
      this.category,
      this.brand,
      this.brandModel,
      this.bodyType,
      @JsonKey(name: 'vendor') this.dealer,
      final List<CarColor>? colors,
      @JsonKey(name: 'is_active') this.isActive})
      : _images = images,
        _colors = colors;

  factory _$CarImpl.fromJson(Map<String, dynamic> json) =>
      _$$CarImplFromJson(json);

  @override
  final int? id;
  @override
  final String? title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'cover_image')
  final String? coverImage;
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
  final String? video;
  @override
  final int? year;
  @override
  final String? transmission;
  @override
  @JsonKey(name: 'fuel_type')
  final String? fuelType;
  @override
  final String? drivetrain;
  @override
  final int? horsepower;
  @override
  final int? doors;
  @override
  final int? seats;
  @override
  @JsonKey(name: 'mileage_km')
  @StringConverter()
  final String? mileageKm;
  @override
  final double? price;
  @override
  @JsonKey(name: 'down_payment')
  @IntConverter()
  final int? downPayment;
  @override
  final String? condition;
  @override
  final CarCategory? category;
  @override
  final CarBrand? brand;
  @override
  final BrandModel? brandModel;
  @override
  final CarBodyType? bodyType;
  @override
  @JsonKey(name: 'vendor')
  final Dealer? dealer;
  final List<CarColor>? _colors;
  @override
  List<CarColor>? get colors {
    final value = _colors;
    if (value == null) return null;
    if (_colors is EqualUnmodifiableListView) return _colors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'is_active')
  final bool? isActive;

  @override
  String toString() {
    return 'Car(id: $id, title: $title, description: $description, coverImage: $coverImage, images: $images, video: $video, year: $year, transmission: $transmission, fuelType: $fuelType, drivetrain: $drivetrain, horsepower: $horsepower, doors: $doors, seats: $seats, mileageKm: $mileageKm, price: $price, downPayment: $downPayment, condition: $condition, category: $category, brand: $brand, brandModel: $brandModel, bodyType: $bodyType, dealer: $dealer, colors: $colors, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CarImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.coverImage, coverImage) ||
                other.coverImage == coverImage) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.video, video) || other.video == video) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.transmission, transmission) ||
                other.transmission == transmission) &&
            (identical(other.fuelType, fuelType) ||
                other.fuelType == fuelType) &&
            (identical(other.drivetrain, drivetrain) ||
                other.drivetrain == drivetrain) &&
            (identical(other.horsepower, horsepower) ||
                other.horsepower == horsepower) &&
            (identical(other.doors, doors) || other.doors == doors) &&
            (identical(other.seats, seats) || other.seats == seats) &&
            (identical(other.mileageKm, mileageKm) ||
                other.mileageKm == mileageKm) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.downPayment, downPayment) ||
                other.downPayment == downPayment) &&
            (identical(other.condition, condition) ||
                other.condition == condition) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.brandModel, brandModel) ||
                other.brandModel == brandModel) &&
            (identical(other.bodyType, bodyType) ||
                other.bodyType == bodyType) &&
            (identical(other.dealer, dealer) || other.dealer == dealer) &&
            const DeepCollectionEquality().equals(other._colors, _colors) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        description,
        coverImage,
        const DeepCollectionEquality().hash(_images),
        video,
        year,
        transmission,
        fuelType,
        drivetrain,
        horsepower,
        doors,
        seats,
        mileageKm,
        price,
        downPayment,
        condition,
        category,
        brand,
        brandModel,
        bodyType,
        dealer,
        const DeepCollectionEquality().hash(_colors),
        isActive
      ]);

  /// Create a copy of Car
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CarImplCopyWith<_$CarImpl> get copyWith =>
      __$$CarImplCopyWithImpl<_$CarImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CarImplToJson(
      this,
    );
  }
}

abstract class _Car implements Car {
  const factory _Car(
      {final int? id,
      final String? title,
      final String? description,
      @JsonKey(name: 'cover_image') final String? coverImage,
      @JsonKey(fromJson: imageUrlsFromJson) final List<String>? images,
      final String? video,
      final int? year,
      final String? transmission,
      @JsonKey(name: 'fuel_type') final String? fuelType,
      final String? drivetrain,
      final int? horsepower,
      final int? doors,
      final int? seats,
      @JsonKey(name: 'mileage_km') @StringConverter() final String? mileageKm,
      final double? price,
      @JsonKey(name: 'down_payment') @IntConverter() final int? downPayment,
      final String? condition,
      final CarCategory? category,
      final CarBrand? brand,
      final BrandModel? brandModel,
      final CarBodyType? bodyType,
      @JsonKey(name: 'vendor') final Dealer? dealer,
      final List<CarColor>? colors,
      @JsonKey(name: 'is_active') final bool? isActive}) = _$CarImpl;

  factory _Car.fromJson(Map<String, dynamic> json) = _$CarImpl.fromJson;

  @override
  int? get id;
  @override
  String? get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'cover_image')
  String? get coverImage;
  @override
  @JsonKey(fromJson: imageUrlsFromJson)
  List<String>? get images;
  @override
  String? get video;
  @override
  int? get year;
  @override
  String? get transmission;
  @override
  @JsonKey(name: 'fuel_type')
  String? get fuelType;
  @override
  String? get drivetrain;
  @override
  int? get horsepower;
  @override
  int? get doors;
  @override
  int? get seats;
  @override
  @JsonKey(name: 'mileage_km')
  @StringConverter()
  String? get mileageKm;
  @override
  double? get price;
  @override
  @JsonKey(name: 'down_payment')
  @IntConverter()
  int? get downPayment;
  @override
  String? get condition;
  @override
  CarCategory? get category;
  @override
  CarBrand? get brand;
  @override
  BrandModel? get brandModel;
  @override
  CarBodyType? get bodyType;
  @override
  @JsonKey(name: 'vendor')
  Dealer? get dealer;
  @override
  List<CarColor>? get colors;
  @override
  @JsonKey(name: 'is_active')
  bool? get isActive;

  /// Create a copy of Car
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CarImplCopyWith<_$CarImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
