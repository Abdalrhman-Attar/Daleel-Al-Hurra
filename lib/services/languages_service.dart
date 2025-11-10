import 'package:get/get.dart';

import '../api/general/general_apis.dart';
import '../model/general/language/language.dart';

class LanguagesService extends GetxService {
  final RxList<Language> _languages = <Language>[].obs;

  Future<void> loadLanguages() async {
    final response = await GeneralApis().getLanguages();

    if (response.isSuccess) {
      _languages.assignAll(response.data ?? []);
    }
  }

  Language get defaultLanguage =>
      _languages.firstWhere((language) => language.isDefault == true);

  List<Language> get languages => _languages;

  Future<LanguagesService> init() async {
    await loadLanguages();

    return this;
  }
}
