import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/general/general_apis.dart';

class TranslationService extends GetxService {
  final RxMap<String, String> _translations = <String, String>{}.obs;
  final Set<String> _loadingKeys = {}; // Track keys currently being loaded

  Future<void> loadTranslations({List<String>? keys}) async {
    try {
      final response = keys != null ? await GeneralApis().addTranslations(keys) : await GeneralApis().getTranslations();

      if (response.isSuccess && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final newTranslations = data.map((key, value) => MapEntry(key, value.toString()));

        if (keys != null) {
          // For specific keys, only update those keys
          newTranslations.forEach((key, value) {
            _translations[key] = value;
          });
        } else {
          // For full load, replace all translations
          _translations.assignAll(newTranslations);
        }

        debugPrint('Successfully loaded ${newTranslations.length} translations${keys != null ? ' for keys: $keys' : ''}');
      } else {
        debugPrint('Failed to load translations: ${response.message}');
      }
    } catch (e) {
      debugPrint('Error loading translations: $e');
    }
  }

  String tr(String key) {
    // Return cached translation if available
    if (_translations[key] != null) {
      return _translations[key]!;
    }
    // if (key == "Dealers") {
    //   debugPrint('TranslationService: $key');
    //   debugPrint('TranslationService: ${_translations[key]}');
    // }

    // If translation is missing, trigger load but return key immediately to avoid blocking UI
    // Use loading set to prevent multiple concurrent requests for the same key
    if (!_loadingKeys.contains(key)) {
      _loadingKeys.add(key); // Add to loading set before starting async operation
      loadTranslations(keys: [key]).then((_) {
        // Remove from loading set after completion
        _loadingKeys.remove(key);
      }).catchError((error) {
        // Remove from loading set on error and log it
        _loadingKeys.remove(key);
        debugPrint('Error loading translation for key: $key, error: $error');
      });
    }

    return key;
  }

  Future<TranslationService> init() async {
    await loadTranslations();
    debugPrint('TranslationService initialized with ${_translations.length} translations');

    return this;
  }

  // Debug method to help identify translation issues
  void debugTranslations() {
    debugPrint('Current translations (${_translations.length}):');
    _translations.forEach((key, value) {
      debugPrint('  $key: $value');
    });
    debugPrint('Loading keys: $_loadingKeys');
  }

  // Public methods to clear translations and loading keys (used by LocaleController)
  void clearTranslations() {
    _translations.clear();
  }

  void clearLoadingKeys() {
    _loadingKeys.clear();
  }
}
