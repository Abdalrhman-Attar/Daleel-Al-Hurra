import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api/cars/cars_apis.dart';
import '../../../model/cars/brand_model/brand_model.dart';
import '../../../model/cars/car/car.dart';
import '../../../model/cars/car_body_type/car_body_type.dart';
import '../../../model/cars/car_brand/car_brand.dart';
import '../../../model/cars/car_category/car_category.dart';
import '../../../model/cars/dealer/dealer.dart';

List<String> conditions = [
  'New',
  'Used',
  'Certified',
];

List<String> transmissions = [
  'Manual',
  'Automatic',
  'Other',
];

List<String> fuelTypes = [
  'Petrol',
  'Diesel',
  'Hybrid',
  'Electric',
  'Other',
];

List<String> drivetrains = [
  'FWD',
  'RWD',
  'AWD',
  '4WD',
  'Other',
];

Map<String, String> sortAndOrderBy = {
  'price_asc': '💰 Lowest Price First',
  'price_desc': '💎 Highest Price First',
  'year_desc': '🆕 Newest First',
  'year_asc': '📅 Oldest First',
};

class SearchController extends GetxController {
  final RxBool _isLoading = true.obs;
  final RxBool _isError = false.obs;
  final RxBool _isRefreshing = false.obs;
  final RxList<Car> _cars = <Car>[].obs;
  final RxList<Dealer> _dealers = <Dealer>[].obs;
  final RxList<CarBrand> _brands = <CarBrand>[].obs;
  final RxInt _carsCount = 0.obs;
  final RxInt _dealersCount = 0.obs;
  final RxInt _brandsCount = 0.obs;
  final RxBool _isAdvancedFiltersExpanded = false.obs;

  final Rx<int?> _page = 1.obs;
  final Rx<int?> _perPage = 10.obs;
  final RxBool _hasMorePages = true.obs;
  final RxBool _isLoadingMore = false.obs;

  // Getters for private variables
  int? get page => _page.value;
  int? get perPage => _perPage.value;
  bool get isLoading => _isLoading.value;
  bool get isError => _isError.value;
  bool get isRefreshing => _isRefreshing.value;
  bool get hasMorePages => _hasMorePages.value;
  bool get isLoadingMore => _isLoadingMore.value;
  List<Car> get cars => _cars;
  List<Dealer> get dealers => _dealers;
  List<CarBrand> get brands => _brands;
  int get carsCount => _carsCount.value;
  int get dealersCount => _dealersCount.value;
  int get brandsCount => _brandsCount.value;
  bool get isAdvancedFiltersExpanded => _isAdvancedFiltersExpanded.value;
  final RxList<CarCategory> _allCarCategories = <CarCategory>[].obs;
  final RxList<Dealer> _allDealers = <Dealer>[].obs;
  final RxList<CarBrand> _allBrands = <CarBrand>[].obs;
  final RxList<BrandModel> _allBrandModels = <BrandModel>[].obs;
  final RxList<CarBodyType> _allBodyTypes = <CarBodyType>[].obs;

  RxList<CarCategory> get allCarCategories => _allCarCategories;
  RxList<Dealer> get allDealers => _allDealers;
  RxList<CarBrand> get allBrands => _allBrands;
  RxList<BrandModel> get allBrandModels => _allBrandModels;
  RxList<CarBodyType> get allBodyTypes => _allBodyTypes;

  set page(int? value) => _page.value = value;
  set perPage(int? value) => _perPage.value = value;
  set hasMorePages(bool value) => _hasMorePages.value = value;
  set isLoadingMore(bool value) => _isLoadingMore.value = value;

  set allCarCategories(List<CarCategory> value) => _allCarCategories.value = value;
  set allDealers(List<Dealer> value) => _allDealers.value = value;
  set allBrands(List<CarBrand> value) => _allBrands.value = value;
  set allBrandModels(List<BrandModel> value) => _allBrandModels.value = value;
  set allBodyTypes(List<CarBodyType> value) => _allBodyTypes.value = value;

