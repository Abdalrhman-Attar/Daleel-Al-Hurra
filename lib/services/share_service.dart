import 'dart:developer' as developer;

import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../module/toast.dart';
import '../services/deep_link_service.dart';
import '../services/translation_service.dart';

class ShareService {
  /// Share App (General app sharing)
  static Future<void> shareApp({String? customMessage}) async {
    try {
      final appDownloadLink = DeepLinkService.generateAppDownloadLink();

      var shareText = customMessage ??
          '''
📱 اكتشف تطبيقنا الرائع!

🎉 فعاليات مميزة
🏪 متاجر متنوعة  
🛍️ منتجات رائعة
🏛️ وجهات سياحية

حمل التطبيق الآن واستمتع بتجربة فريدة!

🔗 $appDownloadLink

#تطبيق #عمان #الأردن #فعاليات #تسوق #سياحة
''';

      await SharePlus.instance.share(
        ShareParams(
          text: shareText,
          subject:
              Get.find<TranslationService>().tr('an amazing app worth trying'),
        ),
      );

      Toast.s(Get.find<TranslationService>().tr('app shared successfully'));
    } catch (e) {
      Toast.e(Get.find<TranslationService>()
          .tr('an error occurred while sharing the app'));
    }
  }

  /// Share with custom text
  static Future<void> shareCustom(String text, {String? subject}) async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: text,
          subject: subject ?? Get.find<TranslationService>().tr('share'),
        ),
      );

      Toast.s(Get.find<TranslationService>().tr('shared successfully'));
    } catch (e) {
      Toast.e(
          Get.find<TranslationService>().tr('an error occurred while sharing'));
    }
  }

  /// Share a car with deep link
  static Future<void> shareCar({
    required int carId,
    required String carName,
    required String? carImage,
    required String? dealerName,
    double? price,
  }) async {
    try {
      final httpsLink = DeepLinkService.generateCarHttpsLink(carId);

      final priceText =
          price != null ? '\n💰 Price: ${price.toStringAsFixed(0)} JD' : '';
      final dealerText = dealerName != null ? '\n🏪 Dealer: $dealerName' : '';

      // Use HTTPS-only sharing for better clickability in messaging apps
      final shareText = '''
🚗 Check out this amazing car!

📋 Name: $carName$priceText$dealerText

🔗 Open in Daleel Al Hurra: $httpsLink

#DaleelAlHurra #Cars #Jordan
''';

      await SharePlus.instance.share(
        ShareParams(
          text: shareText,
          subject: 'Check out this car: $carName',
        ),
      );

      Toast.s(Get.find<TranslationService>().tr('car shared successfully'));
    } catch (e) {
      developer.log('Error sharing car: $e');
      Toast.e(Get.find<TranslationService>()
          .tr('an error occurred while sharing the car'));
    }
  }

  /// Share a dealer with deep link
  static Future<void> shareDealer({
    required int dealerId,
    required String dealerName,
    required String? dealerLogo,
    required String? dealerAddress,
    required String? dealerPhone,
  }) async {
    try {
      final httpsLink = DeepLinkService.generateDealerHttpsLink(dealerId);

      final addressText =
          dealerAddress != null ? '\n📍 Address: $dealerAddress' : '';
      final phoneText = dealerPhone != null ? '\n📞 Phone: $dealerPhone' : '';

      // Use HTTPS-only sharing for better clickability in messaging apps
      final shareText = '''
🏪 Check out this dealer!

🏢 Name: $dealerName$addressText$phoneText

🔗 Open in Daleel Al Hurra: $httpsLink

#DaleelAlHurra #Dealers #Jordan
''';

      await SharePlus.instance.share(
        ShareParams(
          text: shareText,
          subject: 'Check out this dealer: $dealerName',
        ),
      );

      Toast.s(Get.find<TranslationService>().tr('dealer shared successfully'));
    } catch (e) {
      developer.log('Error sharing dealer: $e');
      Toast.e(Get.find<TranslationService>()
          .tr('an error occurred while sharing the dealer'));
    }
  }
}
