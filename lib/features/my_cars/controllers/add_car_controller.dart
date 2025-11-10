import 'dart:io';

import 'package:flutter/material.dart' hide Color;
import 'package:get/get.dart';

import '../../../api/cars/cars_apis.dart';
import '../../../api/dealers/dealer_apis.dart';
import '../../../model/cars/brand_model/brand_model.dart';
import '../../../model/cars/car_body_type/car_body_type.dart';
import '../../../model/cars/car_brand/car_brand.dart';
import '../../../model/cars/car_category/car_category.dart';
import '../../../model/cars/color/d_color.dart';
import '../../../module/toast.dart';
import '../../../services/image_picker_service.dart';

List<String> mileageKms = [
  '0 Km',
  '0 - 5 Km',
  '5 - 10 Km',
  '10 - 15 Km',
  '15 - 20 Km',
  '20 - 25 Km',
  '25 - 30 Km',
  '30 - 35 Km',
  '35 - 40 Km',
  '40 - 45 Km',
  '45 - 50 Km',
  '50 - 55 Km',
  '55 - 60 Km',
  '60 - 65 Km',
  '65 - 70 Km',
  '70 - 75 Km',
  '75 - 80 Km',
  '80 - 85 Km',
  '85 - 90 Km',
  '90 - 95 Km',
  '95 - 100 Km',
  '100+ Km',
];

class SelectedColor {
  final DColor color;
  final String type;
  final List<File> images;

  SelectedColor(
      {required this.color, required this.images, required this.type});

  Map<String, dynamic> toJson() {
    return {
      'color': color.toJson(),
      'images': images.map((e) => e.path).toList(),
      'type': type,
    };
  }
}

class AddCarController extends GetxController {
  final RxBool _isLoading = true.obs;
  final RxBool _isError = false.obs;
  final RxBool _isRefreshing = false.obs;

  final RxList<CarBrand> _allBrands = <CarBrand>[].obs;
  final RxList<BrandModel> _allBrandModels = <BrandModel>[].obs;
  final RxList<CarCategory> _allCarCategories = <CarCategory>[].obs;
  final RxList<CarBodyType> _allCarBodyTypes = <CarBodyType>[].obs;
  final RxList<DColor> _allCarColors = <DColor>[].obs;

  // Getters for private variables
  bool get isLoading => _isLoading.value;
  bool get isError => _isError.value;
  bool get isRefreshing => _isRefreshing.value;
  List<CarBrand> get allBrands => _allBrands;
  List<BrandModel> get allBrandModels => _allBrandModels;
  List<CarCategory> get allCarCategories => _allCarCategories;
  List<CarBodyType> get allCarBodyTypes => _allCarBodyTypes;
  List<DColor> get allCarColors => _allCarColors;

  set allCarCategories(List<CarCategory> value) =>
      _allCarCategories.value = value;
  set allBrands(List<CarBrand> value) => _allBrands.value = value;
  set allCarBodyTypes(List<CarBodyType> value) =>
      _allCarBodyTypes.value = value;
  set allCarColors(List<DColor> value) => _allCarColors.value = value;
  set allBrandModels(List<BrandModel> value) => _allBrandModels.value = value;

  // Setters for private variables
  set isLoading(bool value) => _isLoading.value = value;
  set isError(bool value) => _isError.value = value;
  set isRefreshing(bool value) => _isRefreshing.value = value;

  // Car filters - make sure these are the ONLY declarations
  final Rx<CarCategory?> _selectedCategory = Rx<CarCategory?>(null);
  final Rx<CarBrand?> _selectedBrand = Rx<CarBrand?>(null);
  final Rx<BrandModel?> _selectedBrandModel = Rx<BrandModel?>(null);
  final Rx<CarBodyType?> _selectedBodyType = Rx<CarBodyType?>(null);

  // These are RxList - no other getters should exist for these names
  final Rx<String?> _transmission = Rx<String?>(null);
  final Rx<String?> _fuelType = Rx<String?>(null);
  final Rx<String?> _drivetrain = Rx<String?>(null);
  final Rx<String?> _condition = Rx<String?>(null);
  final Rx<String?> _mileageKm = Rx<String?>(null);

  CarCategory? get selectedCategory => _selectedCategory.value;
  CarBrand? get selectedBrand => _selectedBrand.value;
  BrandModel? get selectedBrandModel => _selectedBrandModel.value;
  CarBodyType? get selectedBodyType => _selectedBodyType.value;

  String? get transmission => _transmission.value;
  String? get fuelType => _fuelType.value;
  String? get drivetrain => _drivetrain.value;
  String? get condition => _condition.value;
  String? get mileageKm => _mileageKm.value;
  Future<void> fetchBrandModels(List<CarBrand> value) async {
    try {
      isLoading = true;
      final brandModelsResponse = await CarsApis().getBrandModels(
        brandId: value.map((e) => e.id).join(','),
      );
      debugPrint('Brand Models Response: ${brandModelsResponse.data}');
      _allBrandModels.value = brandModelsResponse.data ?? [];
      debugPrint('All Brand Models: $_allBrandModels');
    } catch (e) {
      debugPrint('Error fetching brand models: $e');
    } finally {
      isLoading = false;
    }
  }

