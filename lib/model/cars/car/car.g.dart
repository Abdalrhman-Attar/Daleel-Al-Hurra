// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CarImpl _$$CarImplFromJson(Map<String, dynamic> json) => _$CarImpl(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      coverImage: json['cover_image'] as String?,
      images: imageUrlsFromJson(json['images']),
      video: json['video'] as String?,
      year: (json['year'] as num?)?.toInt(),
      transmission: json['transmission'] as String?,
      fuelType: json['fuel_type'] as String?,
      drivetrain: json['drivetrain'] as String?,
      horsepower: (json['horsepower'] as num?)?.toInt(),
      doors: (json['doors'] as num?)?.toInt(),
      seats: (json['seats'] as num?)?.toInt(),
      mileageKm: const StringConverter().fromJson(json['mileage_km']),
      price: (json['price'] as num?)?.toDouble(),
      downPayment: const IntConverter().fromJson(json['down_payment']),
      condition: json['condition'] as String?,
      category: json['category'] == null
          ? null
          : CarCategory.fromJson(json['category'] as Map<String, dynamic>),
      brand: json['brand'] == null
          ? null
          : CarBrand.fromJson(json['brand'] as Map<String, dynamic>),
      brandModel: json['brandModel'] == null
          ? null
          : BrandModel.fromJson(json['brandModel'] as Map<String, dynamic>),
      bodyType: json['bodyType'] == null
          ? null
          : CarBodyType.fromJson(json['bodyType'] as Map<String, dynamic>),
      dealer: json['vendor'] == null
          ? null
          : Dealer.fromJson(json['vendor'] as Map<String, dynamic>),
      colors: (json['colors'] as List<dynamic>?)
          ?.map((e) => CarColor.fromJson(e as Map<String, dynamic>))
          .toList(),
      isActive: json['is_active'] as bool?,
    );

Map<String, dynamic> _$$CarImplToJson(_$CarImpl instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'cover_image': instance.coverImage,
      'images': instance.images,
      'video': instance.video,
      'year': instance.year,
      'transmission': instance.transmission,
      'fuel_type': instance.fuelType,
      'drivetrain': instance.drivetrain,
      'horsepower': instance.horsepower,
      'doors': instance.doors,
      'seats': instance.seats,
      'mileage_km': const StringConverter().toJson(instance.mileageKm),
      'price': instance.price,
      'down_payment': const IntConverter().toJson(instance.downPayment),
      'condition': instance.condition,
      'category': instance.category,
      'brand': instance.brand,
      'brandModel': instance.brandModel,
      'bodyType': instance.bodyType,
      'vendor': instance.dealer,
      'colors': instance.colors,
      'is_active': instance.isActive,
    };
