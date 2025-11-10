import 'package:get/get.dart';

import '../controllers/locale/locale.dart';
import '../controllers/theme/theme.dart';

class MainBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController(), permanent: true);
    Get.put(LocaleController(), permanent: true);
  }
}