  final Rx<TextEditingController> _titleController =
      TextEditingController().obs;
  final Rx<TextEditingController> _descriptionController =
      TextEditingController().obs;
  final Rx<File?> _coverImage = Rx<File?>(null);
  final RxList<File> _images = <File>[].obs;
  final Rx<File?> _video = Rx<File?>(null);
  final RxList<SelectedColor> _selectedColors = <SelectedColor>[].obs;

  // Color images mapping - stores images for each selected color
  final RxMap<int, List<File>> _colorImages = <int, List<File>>{}.obs;

  TextEditingController get titleController => _titleController.value;
  TextEditingController get descriptionController =>
      _descriptionController.value;

  File? get coverImage => _coverImage.value;
  List<File> get images => _images;
  File? get video => _video.value;
  List<SelectedColor> get selectedColors => _selectedColors;
  Map<int, List<File>> get colorImages => _colorImages;

  set titleController(TextEditingController value) =>
      _titleController.value = value;
  set descriptionController(TextEditingController value) =>
      _descriptionController.value = value;
  set coverImage(File? value) => _coverImage.value = value;
  set video(File? value) => _video.value = value;

  set selectedCategory(CarCategory? value) => _selectedCategory.value = value;
  set selectedBrand(CarBrand? value) => _selectedBrand.value = value;
  set selectedBrandModel(BrandModel? value) =>
      _selectedBrandModel.value = value;
  set selectedBodyType(CarBodyType? value) => _selectedBodyType.value = value;
  set mileageKm(String? value) => _mileageKm.value = value;
  set transmission(String? value) => _transmission.value = value;
  set fuelType(String? value) => _fuelType.value = value;
  set drivetrain(String? value) => _drivetrain.value = value;
  set condition(String? value) => _condition.value = value;

  // Rest of your properties...
  final Rx<TextEditingController> _year = TextEditingController().obs;
  final Rx<TextEditingController> _price = TextEditingController().obs;
  final Rx<TextEditingController> _downPayment = TextEditingController().obs;
  final Rx<TextEditingController> _horsepower = TextEditingController().obs;
  final Rx<TextEditingController> _doors = TextEditingController().obs;
  final Rx<TextEditingController> _seats = TextEditingController().obs;

  TextEditingController get year => _year.value;
  TextEditingController get price => _price.value;
  TextEditingController get downPayment => _downPayment.value;
  TextEditingController get horsepower => _horsepower.value;
  TextEditingController get doors => _doors.value;
  TextEditingController get seats => _seats.value;

  set year(TextEditingController value) => _year.value = value;
  set price(TextEditingController value) => _price.value = value;
  set downPayment(TextEditingController value) => _downPayment.value = value;
  set horsepower(TextEditingController value) => _horsepower.value = value;
  set doors(TextEditingController value) => _doors.value = value;
  set seats(TextEditingController value) => _seats.value = value;

  // Image and video picker methods
  Future<void> pickCoverImage(BuildContext context) async {
    final source =
        await ImagePickerService.showImageSourceDialog(context: context);
    if (source != null) {
      final image = await ImagePickerService.pickImage(
        context: context,
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image != null) {
        coverImage = image;
      }
    }
  }

  Future<void> pickMultipleImages(BuildContext context) async {
    final newImages = await ImagePickerService.pickMultipleImages(
      context: context,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );
    if (newImages.isNotEmpty) {
      _images.addAll(newImages);
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < _images.length) {
      _images.removeAt(index);
    }
  }

  Future<void> pickVideo(BuildContext context) async {
    final source =
        await ImagePickerService.showVideoSourceDialog(context: context);
    if (source != null) {
      final videoFile = await ImagePickerService.pickVideo(
        context: context,
        source: source,
        maxDuration: const Duration(minutes: 10),
      );
      if (videoFile != null) {
        video = videoFile;
      }
    }
  }

  void removeVideo() {
    video = null;
  }

  // Color management methods
  void toggleColor(DColor color, String type) {
    // Check if color is already selected for this specific type
    final existingIndex =
        _selectedColors.indexWhere((e) => e.color == color && e.type == type);

    if (existingIndex != -1) {
      // Remove the color for this specific type
      _selectedColors.removeAt(existingIndex);
      _colorImages.remove(color.id);
    } else {
      // Add the color for this specific type
      _selectedColors.add(SelectedColor(color: color, images: [], type: type));
      _colorImages[color.id!] = [];
    }
  }

  bool isColorSelected(DColor color, String type) {
    return _selectedColors.any((e) => e.color == color && e.type == type);
  }

