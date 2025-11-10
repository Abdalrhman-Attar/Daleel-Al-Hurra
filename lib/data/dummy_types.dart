class Brand {
  final String? name;
  final String? image;
  final List<Model>? models;

  Brand({this.name, this.image, this.models});
}

class Model {
  final String? name;
  final String? image;

  Model({this.name, this.image});
}

class Car {
  final String? name;
  final String? image;
  final List<String>? images;
  final List<String>? colors;
  final Brand? brand;
  final Model? model;
  final String? category;
  final String? paymentMethod;
  final String? description;
  final double? price;
  final int? doors;
  final int? seats;
  final String? fuelType;
  final String? transmission;
  final String? year;
  final String? mileage;
  final Dealer? dealer; // 👈 Added field

  const Car({
    this.name,
    this.image,
    this.images,
    this.colors,
    this.brand,
    this.model,
    this.category,
    this.paymentMethod,
    this.description,
    this.price,
    this.doors,
    this.seats,
    this.fuelType,
    this.transmission,
    this.year,
    this.mileage,
    this.dealer,
  });
}

class Dealer {
  final String? name;
  final String? phone;
  final String? email;
  final String? address;
  final String? image; // optional: for profile or logo

  const Dealer({
    this.name,
    this.phone,
    this.email,
    this.address,
    this.image,
  });
}
