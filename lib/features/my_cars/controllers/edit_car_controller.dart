import 'dart:io';

import 'package:flutter/material.dart' hide Color;
import 'package:get/get.dart';

import '../../../api/cars/cars_apis.dart';
import '../../../api/dealers/dealer_apis.dart';
import '../../../model/cars/brand_model/brand_model.dart';
import '../../../model/cars/car_body_type/car_body_type.dart';
import '../../../model/cars/car_brand/car_brand.dart';
import '../../../model/cars/car_category/car_category.dart';
import '../../../model/cars/car_color/car_color.dart';
import '../../../model/cars/color/d_color.dart';
import '../../../module/toast.dart';
import '../../../services/download_service.dart';
import '../../../services/image_picker_service.dart';
import 'add_car_controller.dart';

class EditCarController extends GetxController {
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

  set allCarCategories(List<CarCategory> value) => _allCarCategories.value = value;
  set allBrands(List<CarBrand> value) => _allBrands.value = value;
  set allCarBodyTypes(List<CarBodyType> value) => _allCarBodyTypes.value = value;
  set allCarColors(List<DColor> value) => _allCarColors.value = value;
  set allBrandModels(List<BrandModel> value) => _allBrandModels.value = value;

  // Setters for private variables
  set isLoading(bool value) => _isLoading.value = value;
  set isError(bool value) => _isError.value = value;
  set isRefreshing(bool value) => _isRefreshing.value = value;

  final Rx<int?> _carId = Rx<int?>(null);
  int? get carId => _carId.value;
  set carId(int? value) => _carId.value = value;

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

  final Rx<TextEditingController> _titleController = TextEditingController().obs;
  final Rx<TextEditingController> _descriptionController = TextEditingController().obs;
  final Rx<TextEditingController> _vinController = TextEditingController().obs;
  final Rx<TextEditingController> _plateNumberController = TextEditingController().obs;
  final Rx<String?> _oldCoverImage = Rx<String?>(null);
  final Rx<File?> _newCoverImage = Rx<File?>(null);
  final RxList<String> _oldImages = <String>[].obs;
  final RxList<File> _newImages = <File>[].obs;
  final RxList<dynamic> _allImages = <dynamic>[].obs; // Mixed URLs and Files
  final Rx<String?> _oldVideo = Rx<String?>(null);
  final Rx<File?> _newVideo = Rx<File?>(null);
  final RxList<CarColor?> _oldSelectedColors = <CarColor?>[].obs;
  final RxList<SelectedColor> _newSelectedColors = <SelectedColor>[].obs;

  // Color images mapping - stores images for each selected color
  final RxMap<int, List<File>> _colorImages = <int, List<File>>{}.obs;

  // Track removed old color images (URLs that should not be included in submission)
  final RxMap<String, List<String>> _removedOldColorImages = <String, List<String>>{}.obs;

  // Track removed old car images (URLs that should not be included in submission)
  final RxList<String> _removedOldCarImages = <String>[].obs;

  TextEditingController get titleController => _titleController.value;
  TextEditingController get descriptionController => _descriptionController.value;
  TextEditingController get vinController => _vinController.value;
  TextEditingController get plateNumberController => _plateNumberController.value;
  String? get oldCoverImage => _oldCoverImage.value;
  File? get newCoverImage => _newCoverImage.value;
  List<String> get oldImages => _oldImages;
  List<File> get newImages => _newImages;
  List<dynamic> get allImages => _allImages;
  File? get coverImage => newCoverImage;
  List<File> get images => newImages;
  File? get video => newVideo;
  String? get oldVideo => _oldVideo.value;
  File? get newVideo => _newVideo.value;
  List<CarColor?> get oldSelectedColors => _oldSelectedColors;
  List<SelectedColor> get newSelectedColors => _newSelectedColors;
  List<SelectedColor> get selectedColors => newSelectedColors;
  Map<int, List<File>> get colorImages => _colorImages;

