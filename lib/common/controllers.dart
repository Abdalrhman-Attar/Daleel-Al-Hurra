import 'package:get/get.dart';

import '../controllers/locale/locale.dart';
import '../controllers/theme/theme.dart';

class Controllers {
  static final ThemeController theme = Get.put(ThemeController());
  static final LocaleController locale = Get.put(LocaleController());

  static void init() {
    theme.onInit();
    locale.onInit();
  }
}
