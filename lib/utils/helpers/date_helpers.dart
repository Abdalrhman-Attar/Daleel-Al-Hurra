import 'package:get/get.dart';
import 'package:intl/intl.dart';

String monthToString(int month) =>
    DateFormat.MMM(Get.locale?.toLanguageTag() ?? Intl.defaultLocale!)
        .format(DateTime(2000, month));
String dayToString(int day) =>
    DateFormat.d(Get.locale?.toLanguageTag() ?? Intl.defaultLocale!)
        .format(DateTime(2000, 1, day));
String timeToString(DateTime time) =>
    DateFormat.jm(Get.locale?.toLanguageTag() ?? Intl.defaultLocale!)
        .format(time);
String dateToString(DateTime date) =>
    DateFormat.yMMMd(Get.locale?.toLanguageTag() ?? Intl.defaultLocale!)
        .format(date);
String dateTimeToString(DateTime dateTime) =>
    DateFormat.yMMMd(Get.locale?.toLanguageTag() ?? Intl.defaultLocale!)
        .add_jm()
        .format(dateTime);
String timeToStringWithSeconds(DateTime time) =>
    DateFormat('h:mm:ss a').format(time);