  set titleController(TextEditingController value) => _titleController.value = value;
  set descriptionController(TextEditingController value) => _descriptionController.value = value;
  set vinController(TextEditingController value) => _vinController.value = value;
  set plateNumberController(TextEditingController value) => _plateNumberController.value = value;
  set oldCoverImage(String? value) => _oldCoverImage.value = value;
  set newCoverImage(File? value) => _newCoverImage.value = value;
  set oldImages(List<String> value) => _oldImages.value = value;
  set allImages(List<dynamic> value) => _allImages.value = value;
  set oldVideo(String? value) => _oldVideo.value = value;
  set newVideo(File? value) => _newVideo.value = value;
  set oldSelectedColors(List<CarColor?> value) => _oldSelectedColors.value = value;
  set newSelectedColors(List<SelectedColor> value) => _newSelectedColors.value = value;

  set selectedCategory(CarCategory? value) => _selectedCategory.value = value;
  set selectedBrand(CarBrand? value) => _selectedBrand.value = value;
  set selectedBrandModel(BrandModel? value) => _selectedBrandModel.value = value;
  set selectedBodyType(CarBodyType? value) => _selectedBodyType.value = value;

  set transmission(String? value) => _transmission.value = value;
  set fuelType(String? value) => _fuelType.value = value;
  set drivetrain(String? value) => _drivetrain.value = value;
  set condition(String? value) => _condition.value = value;
  set mileageKm(String? value) => _mileageKm.value = value;
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
    final source = await ImagePickerService.showImageSourceDialog(context: context);
    if (source != null) {
      final image = await ImagePickerService.pickImage(
        context: context,
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image != null) {
        newCoverImage = image;
        // Clear old cover image when new one is selected
        oldCoverImage = null;
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
      _newImages.addAll(newImages);
      _allImages.addAll(newImages);
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < _allImages.length) {
      final item = _allImages[index];
      if (item is File) {
        _newImages.remove(item);
      }
      _allImages.removeAt(index);
    }
  }

  /// Remove old image by URL
  void removeOldImage(String imageUrl) {
    _removedOldCarImages.add(imageUrl);
    _allImages.remove(imageUrl);
  }

  /// Initialize mixed images list from old data
  void initializeMixedImages() {
    _allImages.clear();
    // Add available old images (URLs) first (excluding removed ones)
    final availableOldImages = getAvailableOldCarImages();
    _allImages.addAll(availableOldImages);
    // Add new images (Files) if any
    _allImages.addAll(_newImages);
  }

  /// Get available old car images (excluding removed ones)
  List<String> getAvailableOldCarImages() {
    return _oldImages.where((url) => !_removedOldCarImages.contains(url)).toList();
  }

  /// Initialize colors from old CarColor data
  Future<void> initializeColorsFromOldData() async {
    _newSelectedColors.clear();

    for (final carColor in _oldSelectedColors) {
      if (carColor?.color != null && carColor?.type != null) {
        // Convert CarColor to SelectedColor
        final selectedColor = SelectedColor(
          color: carColor!.color!,
          type: carColor.type!,
          images: [], // Start with empty images list
        );

        _newSelectedColors.add(selectedColor);

        // If there are old images (URLs), we'll handle them separately
        // We don't download them immediately to avoid performance issues
        // They will be downloaded when the user submits the form
      }
    }
  }

  /// Get all color images as Files (download URLs if needed)
  Future<List<SelectedColor>> getColorsWithDownloadedImages() async {
    final updatedColors = <SelectedColor>[];

    for (final selectedColor in _newSelectedColors) {
      try {
        // Get available old images (excluding removed ones)
        final availableOldImages = getAvailableOldColorImages(selectedColor);

        var colorImages = List<File>.from(selectedColor.images); // Copy current images

        // If there are available old image URLs and no new images, download them
        if (availableOldImages.isNotEmpty && selectedColor.images.isEmpty) {
          final downloadedImages = await DownloadService.downloadImagesFromUrls(availableOldImages);
          colorImages.addAll(downloadedImages);
        }

        updatedColors.add(SelectedColor(
          color: selectedColor.color,
          type: selectedColor.type,
          images: colorImages,
        ));
      } catch (e) {
        debugPrint('Error processing color images for ${selectedColor.color.name}: $e');
        // Add the color without images if there's an error
        updatedColors.add(SelectedColor(
          color: selectedColor.color,
          type: selectedColor.type,
          images: selectedColor.images, // Keep existing images if any
        ));
      }
    }

    return updatedColors;
  }

