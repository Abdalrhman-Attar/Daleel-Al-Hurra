import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../main.dart';

class HelperFunctions {
  static DateTime getStartOfWeek(DateTime date) {
    final daysUntilMonday = date.weekday - 1;
    final startOfWeek = date.subtract(Duration(days: daysUntilMonday));
    return DateTime(
        startOfWeek.year, startOfWeek.month, startOfWeek.day, 0, 0, 0, 0, 0);
  }

  // static Color getOrderStatusColor(OrderStatus value) {
  //   if (OrderStatus.pending == value) {
  //     return Colors.blue;
  //   } else if (OrderStatus.processing == value) {
  //     return Colors.orange;
  //   } else if (OrderStatus.shipped == value) {
  //     return Colors.purple;
  //   } else if (OrderStatus.delivered == value) {
  //     return Colors.green;
  //   } else if (OrderStatus.cancelled == value) {
  //     return Colors.red;
  //   } else {
  //     return Colors.grey;
  //   }
  // }

  // static Color? getColor(String value) {
  //   /// Define your product specific colors here and it will match the attribute colors and show specific 🟠🟡🟢🔵🟣🟤

  //   if (value == 'Green') {
  //     return Colors.green;
  //   } else if (value == 'Green') {
  //     return Colors.green;
  //   } else if (value == 'Red') {
  //     return Colors.red;
  //   } else if (value == 'Blue') {
  //     return Colors.blue;
  //   } else if (value == 'Pink') {
  //     return Colors.pink;
  //   } else if (value == 'Grey') {
  //     return Colors.grey;
  //   } else if (value == 'Purple') {
  //     return Colors.purple;
  //   } else if (value == 'Black') {
  //     return Colors.black;
  //   } else if (value == 'White') {
  //     return Colors.white;
  //   } else if (value == 'Yellow') {
  //     return Colors.yellow;
  //   } else if (value == 'Orange') {
  //     return Colors.deepOrange;
  //   } else if (value == 'Brown') {
  //     return Colors.brown;
  //   } else if (value == 'Teal') {
  //     return Colors.teal;
  //   } else if (value == 'Indigo') {
  //     return Colors.indigo;
  //   } else {
  //     return null;
  //   }
  // }

  static void showSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static void showAlert(String title, String message) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(tr('ok')),
            ),
          ],
        );
      },
    );
  }

  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  static double screenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  static double screenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }

  static String getFormattedDate(DateTime date,
      {String format = 'dd MMM yyyy'}) {
    return DateFormat(format).format(date);
  }

  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrappedList = <Widget>[];
    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(
          i, i + rowSize > widgets.length ? widgets.length : i + rowSize);
      wrappedList.add(Row(children: rowChildren));
    }
    return wrappedList;
  }

  ValueNotifier<int> totalNotificationsValue = ValueNotifier(0);

  String countryCode = '+962';

  String formatPhoneNumber(String phoneNumber) {
    phoneNumber = phoneNumber.trim();
    if (phoneNumber.startsWith('0')) {
      phoneNumber = phoneNumber.substring(1);
    }

    // Add the country code +962
    return countryCode + phoneNumber;
  }

  // New function to format phone number with country code
  String formatPhoneNumberWithCountryCode(
      String phoneNumber, String countryCode) {
    phoneNumber = phoneNumber.trim();
    if (phoneNumber.startsWith('0')) {
      phoneNumber = phoneNumber.substring(1);
    }

    // Add the country code
    return countryCode + phoneNumber;
  }

  /// Validates if a URL is an image file
  bool isValidImageUrl(String url) {
    final urlLower = url.toLowerCase();
    return !urlLower.endsWith('.mp4') &&
        !urlLower.endsWith('.avi') &&
        !urlLower.endsWith('.mov') &&
        !urlLower.endsWith('.wmv') &&
        !urlLower.endsWith('.flv') &&
        !urlLower.endsWith('.webm');
  }
}
