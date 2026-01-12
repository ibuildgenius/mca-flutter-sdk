import 'package:intl/intl.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';

class StringUtils {
  static String getBaseUrl({bool useV2Url = false}) {
    String mode = Global.mode;

    String baseUrl = mode == ConstantString.stagingMode
        ? 'https://staging.api.mycover.ai'
        : 'https://api.mycover.ai';
    return useV2Url ? '$baseUrl/v2' : '$baseUrl/v1';
  }

  static String getProviderPeriodOfCover(String periodOfCover) {
    return periodOfCover == "12" ? "Anumm" : "Month";
  }

  static String getProductPrice(String price, bool isDynamic) {
    return isDynamic
        ? "${formatDynamicPrice(price)}%"
        : "₦ ${formatPriceWithComma(price)} ";
  }

  static String formatDynamicPrice(String priceString) {
    double price = double.tryParse(priceString) ?? 0.0;
    String formattedPrice = price.toStringAsFixed(2);

    if (formattedPrice.endsWith('.00')) {
      return formattedPrice.substring(
          0, formattedPrice.length - 3); // Remove the '.00'
    } else {
      return formattedPrice;
    }
  }

  static String? formatPriceWithComma(String? priceString) {
    if (priceString == null) {
      return null;
    } else {
      double price = double.tryParse(priceString) ?? 0.0;
      // Check if the price is an integer (i.e., has no decimal part)
      bool isInteger = price == price.toInt();

      // Format the price with commas, and optionally with decimal places
      final NumberFormat numberFormat = NumberFormat.currency(
        locale: 'en_US',
        decimalDigits:
            isInteger ? 0 : 2, // 0 decimal places if integer, 2 if not
        symbol: '',
      );
      return numberFormat.format(price);
    }
  }

  // static String? formatPriceWithComma(String? priceString) {
  //   if (priceString == null) {
  //     return null;
  //   } else {
  //     double price = double.tryParse(priceString) ?? 0.0;
  //     String formattedPrice = price.toStringAsFixed(2);

  //     if (formattedPrice.endsWith('.00')) {
  //       formattedPrice = formattedPrice.substring(
  //           0, formattedPrice.length - 3); // Remove the '.00'
  //     }

  //     return NumberFormat.currency(
  //             locale: 'en_US', decimalDigits: 0, symbol: '')
  //         .format(double.parse(formattedPrice));
  //   }
  // }

  static String? getInitialValue(String name) {
    switch (name.toLowerCase()) {
      case 'email':
        return Global.form['email'] ?? '';
      case 'first_name':
        return Global.form['first_name'] ?? '';
      case 'last_name':
        return Global.form['last_name'] ?? '';
      case 'phone':
        return Global.form['phone'] ?? '';
      case 'phone_number':
        return Global.form['phone'] ?? '';
      default:
        return null;
    }
  }

  static bool isNullOrEmptyList(List? list) {
    return list == null || list.isEmpty;
  }

  static bool isNullOrEmpty(String? str) {
    return str == null || str.isEmpty;
  }

  static String getFirstTwoCharsCapitalized(String? input) {
    if (input == null || input.isEmpty) {
      return "";
    }
    String firstTwoChars =
        input.substring(0, input.length >= 2 ? 2 : input.length);
    return firstTwoChars.toUpperCase();
  }

  static String getFirstCharCapitalized(String? input) {
    if (input == null || input.isEmpty) {
      return "";
    }
    String firstChar = input.substring(0, 1);
    return firstChar.toUpperCase();
  }

  static String convertToMilitaryTime(String inputTime) {
    try {
      // Case 1: Already looks like 24-hour time (e.g., 22:15)
      final militaryRegex = RegExp(r'^\d{1,2}:\d{2}$');
      if (militaryRegex.hasMatch(inputTime)) {
        final parts = inputTime.split(':');
        final hours = int.parse(parts[0]);
        final minutes = int.parse(parts[1]);

        // Format strictly to HH:mm
        return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
      }

      // Case 2: Standard 12-hour format (e.g., 7:33 AM / 11:59 pm)
      final DateFormat inputFormat = DateFormat.jm();
      final DateTime dateTime = inputFormat.parse(inputTime);

      // Always return in HH:mm (military format)
      return DateFormat.Hm().format(dateTime);
    } catch (e) {
      // 🚨 If parsing fails, return "00:00" or throw
      return "00:00";
    }
  }

  static String getFileNameFromPath(String path) {
    // Check if the path is null or empty
    if (path.isEmpty) {
      return '';
    }

    final lastSeparatorIndex = path.lastIndexOf(RegExp(r'[/\\]'));

    final fileNameWithExtension = (lastSeparatorIndex != -1)
        ? path.substring(lastSeparatorIndex + 1)
        : path;

    // Get the last 10 characters
    final lastTenCharacters = fileNameWithExtension.length > 10
        ? fileNameWithExtension.substring(fileNameWithExtension.length - 10)
        : fileNameWithExtension;

    return lastTenCharacters;
  }

  // static String convertToMilitaryTime(String inputTime) {
  //    final DateFormat inputFormat = DateFormat.jm();        // e.g., '7:33 AM'
  //    final DateFormat outputFormat = DateFormat.Hm();       // e.g., '07:33'
  //    final DateTime dateTime = inputFormat.parse(inputTime);
  //    return outputFormat.format(dateTime);
  //  }
}