  // Setters for private variables
  set isLoading(bool value) => _isLoading.value = value;
  set isError(bool value) => _isError.value = value;
  set isRefreshing(bool value) => _isRefreshing.value = value;
  set cars(List<Car> value) => _cars.value = value;
  set dealers(List<Dealer> value) => _dealers.value = value;
  set brands(List<CarBrand> value) => _brands.value = value;
  set carsCount(int value) => _carsCount.value = value;
  set dealersCount(int value) => _dealersCount.value = value;
  set brandsCount(int value) => _brandsCount.value = value;
  set isAdvancedFiltersExpanded(bool value) => _isAdvancedFiltersExpanded.value = value;
  // Car filters - make sure these are the ONLY declarations
  Rx<TextEditingController> query = TextEditingController().obs;
  final RxList<CarCategory> _selectedCategories = <CarCategory>[].obs;
  final RxList<CarBrand> _selectedBrands = <CarBrand>[].obs;
  final RxList<BrandModel> _selectedBrandModels = <BrandModel>[].obs;
  final RxList<CarBodyType> _selectedBodyTypes = <CarBodyType>[].obs;
  final RxList<Dealer> _selectedDealers = <Dealer>[].obs;

  // These are RxList - no other getters should exist for these names
  final RxList<String> _transmission = <String>[].obs;
  final RxList<String> _fuelType = <String>[].obs;
  final RxList<String> _drivetrain = <String>[].obs;
  final RxList<String> _condition = <String>[].obs;

  RxList<CarCategory> get selectedCategories => _selectedCategories;
  RxList<CarBrand> get selectedBrands => _selectedBrands;
  RxList<BrandModel> get selectedBrandModels => _selectedBrandModels;
  RxList<CarBodyType> get selectedBodyTypes => _selectedBodyTypes;
  RxList<Dealer> get selectedDealers => _selectedDealers;

  RxList<String> get transmission => _transmission;
  RxList<String> get fuelType => _fuelType;
  RxList<String> get drivetrain => _drivetrain;
  RxList<String> get condition => _condition;

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

  set selectedCategories(List<CarCategory> value) => _selectedCategories.value = value;
  set selectedBrands(List<CarBrand> value) => _selectedBrands.value = value;

  set selectedBrandModels(List<BrandModel> value) => _selectedBrandModels.value = value;
  set selectedBodyTypes(List<CarBodyType> value) => _selectedBodyTypes.value = value;
  set selectedDealers(List<Dealer> value) => _selectedDealers.value = value;

  set transmission(List<String> value) => _transmission.value = value;
  set fuelType(List<String> value) => _fuelType.value = value;
  set drivetrain(List<String> value) => _drivetrain.value = value;
  set condition(List<String> value) => _condition.value = value;
  // Rest of your properties...
  Rx<int?> year = Rx<int?>(null);
  Rx<int?> yearFrom = Rx<int?>(null);
  Rx<int?> yearTo = Rx<int?>(null);
  Rx<double?> price = Rx<double?>(null);
  Rx<double?> priceMax = Rx<double?>(null);
  Rx<double?> priceMin = Rx<double?>(null);
  Rx<int?> mileageKm = Rx<int?>(null);
  Rx<int?> mileageMin = Rx<int?>(null);
  Rx<int?> mileageMax = Rx<int?>(null);
  Rx<int?> engineCc = Rx<int?>(null);
  Rx<int?> engineCcMin = Rx<int?>(null);
  Rx<int?> engineCcMax = Rx<int?>(null);
  Rx<int?> horsepower = Rx<int?>(null);
  Rx<int?> horsepowerMin = Rx<int?>(null);
  Rx<int?> horsepowerMax = Rx<int?>(null);
  Rx<int?> doors = Rx<int?>(null);
  Rx<int?> seats = Rx<int?>(null);
  Rx<String?> selectedSortAndOrderBy = Rx<String?>(null);