  /// Get all images as Files (download URLs if needed)
  Future<List<File>> getAllImagesAsFiles() async {
    try {
      // Create a list with available old images and new images
      final availableImages = <dynamic>[];
      availableImages.addAll(getAvailableOldCarImages());
      availableImages.addAll(_newImages);
      return await DownloadService.convertMixedToFiles(availableImages);
    } catch (e) {
      debugPrint('Error converting images to files: $e');
      // Return only new images if there's an error with old images
      return _newImages.where((file) => file.existsSync()).toList();
    }
  }

  /// Get cover image as File (download if it's a URL)
  Future<File?> getCoverImageAsFile() async {
    try {
      if (newCoverImage != null) {
        return newCoverImage;
      } else if (oldCoverImage != null && DownloadService.isValidUrl(oldCoverImage!)) {
        return await DownloadService.downloadImageFromUrl(oldCoverImage!);
      }
    } catch (e) {
      debugPrint('Error getting cover image as file: $e');
    }
    return null;
  }

  /// Get video as File (download if it's a URL)
  Future<File?> getVideoAsFile() async {
    try {
      if (newVideo != null) {
        return newVideo;
      } else if (oldVideo != null && DownloadService.isValidUrl(oldVideo!)) {
        return await DownloadService.downloadVideoFromUrl(oldVideo!);
      }
    } catch (e) {
      debugPrint('Error getting video as file: $e');
    }
    return null;
  }

  Future<void> pickVideo(BuildContext context) async {
    final source = await ImagePickerService.showVideoSourceDialog(context: context);
    if (source != null) {
      final videoFile = await ImagePickerService.pickVideo(
        context: context,
        source: source,
        maxDuration: const Duration(minutes: 10),
      );
      if (videoFile != null) {
        newVideo = videoFile;
        // Clear old video when new one is selected
        oldVideo = null;
      }
    }
  }

  void removeVideo() {
    newVideo = null;
    oldVideo = null;
  }

  // Color management methods
  void toggleColor(DColor color, String type) {
    // Check if color is already selected for this specific type
    final existingIndex = _newSelectedColors.indexWhere((e) => e.color == color && e.type == type);

    if (existingIndex != -1) {
      // Remove the color for this specific type
      _newSelectedColors.removeAt(existingIndex);
      _colorImages.remove(color.id);
    } else {
      // Add the color for this specific type
      _newSelectedColors.add(SelectedColor(color: color, images: [], type: type));
      _colorImages[color.id!] = [];
    }
  }

  bool isColorSelected(DColor color, String type) {
    return _newSelectedColors.any((e) => e.color == color && e.type == type);
  }

