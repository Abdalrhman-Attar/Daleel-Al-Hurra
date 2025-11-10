import 'package:flutter/cupertino.dart';

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
