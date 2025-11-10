import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api/cars/cars_apis.dart';
import '../../../api/dealers/dealer_apis.dart';
import '../../../model/cars/brand_model/brand_model.dart';
import '../../../model/cars/car/car.dart';
import '../../../model/cars/car_body_type/car_body_type.dart';
import '../../../model/cars/car_brand/car_brand.dart';
import '../../../model/cars/car_category/car_category.dart';
import '../../../model/cars/dealer/dealer.dart';

class MyCarsController extends GetxController {
  final RxBool _isLoading = true.obs;
  final RxBool _isError = false.obs;
  final RxBool _isRefreshing = false.obs;
  final RxBool _isAdvancedFiltersExpanded = false.obs;
  final RxList<Car> _myActiveCars = <Car>[].obs;
  final RxList<Car> _myInactiveCars = <Car>[].obs;
  final RxList<Dealer> _dealers = <Dealer>[].obs;
  final RxList<CarBrand> _brands = <CarBrand>[].obs;
  final RxInt _myActiveCarsCount = 0.obs;
  final RxInt _myInactiveCarsCount = 0.obs;
  final RxInt _dealersCount = 0.obs;
  final RxInt _brandsCount = 0.obs;

  // Pagination variables
  final RxInt _activeCarsCurrentPage = 1.obs;
  final RxInt _inactiveCarsCurrentPage = 1.obs;
  final RxBool _isLoadingMoreActiveCars = false.obs;
  final RxBool _isLoadingMoreInactiveCars = false.obs;
  final RxBool _hasMoreActiveCars = true.obs;
  final RxBool _hasMoreInactiveCars = true.obs;
  final RxInt _activeCarsPerPage = 10.obs;
  final RxInt _inactiveCarsPerPage = 10.obs;

  // Getters for private variables
  bool get isLoading => _isLoading.value;
  bool get isError => _isError.value;
  bool get isRefreshing => _isRefreshing.value;
  bool get isAdvancedFiltersExpanded => _isAdvancedFiltersExpanded.value;
  set isAdvancedFiltersExpanded(bool value) =>
      _isAdvancedFiltersExpanded.value = value;

  // Pagination getters
  int get activeCarsCurrentPage => _activeCarsCurrentPage.value;
  int get inactiveCarsCurrentPage => _inactiveCarsCurrentPage.value;
  bool get isLoadingMoreActiveCars => _isLoadingMoreActiveCars.value;
  bool get isLoadingMoreInactiveCars => _isLoadingMoreInactiveCars.value;
  bool get hasMoreActiveCars => _hasMoreActiveCars.value;
  bool get hasMoreInactiveCars => _hasMoreInactiveCars.value;
  int get activeCarsPerPage => _activeCarsPerPage.value;
  int get inactiveCarsPerPage => _inactiveCarsPerPage.value;
  List<Car> get myActiveCars => _myActiveCars;
  List<Car> get myInactiveCars => _myInactiveCars;
  List<Dealer> get dealers => _dealers;
  List<CarBrand> get brands => _brands;
  int get myActiveCarsCount => _myActiveCarsCount.value;
  int get myInactiveCarsCount => _myInactiveCarsCount.value;
  int get dealersCount => _dealersCount.value;
  int get brandsCount => _brandsCount.value;

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

  set allCarCategories(List<CarCategory> value) =>
      _allCarCategories.value = value;
  set allDealers(List<Dealer> value) => _allDealers.value = value;
  set allBrands(List<CarBrand> value) => _allBrands.value = value;
  set allBrandModels(List<BrandModel> value) => _allBrandModels.value = value;
  set allBodyTypes(List<CarBodyType> value) => _allBodyTypes.value = value;

  // Setters for private variables
  set isLoading(bool value) => _isLoading.value = value;
  set isError(bool value) => _isError.value = value;
  set isRefreshing(bool value) => _isRefreshing.value = value;
  set myActiveCars(List<Car> value) => _myActiveCars.value = value;
  set myInactiveCars(List<Car> value) => _myInactiveCars.value = value;
  set dealers(List<Dealer> value) => _dealers.value = value;
  set brands(List<CarBrand> value) => _brands.value = value;
  set myActiveCarsCount(int value) => _myActiveCarsCount.value = value;
  set myInactiveCarsCount(int value) => _myInactiveCarsCount.value = value;
  set dealersCount(int value) => _dealersCount.value = value;
  set brandsCount(int value) => _brandsCount.value = value;

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