  // Dealer filters
  Rx<TextEditingController> dealerName = TextEditingController().obs;

  // Brand filters
  Rx<TextEditingController> brandName = TextEditingController().obs;

  Future<void> fetchAllData() async {
    final carCategoryResponse = await CarsApis().getCarCategories();
    final dealerResponse = await CarsApis().getDealers();
    final brandResponse = await CarsApis().getCarBrands();
    final bodyTypeResponse = await CarsApis().getCarBodyTypes();

    _allCarCategories.value = carCategoryResponse.data ?? [];
    _allDealers.value = dealerResponse.data ?? [];
    _allBrands.value = brandResponse.data ?? [];
    _allBodyTypes.value = bodyTypeResponse.data ?? [];
  }

  Future<void> loadMoreCars() async {
    if (!hasMorePages || isLoadingMore) return;

    isLoadingMore = true;
    page = (page ?? 1) + 1;

    try {
      final response = await CarsApis().getCars(
        query: query.value.text.isEmpty ? null : query.value.text,
        categoryId: selectedCategories.isEmpty ? null : selectedCategories.map((e) => e.id).join(','),
        dealerId: selectedDealers.isEmpty ? null : selectedDealers.map((e) => e.id).join(','),
        brandId: selectedBrands.isEmpty ? null : selectedBrands.map((e) => e.id).join(','),
        brandModelId: selectedBrandModels.isEmpty ? null : selectedBrandModels.map((e) => e.id).join(','),
        bodyTypeId: selectedBodyTypes.isEmpty ? null : selectedBodyTypes.map((e) => e.id).join(','),
        transmission: _transmission.isEmpty ? null : _transmission.map((e) => e.toLowerCase()).join(','),
        fuelType: _fuelType.isEmpty ? null : _fuelType.map((e) => e.toLowerCase()).join(','),
        drivetrain: _drivetrain.isEmpty ? null : _drivetrain.map((e) => e.toLowerCase()).join(','),
        condition: _condition.isEmpty ? null : _condition.map((e) => e.toLowerCase()).join(','),
        year: year.value,
        yearFrom: yearFrom.value,
        yearTo: yearTo.value,
        price: price.value,
        priceMin: priceMin.value,
        priceMax: priceMax.value,
        mileageKm: mileageKm.value,
        mileageMin: mileageMin.value,
        mileageMax: mileageMax.value,
        engineCc: engineCc.value,
        engineCcMin: engineCcMin.value,
        engineCcMax: engineCcMax.value,
        horsepower: horsepower.value,
        horsepowerMin: horsepowerMin.value,
        horsepowerMax: horsepowerMax.value,
        doors: doors.value,
        seats: seats.value,
        sortAndOrderBy: selectedSortAndOrderBy.value,
        perPage: perPage,
        page: page,
      );

      if (response.isSuccess) {
        final newCars = response.data ?? [];
        if (newCars.length < (perPage ?? 10)) {
          hasMorePages = false;
        }
        cars.addAll(newCars);
      }
    } catch (e) {
      isError = true;
    } finally {
      isLoadingMore = false;
    }
  }

