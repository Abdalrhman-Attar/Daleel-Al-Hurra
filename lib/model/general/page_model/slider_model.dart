class SliderModel {
  final int id;
  final String title;
  final String? subtitle;
  final String? image;
  final bool isActive;

  SliderModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.image,
    required this.isActive,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      subtitle: json['subtitle'],
      image: json['image'],
      isActive: json['is_active'] ?? false,
    );
  }
}
