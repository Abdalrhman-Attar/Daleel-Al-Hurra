import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../model/general/language/language.dart';
import '../services/languages_service.dart';
import '../utils/constants/enums.dart';

class PreferencesStore extends GetxService {
  static const _keyIsGuest = 'isGuest';
  static const _keyIsLoggedIn = 'isLoggedIn';
  static const _keyCurrentTheme = 'currentTheme';
  static const _keyIsResevingNotification = 'isReceivingNotification';
  static const _keySeenOnboarding = 'seenOnboarding';
  static const _keyLanguage = 'language';
  static const _keyAppInterface = 'appInterface';
  static const _keyIsFirstTime = 'isFirstTime';

  final GetStorage _storage = GetStorage();

  final RxBool _isGuest = false.obs;
  final RxBool _isLoggedIn = false.obs;
  final Rx<ThemeMode> _currentTheme = ThemeMode.system.obs;
  final RxBool _isReceivingNotification = false.obs;
  final RxBool _seenOnboarding = false.obs;
  final Rx<Language> _language = const Language(
          id: 0, name: 'English', locale: 'en', direction: 'ltr', flag: '🇺🇸')
      .obs;
  final RxString _themeMode = 'system'.obs;
  final Rx<AppInterface> _appInterface = AppInterface.visitAmman.obs;
  final RxBool _isFirstTime = true.obs;

  Future<PreferencesStore> init() async {
    await GetStorage.init();

    _isGuest.value = _storage.read(_keyIsGuest) ?? true;
    _isLoggedIn.value = _storage.read(_keyIsLoggedIn) ?? false;
    _themeMode.value = _storage.read(_keyCurrentTheme) ?? 'system';
    _isReceivingNotification.value =
        _storage.read(_keyIsResevingNotification) ?? true;
    _seenOnboarding.value = _storage.read(_keySeenOnboarding) ?? false;
    _language.value = _storage.read(_keyLanguage) != null
        ? Language.fromJson(_storage.read(_keyLanguage))
        : Get.find<LanguagesService>().defaultLanguage;
    _appInterface.value = AppInterface.values.firstWhere(
      (e) => e.name == _storage.read(_keyAppInterface),
      orElse: () => AppInterface.visitAmman,
    );
    _isFirstTime.value = _storage.read(_keyIsFirstTime) ?? true;

    ever(_isGuest, (val) => _storage.write(_keyIsGuest, val));
    ever(_isLoggedIn, (val) => _storage.write(_keyIsLoggedIn, val));
    ever(_currentTheme, (val) {
      _storage.write(_keyCurrentTheme, val.name);
      Get.changeThemeMode(val);
    });
    ever(_isReceivingNotification,
        (val) => _storage.write(_keyIsResevingNotification, val));
    ever(_seenOnboarding, (val) => _storage.write(_keySeenOnboarding, val));
    ever(_language, (val) => _storage.write(_keyLanguage, val.toJson()));
    ever(_appInterface, (val) => _storage.write(_keyAppInterface, val.name));
    ever(_isFirstTime, (val) => _storage.write(_keyIsFirstTime, val));

    return this;
  }

  bool get isGuest => _isGuest.value;
  set isGuest(bool val) => _isGuest.value = val;

  bool get isLoggedIn => _isLoggedIn.value;
  set isLoggedIn(bool val) => _isLoggedIn.value = val;

  ThemeMode get currentTheme => _currentTheme.value;
  set currentTheme(ThemeMode mode) {
    _currentTheme.value = mode;
    Get.changeThemeMode(mode);
  }

  bool get isReceivingNotification => _isReceivingNotification.value;
  set isReceivingNotification(bool val) => _isReceivingNotification.value = val;

  bool get seenOnboarding => _seenOnboarding.value;
  set seenOnboarding(bool val) => _seenOnboarding.value = val;

  Language get language => _language.value;
  set language(Language val) => _language.value = val;

  AppInterface get appInterface => _appInterface.value;
  set appInterface(AppInterface val) => _appInterface.value = val;

  bool get isFirstTime => _isFirstTime.value;
  set isFirstTime(bool val) => _isFirstTime.value = val;
}