  Future<void> fetchCars({
    bool isRefresh = false,
  }) async {
    try {
      isError = false;

      if (isRefresh) {
        isRefreshing = true;
        page = 1;
        hasMorePages = true;
        cars.clear();
      } else {
        isLoading = true;
        page = 1;
        hasMorePages = true;
        cars.clear();
      }

      final response = await CarsApis().getCars(
        query: query.value.text.isEmpty ? null : query.value.text,
        categoryId: selectedCategories.isEmpty ? null : selectedCategories.map((e) => e.id).join(','),
        dealerId: selectedDealers.isEmpty ? null : selectedDealers.map((e) => e.id).join(','),
        brandId: selectedBrands.isEmpty ? null : selectedBrands.map((e) => e.id).join(','),
        brandModelId: selectedBrandModels.isEmpty ? null : selectedBrandModels.map((e) => e.id).join(','),
        bodyTypeId: selectedBodyTypes.isEmpty ? null : selectedBodyTypes.map((e) => e.id).join(','),
        transmission: _transmission.isEmpty ? null : _transmission.map((e) => e.toLowerCase()).join(','),
        fuelType: _fuelType.isEmpty ? null : _fuelType.map((e) => e.toLowerCase()).join(','),
        drivetrain: _drivetrain.isEmpty ? null : _drivetrain.map((e) => e.toLowerCase()).join(','),
        condition: _condition.isEmpty ? null : _condition.map((e) => e.toLowerCase()).join(','),
        year: year.value,
        yearFrom: yearFrom.value,
        yearTo: yearTo.value,
        price: price.value,
        priceMin: priceMin.value,
        priceMax: priceMax.value,
        mileageKm: mileageKm.value,
        mileageMin: mileageMin.value,
        mileageMax: mileageMax.value,
        engineCc: engineCc.value,
        engineCcMin: engineCcMin.value,
        engineCcMax: engineCcMax.value,
        horsepower: horsepower.value,
        horsepowerMin: horsepowerMin.value,
        horsepowerMax: horsepowerMax.value,
        doors: doors.value,
        seats: seats.value,
        sortAndOrderBy: selectedSortAndOrderBy.value,
        perPage: perPage,
        page: page,
      );

      if (response.isSuccess) {
        final newCars = response.data ?? [];
        cars = newCars;
        carsCount = response.meta?.total ?? 0;

        // Check if we have more pages
        if (newCars.length < (perPage ?? 10)) {
          hasMorePages = false;
        }
      } else {
        isError = true;
      }
    } catch (e) {
      isError = true;
    } finally {
      isLoading = false;
      isRefreshing = false;
    }
  }

  Future<void> fetchDealers({
    bool isRefresh = false,
  }) async {
    try {
      isError = false;

      isLoading = true;
      isRefreshing = false;

      final response = await CarsApis().getDealers(
        name: dealerName.value.text,
      );

      if (response.isSuccess) {
        dealers = response.data ?? [];
        dealersCount = response.meta?.total ?? 0;
      } else {
        isError = true;
      }
    } catch (e) {
      isError = true;
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchBrands({
    bool isRefresh = false,
  }) async {
    try {
      isError = false;

      isLoading = true;
      isRefreshing = false;

      final response = await CarsApis().getCarBrands(
        name: brandName.value.text,
      );

      if (response.isSuccess) {
        brands = response.data ?? [];
        brandsCount = response.meta?.total ?? 0;
      } else {
        isError = true;
      }
    } catch (e) {
      isError = true;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> refresh() async {
    await fetchCars(isRefresh: true);
    await fetchDealers(isRefresh: true);
    await fetchBrands(isRefresh: true);
  }

  void clearFilters() {
    query.value.clear();
    dealerName.value.clear();
    brandName.value.clear();
    selectedCategories.clear();
    selectedDealers.clear();
    selectedBrands.clear();
    selectedBrandModels.clear();
    selectedBodyTypes.clear();
    _transmission.clear();
    _fuelType.clear();
    _drivetrain.clear();
    _condition.clear();
    year.value = null;
    yearFrom.value = null;
    yearTo.value = null;
    price.value = null;
    priceMin.value = null;
    priceMax.value = null;
    mileageKm.value = null;
    mileageMin.value = null;
    mileageMax.value = null;
    engineCc.value = null;
    engineCcMin.value = null;
    engineCcMax.value = null;
    horsepower.value = null;
    horsepowerMin.value = null;
    horsepowerMax.value = null;
    doors.value = null;
    seats.value = null;
    selectedSortAndOrderBy.value = null;

    // Reset pagination state
    page = 1;
    hasMorePages = true;
    isLoadingMore = false;
  }

  void reset() {
    isLoading = true;
    isError = false;
    isRefreshing = false;
    cars.clear();
    cars = [];
    dealers.clear();
    dealers = [];
    brands.clear();
    brands = [];
  }
}