  Future<void> pickColorImages(BuildContext context, SelectedColor color) async {
    final newImages = await ImagePickerService.pickMultipleImages(
      context: context,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );
    if (newImages.isNotEmpty) {
      // Replace old images with new ones
      _colorImages[color.color.id!] = newImages;
      // Update the color's images list
      final index = _newSelectedColors.indexWhere((c) => c.color == color.color && c.type == color.type);
      if (index != -1) {
        _newSelectedColors[index] = SelectedColor(
          color: color.color,
          images: newImages,
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
      final index = _newSelectedColors.indexWhere((c) => c.color == color.color && c.type == color.type);
      if (index != -1) {
        _newSelectedColors[index] = SelectedColor(
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

  /// Get old color images as URLs for display
  List<String> getOldColorImages(SelectedColor color) {
    final oldCarColor = _oldSelectedColors.firstWhere(
      (carColor) => carColor?.color?.id == color.color.id && carColor?.type == color.type,
      orElse: () => null,
    );
    return oldCarColor?.images ?? [];
  }

  /// Check if color has old images (URLs)
  bool hasOldColorImages(SelectedColor color) {
    final oldImages = getOldColorImages(color);
    return oldImages.isNotEmpty && color.images.isEmpty;
  }

  /// Remove old color image by URL
  void removeOldColorImage(SelectedColor color, String imageUrl) {
    final colorKey = '${color.color.id}_${color.type}';
    if (!_removedOldColorImages.containsKey(colorKey)) {
      _removedOldColorImages[colorKey] = [];
    }
    _removedOldColorImages[colorKey]!.add(imageUrl);
  }

  /// Get available old color images (excluding removed ones)
  List<String> getAvailableOldColorImages(SelectedColor color) {
    final allOldImages = getOldColorImages(color);
    final colorKey = '${color.color.id}_${color.type}';
    final removedImages = _removedOldColorImages[colorKey] ?? [];

    return allOldImages.where((url) => !removedImages.contains(url)).toList();
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

  Future<void> editCar({
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
      // Get cover image (download if it's a URL)
      final coverImageFile = await getCoverImageAsFile();
      if (coverImageFile == null) {
        Toast.e('Please select a cover image');
        return;
      }

      // Get all images as files (download URLs if needed)
      var allImagesFiles = <File>[];
      try {
        allImagesFiles = await getAllImagesAsFiles();
      } catch (e) {
        debugPrint('Error processing car images: $e');
        // Continue with empty images list if there's an error
        allImagesFiles = [];
      }

      // Get video as file (download if it's a URL)
      File? videoFile;
      try {
        videoFile = await getVideoAsFile();
      } catch (e) {
        debugPrint('Error processing video: $e');
        // Continue without video if there's an error
        videoFile = null;
      }

      // Get colors with downloaded images
      var colorsWithImages = <SelectedColor>[];
      try {
        colorsWithImages = await getColorsWithDownloadedImages();
      } catch (e) {
        debugPrint('Error processing color images: $e');
        // Continue with empty colors list if there's an error
        colorsWithImages = [];
      }

      final response = await DealerApis().updateCar(
        carId: carId ?? 0,
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
        mileage: mileageKm?.toLowerCase() ?? '',
        downPayment: downPayment.text,
        horsepower: horsepower.text,
        doors: doors.text,
        seats: seats.text,
        coverImage: coverImageFile,
        images: allImagesFiles,
        video: videoFile,
        colors: colorsWithImages,
      );

      if (response.isSuccess) {
        Toast.s('Car updated successfully');
        clearAll();
        Navigator.of(context).pop();
      } else {
        isError = true;
        Toast.e(response.message ?? 'Failed to update car');
        debugPrint('error: ${response.message}');
      }
    } catch (e) {
      isError = true;
      Toast.e('Error: ${e.toString()}');
      debugPrint('error: ${e.toString()}');
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> refresh() async {
    await fetchAllData();
  }

  void clearAll() {
    try {
      // Reset dropdown selections
      _selectedCategory.value = null;
      _selectedBrand.value = null;
      _selectedBrandModel.value = null;
      _selectedBodyType.value = null;
      _transmission.value = null;
      _fuelType.value = null;
      _drivetrain.value = null;
      _condition.value = null;

      // Reset text controllers with default values
      year = TextEditingController(text: '1980');
      price = TextEditingController(text: '0');
      mileageKm = null;

      horsepower = TextEditingController(text: '0');
      doors = TextEditingController(text: '0');
      seats = TextEditingController(text: '0');

      // Clear text controllers
      titleController.clear();
      descriptionController.clear();
      vinController.clear();
      plateNumberController.clear();

      // Reset media
      newCoverImage = null;
      oldCoverImage = null;
      _newImages.clear();
      _allImages.clear();
      _oldImages.clear();
      newVideo = null;
      oldVideo = null;

      // Reset colors
      _newSelectedColors.clear();
      _oldSelectedColors.clear();
      _colorImages.clear();
      _removedOldColorImages.clear();
      _removedOldCarImages.clear();
    } catch (e) {
      debugPrint('Error in clearAll: $e');
    }
  }

  void reset() {
    isLoading = true;
    isError = false;
    isRefreshing = false;
    _allBrands.clear();
    _allBrandModels.clear();
    _allCarCategories.clear();
    _allCarBodyTypes.clear();
    _allCarColors.clear();
  }
}
