import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/general/language/language.dart';
import '../../services/languages_service.dart';
import '../../services/translation_service.dart';
import '../../splash_screen.dart';
import '../../stores/preferences_store.dart';

class LocaleController extends GetxController {
  final Rx<Language> _currentLanguage = const Language(
          id: 0, name: 'English', locale: 'en', direction: 'ltr', flag: '🇺🇸')
      .obs;

  Language get currentLanguage => _currentLanguage.value;

  Future<void> setLocale(Language language) async {
    _currentLanguage.value = language;
    await Get.updateLocale(Locale(language.locale ?? 'en'));

    Get.find<PreferencesStore>().language = language;
  }

  Future<void> changeLanguage(Language language) async {
    _currentLanguage.value = language;

    await Get.updateLocale(Locale(language.locale ?? 'en'));
    Get.find<PreferencesStore>().language = language;

    // Clear existing translations before loading new ones to prevent conflicts
    final translationService = Get.find<TranslationService>();
    translationService.clearTranslations();
    translationService.clearLoadingKeys();

    await translationService.loadTranslations();
    await Get.offAll(() => const SplashScreen());
  }

  bool getIsRtl() => currentLanguage.direction == 'rtl';

  String getLanguageCode() => currentLanguage.locale ?? 'en';

  String getLocaleName() => currentLanguage.name ?? 'English';

  @override
  void onInit() {
    super.onInit();
    final savedLanguageCode = Get.locale?.languageCode;
    if (savedLanguageCode != null) {
      _currentLanguage.value = Get.find<LanguagesService>()
          .languages
          .firstWhere((language) => language.locale == savedLanguageCode);
    }
  }

  Future<LocaleController> init() async {
    await Get.putAsync<LanguagesService>(() => LanguagesService().init());
    return this;
  }
}