  Future<void> pickColorImages(
      BuildContext context, SelectedColor color) async {
    final newImages = await ImagePickerService.pickMultipleImages(
      context: context,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );
    if (newImages.isNotEmpty) {
      _colorImages[color.color.id!] = [
        ...(_colorImages[color.color.id!] ?? []),
        ...newImages
      ];
      // Update the color's images list
      final index = _selectedColors
          .indexWhere((c) => c.color == color.color && c.type == color.type);
      if (index != -1) {
        _selectedColors[index] = SelectedColor(
          color: color.color,
          images: _colorImages[color.color.id!] ?? [],
          type: color.type,
        );
      }
    }
  }

  void removeColorImage(SelectedColor color, int imageIndex) {
    final updatedImages = List<File>.from(color.images);
    if (imageIndex >= 0 && imageIndex < updatedImages.length) {
      updatedImages.removeAt(imageIndex);

      // Update the color's images list
      final index = _selectedColors
          .indexWhere((c) => c.color == color.color && c.type == color.type);
      if (index != -1) {
        _selectedColors[index] = SelectedColor(
          color: color.color,
          images: updatedImages,
          type: color.type,
        );
      }

      // Update the color images map
      _colorImages[color.color.id!] = updatedImages;
    }
  }

  List<File> getColorImages(SelectedColor color) {
    return color.images;
  }

  Future<void> fetchAllData() async {
    isLoading = true;
    try {
      final carCategoryResponse = await CarsApis().getCarCategories();
      final carColorResponse = await CarsApis().getCarColors();
      final brandResponse = await CarsApis().getCarBrands();
      final bodyTypeResponse = await CarsApis().getCarBodyTypes();

      _allCarCategories.value = carCategoryResponse.data ?? [];
      _allCarColors.value = carColorResponse.data ?? [];
      _allBrands.value = brandResponse.data ?? [];
      _allCarBodyTypes.value = bodyTypeResponse.data ?? [];
    } catch (e) {
      debugPrint('Error fetching data: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> addCar({
    bool isRefresh = false,
    required BuildContext context,
  }) async {
    try {
      isError = false;
      isLoading = true;
      isRefreshing = false;

      // Validate required fields
      if (selectedCategory == null) {
        Toast.e('Please select a category');
        return;
      }
      if (selectedBrand == null) {
        Toast.e('Please select a brand');
        return;
      }
      if (selectedBrandModel == null) {
        Toast.e('Please select a brand model');
        return;
      }
      if (selectedBodyType == null) {
        Toast.e('Please select a body type');
        return;
      }
      if (titleController.text.trim().isEmpty) {
        Toast.e('Please enter a title');
        return;
      }
      if (coverImage == null) {
        Toast.e('Please select a cover image');
        return;
      }

      final response = await DealerApis().addCar(
        categoryId: selectedCategory?.id ?? 0,
        brandId: selectedBrand?.id ?? 0,
        brandModelId: selectedBrandModel?.id ?? 0,
        bodyTypeId: selectedBodyType?.id ?? 0,
        title: titleController.text,
        description: descriptionController.text,
        transmission: transmission?.toLowerCase() ?? '',
        fuelType: fuelType?.toLowerCase() ?? '',
        drivetrain: drivetrain?.toLowerCase() ?? '',
        condition: condition?.toLowerCase() ?? '',
        year: year.text,
        price: price.text,
        downPayment: downPayment.text,
        mileage: mileageKm?.toLowerCase() ?? '',
        horsepower: horsepower.text,
        doors: doors.text,
        seats: seats.text,
        coverImage: coverImage!,
        images: images,
        video: video,
        colors: selectedColors,
      );

      if (response.isSuccess) {
        Toast.s('Car added successfully');
        clearAll();
        Navigator.of(context).pop();
      } else {
        isError = true;
        Toast.e(response.message ?? 'Failed to add car');
      }
    } catch (e) {
      isError = true;
      Toast.e('Error: ${e.toString()}');
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> refresh() async {
    await fetchAllData();
  }

  void clearAll() {
    _selectedCategory.value = null;
    _selectedBrand.value = null;
    _selectedBrandModel.value = null;
    _selectedBodyType.value = null;
    _transmission.value = null;
    _fuelType.value = null;
    _drivetrain.value = null;
    _condition.value = null;
    year = TextEditingController(text: '2010');
    price = TextEditingController(text: '0');
    downPayment = TextEditingController(text: '0');
    mileageKm = null;
    horsepower = TextEditingController(text: '0');
    doors = TextEditingController(text: '0');
    seats = TextEditingController(text: '0');
    titleController.clear();
    descriptionController.clear();

    coverImage = null;
    _images.clear();
    video = null;
    _selectedColors.clear();
    _colorImages.clear();
  }

  void reset() {
    isLoading = true;
    isError = false;
    isRefreshing = false;
    allBrands.clear();
    allBrands = [];
    allBrandModels.clear();
    allBrandModels = [];
    allCarCategories.clear();
    allCarCategories = [];
    allCarBodyTypes.clear();
    allCarBodyTypes = [];
    allCarColors.clear();
    allCarColors = [];
  }
}
