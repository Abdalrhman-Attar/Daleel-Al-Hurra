import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../model/cars/car_brand/car_brand.dart';

class UserDataStore extends GetxService {
  static const _keyId = 'id';
  static const _keyFirstName = 'firstName';
  static const _keyLastName = 'lastName';
  static const _keyPhoneNumber = 'phoneNumber';
  static const _keyPhoneNumberVerified = 'phoneNumberVerified';
  static const _keyProfileImage = 'profileImage';
  static const _keyStoreName = 'storeName';
  static const _keyAddress = 'address';
  static const _keyLatitude = 'latitude';
  static const _keyLongitude = 'longitude';
  static const _keyUserType = 'userType';
  static const _keyStatus = 'status';
  static const _keyBrands = 'brands';
  static const _keyFavoriteDealers = 'favoriteDealers';
  static const _keyFavoriteCars = 'favoriteCars';

  final GetStorage _storage = GetStorage();

  final RxInt _id = 0.obs;
  final RxString _firstName = ''.obs;
  final RxString _lastName = ''.obs;
  final RxString _phoneNumber = ''.obs;
  final RxBool _phoneNumberVerified = false.obs;
  final RxString _profileImage = ''.obs;
  final RxString _storeName = ''.obs;
  final RxString _address = ''.obs;
  final RxString _latitude = ''.obs;
  final RxString _longitude = ''.obs;
  final RxInt _userType = 0.obs;
  final RxBool _status = false.obs;
  final RxList<CarBrand> _brands = <CarBrand>[].obs;
  final RxList<int> _favoriteDealers = <int>[].obs;
  final RxList<int> _favoriteCars = <int>[].obs;

  Future<UserDataStore> init() async {
    await GetStorage.init();

    // Load stored values or default
    _id.value = _storage.read(_keyId) ?? 0;
    _firstName.value = _storage.read(_keyFirstName) ?? '';
    _lastName.value = _storage.read(_keyLastName) ?? '';
    _phoneNumber.value = _storage.read(_keyPhoneNumber) ?? '';
    _phoneNumberVerified.value = _storage.read(_keyPhoneNumberVerified) ?? false;
    _profileImage.value = _storage.read(_keyProfileImage) ?? '';
    _storeName.value = _storage.read(_keyStoreName) ?? '';
    _address.value = _storage.read(_keyAddress) ?? '';
    _latitude.value = _storage.read(_keyLatitude) ?? '';
    _longitude.value = _storage.read(_keyLongitude) ?? '';
    _userType.value = _storage.read(_keyUserType) ?? 0;
    _status.value = _storage.read(_keyStatus) ?? false;

    // Safe casting for List<CarBrand> field
    final brandsData = _storage.read(_keyBrands);
    if (brandsData != null && brandsData is List) {
      try {
        _brands.value = brandsData.map((item) => CarBrand.fromJson(item)).toList();
      } catch (e) {
        _brands.value = [];
      }
    } else {
      _brands.value = [];
    }

    // Safe casting for List<int> fields
    final favoriteDealersData = _storage.read(_keyFavoriteDealers);
    _favoriteDealers.value = favoriteDealersData != null ? List<int>.from(favoriteDealersData) : [];

    final favoriteCarsData = _storage.read(_keyFavoriteCars);
    _favoriteCars.value = favoriteCarsData != null ? List<int>.from(favoriteCarsData) : [];

    // Persist on change
    ever(_id, (val) => _storage.write(_keyId, val));
    ever(_firstName, (val) => _storage.write(_keyFirstName, val));
    ever(_lastName, (val) => _storage.write(_keyLastName, val));
    ever(_phoneNumber, (val) => _storage.write(_keyPhoneNumber, val));
    ever(_phoneNumberVerified, (val) => _storage.write(_keyPhoneNumberVerified, val));
    ever(_profileImage, (val) => _storage.write(_keyProfileImage, val));
    ever(_storeName, (val) => _storage.write(_keyStoreName, val));
    ever(_address, (val) => _storage.write(_keyAddress, val));
    ever(_latitude, (val) => _storage.write(_keyLatitude, val));
    ever(_longitude, (val) => _storage.write(_keyLongitude, val));
    ever(_userType, (val) => _storage.write(_keyUserType, val));
    ever(_status, (val) => _storage.write(_keyStatus, val));
    ever(_brands, (val) => _storage.write(_keyBrands, val.map((brand) => brand.toJson()).toList()));
    ever(_favoriteDealers, (val) => _storage.write(_keyFavoriteDealers, val));
    ever(_favoriteCars, (val) => _storage.write(_keyFavoriteCars, val));

    return this;
  }

  int get id => _id.value;
  set id(int? val) => _id.value = val ?? 0;

  String get firstName => _firstName.value;
  set firstName(String? val) => _firstName.value = val ?? '';

  String get lastName => _lastName.value;
  set lastName(String? val) => _lastName.value = val ?? '';

  String get phoneNumber => _phoneNumber.value;
  set phoneNumber(String? val) => _phoneNumber.value = val ?? '';

  bool get phoneNumberVerified => _phoneNumberVerified.value;
  set phoneNumberVerified(bool? val) => _phoneNumberVerified.value = val ?? false;

  String get profileImage => _profileImage.value;
  set profileImage(String? val) => _profileImage.value = val ?? '';

  String get storeName => _storeName.value;
  set storeName(String? val) => _storeName.value = val ?? '';

  String get address => _address.value;
  set address(String? val) => _address.value = val ?? '';

  String get latitude => _latitude.value;
  set latitude(String? val) => _latitude.value = val ?? '';

  String get longitude => _longitude.value;
  set longitude(String? val) => _longitude.value = val ?? '';

  int get userType => _userType.value;
  set userType(int? val) => _userType.value = val ?? 0;

  bool get status => _status.value;
  set status(bool? val) => _status.value = val ?? false;

  List<CarBrand> get brands => _brands;
  set brands(List<CarBrand>? val) => _brands.value = val ?? [];

  List<int> get favoriteDealers => _favoriteDealers;
  set favoriteDealers(List<int>? val) => _favoriteDealers.value = val ?? [];

  List<int> get favoriteCars => _favoriteCars;
  set favoriteCars(List<int>? val) => _favoriteCars.value = val ?? [];

  void clear() {
    id = 0;
    firstName = '';
    lastName = '';
    phoneNumber = '';
    phoneNumberVerified = false;
    profileImage = '';
    storeName = '';
    address = '';
    latitude = '';
    longitude = '';
    userType = 0;
    status = false;
    brands = [];
    favoriteDealers = [];
    favoriteCars = [];
    _storage.erase();
  }
}