  set selectedCategories(List<CarCategory> value) =>
      _selectedCategories.value = value;
  set selectedBrands(List<CarBrand> value) => _selectedBrands.value = value;

  set selectedBrandModels(List<BrandModel> value) =>
      _selectedBrandModels.value = value;
  set selectedBodyTypes(List<CarBodyType> value) =>
      _selectedBodyTypes.value = value;
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

  Future<void> fetchCars({
    bool isRefresh = false,
  }) async {
    try {
      isError = false;

      isLoading = true;
      isRefreshing = false;

      await Future.wait([
        fetchMyActiveCars(isRefresh: isRefresh),
        fetchMyInactiveCars(isRefresh: isRefresh),
      ]);
    } catch (e) {
      isError = true;
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchMyInactiveCars({
    bool isRefresh = false,
    bool loadMore = false,
  }) async {
    try {
      isError = false;

      if (!loadMore) {
        isLoading = true;
        _inactiveCarsCurrentPage.value = 1;
        _hasMoreInactiveCars.value = true;
      } else {
        _isLoadingMoreInactiveCars.value = true;
      }
      isRefreshing = false;

      final response = await DealerApis().getCars(
        query: query.value.text.isEmpty ? null : query.value.text,
        categoryId: selectedCategories.isEmpty
            ? null
            : selectedCategories.map((e) => e.id).join(','),
        brandId: selectedBrands.isEmpty
            ? null
            : selectedBrands.map((e) => e.id).join(','),
        brandModelId: selectedBrandModels.isEmpty
            ? null
            : selectedBrandModels.map((e) => e.id).join(','),
        bodyTypeId: selectedBodyTypes.isEmpty
            ? null
            : selectedBodyTypes.map((e) => e.id).join(','),
        transmission: _transmission.isEmpty
            ? null
            : _transmission.map((e) => e.toLowerCase()).join(','),
        fuelType: _fuelType.isEmpty
            ? null
            : _fuelType.map((e) => e.toLowerCase()).join(','),
        drivetrain: _drivetrain.isEmpty
            ? null
            : _drivetrain.map((e) => e.toLowerCase()).join(','),
        condition: _condition.isEmpty
            ? null
            : _condition.map((e) => e.toLowerCase()).join(','),
        year: year.value,
        yearFrom: yearFrom.value,
        yearTo: yearTo.value,
        price: price.value,
        priceMin: priceMin.value,
        priceMax: priceMax.value,
        horsepower: horsepower.value,
        horsepowerMin: horsepowerMin.value,
        horsepowerMax: horsepowerMax.value,
        doors: doors.value,
        seats: seats.value,
        sortAndOrderBy: selectedSortAndOrderBy.value,
        status: false,
        page: loadMore ? _inactiveCarsCurrentPage.value : 1,
        perPage: _inactiveCarsPerPage.value,
      );

      if (response.isSuccess) {
        final newCars = response.data ?? [];
        if (loadMore) {
          myInactiveCars.addAll(newCars);
        } else {
          myInactiveCars = newCars;
        }
        myInactiveCarsCount = response.meta?.total ?? 0;

        // Check if there are more pages
        if (newCars.length < _inactiveCarsPerPage.value) {
          _hasMoreInactiveCars.value = false;
        } else {
          _inactiveCarsCurrentPage.value++;
        }
      } else {
        isError = true;
      }
    } catch (e) {
      isError = true;
    } finally {
      isLoading = false;
      _isLoadingMoreInactiveCars.value = false;
    }
  }

  Future<void> fetchMyActiveCars({
    bool isRefresh = false,
    bool loadMore = false,
  }) async {
    try {
      isError = false;

      if (!loadMore) {
        isLoading = true;
        _activeCarsCurrentPage.value = 1;
        _hasMoreActiveCars.value = true;
      } else {
        _isLoadingMoreActiveCars.value = true;
      }
      isRefreshing = false;

      final response = await DealerApis().getCars(
        query: query.value.text.isEmpty ? null : query.value.text,
        categoryId: selectedCategories.isEmpty
            ? null
            : selectedCategories.map((e) => e.id).join(','),
        brandId: selectedBrands.isEmpty
            ? null
            : selectedBrands.map((e) => e.id).join(','),
        brandModelId: selectedBrandModels.isEmpty
            ? null
            : selectedBrandModels.map((e) => e.id).join(','),
        bodyTypeId: selectedBodyTypes.isEmpty
            ? null
            : selectedBodyTypes.map((e) => e.id).join(','),
        transmission: _transmission.isEmpty
            ? null
            : _transmission.map((e) => e.toLowerCase()).join(','),
        fuelType: _fuelType.isEmpty
            ? null
            : _fuelType.map((e) => e.toLowerCase()).join(','),
        drivetrain: _drivetrain.isEmpty
            ? null
            : _drivetrain.map((e) => e.toLowerCase()).join(','),
        condition: _condition.isEmpty
            ? null
            : _condition.map((e) => e.toLowerCase()).join(','),
        year: year.value,
        yearFrom: yearFrom.value,
        yearTo: yearTo.value,
        price: price.value,
        priceMin: priceMin.value,
        priceMax: priceMax.value,
        horsepower: horsepower.value,
        horsepowerMin: horsepowerMin.value,
        horsepowerMax: horsepowerMax.value,
        doors: doors.value,
        seats: seats.value,
        sortAndOrderBy: selectedSortAndOrderBy.value,
        status: true,
        page: loadMore ? _activeCarsCurrentPage.value : 1,
        perPage: _activeCarsPerPage.value,
      );

      if (response.isSuccess) {
        final newCars = response.data ?? [];
        if (loadMore) {
          myActiveCars.addAll(newCars);
        } else {
          myActiveCars = newCars;
        }
        myActiveCarsCount = response.meta?.total ?? 0;

        // Check if there are more pages
        if (newCars.length < _activeCarsPerPage.value) {
          _hasMoreActiveCars.value = false;
        } else {
          _activeCarsCurrentPage.value++;
        }
      } else {
        isError = true;
      }
    } catch (e) {
      isError = true;
    } finally {
      isLoading = false;
      _isLoadingMoreActiveCars.value = false;
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

  Future<void> toggleCarStatus(Car car) async {
    try {
      isError = false;
      isLoading = true;

      final response = await DealerApis().updateCarStatus(
        carId: car.id.toString(),
        status: !(car.isActive ?? false) ? 1 : 0,
      );

      if (response.isSuccess) {
        // Refresh both active and inactive car lists
        await fetchCars(isRefresh: true);
      } else {
        isError = true;
      }
    } catch (e) {
      debugPrint('Error toggling car status: $e');
      isError = true;
    } finally {
      isLoading = false;
    }
  }

  Future<void> deleteCar(Car car) async {
    try {
      isError = false;
      isLoading = true;

      final response = await DealerApis().deleteCar(carId: car.id!);

      if (response.isSuccess) {
        await fetchCars(isRefresh: true);
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
    await fetchMyActiveCars(isRefresh: true);
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
    horsepower.value = null;
    horsepowerMin.value = null;
    horsepowerMax.value = null;
    doors.value = null;
    seats.value = null;
    selectedSortAndOrderBy.value = null;
    _isAdvancedFiltersExpanded.value = false;
  }

  void reset() {
    isLoading = true;
    isError = false;
    isRefreshing = false;
    myActiveCars.clear();
    myInactiveCars.clear();
    dealers.clear();
    brands.clear();
    allBrandModels.clear();
    allBodyTypes.clear();
    selectedCategories.clear();

    // Reset pagination
    _activeCarsCurrentPage.value = 1;
    _inactiveCarsCurrentPage.value = 1;
    _hasMoreActiveCars.value = true;
    _hasMoreInactiveCars.value = true;
    _isLoadingMoreActiveCars.value = false;
    _isLoadingMoreInactiveCars.value = false;
  }

  // Pagination methods
  Future<void> loadMoreActiveCars() async {
    if (hasMoreActiveCars && !isLoadingMoreActiveCars) {
      await fetchMyActiveCars(loadMore: true);
    }
  }

  Future<void> loadMoreInactiveCars() async {
    if (hasMoreInactiveCars && !isLoadingMoreInactiveCars) {
      await fetchMyInactiveCars(loadMore: true);
    }
  }
}
