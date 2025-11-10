import 'package:intl/intl.dart';

class Formatter {
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    final onlyDate = DateFormat('dd/MM/yyyy').format(date);
    final onlyTime = DateFormat('hh:mm').format(date);
    return '$onlyDate at $onlyTime';
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_US', symbol: '\$')
        .format(amount); // Customize the currency locale and symbol as needed
  }

  static String formatPhoneNumber(String phoneNumber) {
    // format phone number to be like this +962XXXXXXXXX
    // always add +962 in the beginning
    // 0XXXXXXXXX => +962XXXXXXXXX
    // XXXXXXXXX => +962XXXXXXXXX
    // +962XXXXXXXXX => +962XXXXXXXXX
    phoneNumber = phoneNumber.trim();
    if (phoneNumber.startsWith('0')) {
      phoneNumber = '+962${phoneNumber.substring(1)}';
    } else if (phoneNumber.startsWith('7')) {
      phoneNumber = '+962$phoneNumber';
    } else if (phoneNumber.startsWith('+962')) {
      phoneNumber = '+962$phoneNumber';
    }
    return phoneNumber;
  }

  // Not fully tested.
  static String internationalFormatPhoneNumber(String phoneNumber) {
    // Remove any non-digit characters from the phone number
    var digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Extract the country code from the digitsOnly
    var countryCode = '+${digitsOnly.substring(0, 2)}';
    digitsOnly = digitsOnly.substring(2);

    // Add the remaining digits with proper formatting
    final formattedNumber = StringBuffer();
    formattedNumber.write('($countryCode) ');

    var i = 0;
    while (i < digitsOnly.length) {
      var groupLength = 2;
      if (i == 0 && countryCode == '+1') {
        groupLength = 3;
      }

      var end = i + groupLength;
      formattedNumber.write(digitsOnly.substring(i, end));

      if (end < digitsOnly.length) {
        formattedNumber.write(' ');
      }
      i = end;
    }

    return formattedNumber.toString();
  }
}
