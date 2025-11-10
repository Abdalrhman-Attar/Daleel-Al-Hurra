import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MyFonts {
  static String getFontFamily() {
    var languageCode = Get.locale?.languageCode ?? 'en';
    if (languageCode == 'ar') {
      return GoogleFonts.cairo().fontFamily!;
    } else {
      return GoogleFonts.inter().fontFamily!;
    }
  }
}
