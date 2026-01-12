import 'dart:developer';

class CustomValidator {
  static String? generalValidator({
    required String? value,
    required String? name,
    required String label,
    required String? dataType,
    required String inputType,
    required String? minMaxConstraint,
    required String? errorMsg,
    required int min,
    required int? max,
  }) {
    if (value == null) return '$label field is a required field';

    // var label = item['label'].toString?().toLowerCase();
    // var dataType = item['data_type'].toString().toLowerCase();

    if (inputType.toLowerCase() == "date") {
      return validateDate(
        value,
        label,
        minMaxConstraint,
        min,
        max,
        error: errorMsg,
      );
    }
    // else if ((item['data_url'].toString() != 'null' ||
    //     name.toString().toLowerCase().contains('is_full_year') ||
    //     name.toLowerCase().contains('stock_keeping'))) {
    //   return null;
    // }
    else if (label.toLowerCase().contains('image')) {
      return null;
    } else if (inputType.toLowerCase() == "phone") {
      return CustomValidator.validatePhoneNumber(
        value,
        label,
      );
    } else {
      return CustomValidator.validateInput(
          value, label, minMaxConstraint, min, max,
          error: errorMsg);
    }
  }

  static String? validateInput(
    String value,
    String label,
    String? minMaxConstraint,
    int? min,
    int? max, {
    String? error,
  }) {
    try {
      if (label.toLowerCase().contains("email")) {
        // Regular expression for email validation
        final emailRegex =
            RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");
        if (!emailRegex.hasMatch(value)) {
          return "Please enter a valid $label";
        }
      } else if (minMaxConstraint == "value" && min != null) {
        final newValue =
            value.isEmpty ? 0 : int.tryParse(removeCommas(value)) ?? 0;
        if (newValue < min) {
          return "$label cannot be less than $min";
        }
        if (max != null && newValue > max) {
          return "$label cannot be greater than $max";
        }
      } else if (minMaxConstraint == "length" && min != null) {
        if (value.length < min) {
          return "Enter a minimum of $min characters";
        }
        if (max != null && value.length > max) {
          return "Enter a maximum of $max characters";
        }
      }
      return null;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  static String? validatePhoneNumber(String value, String label) {
    // Regular expression for phone number validation
    final phoneRegex = RegExp(r"^0\d{10}$");

    if (!phoneRegex.hasMatch(value)) {
      return "Invalid $label. Use this format (080 000 0000)";
    }

    return null;
  }

  static String? validateEmail(String value, String label) {
    // Regular expression for phone number validation
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");
    if (!emailRegex.hasMatch(value)) {
      return "Please enter a valid email";
    }

    return null;
  }

  static String? validateDate(
      String value, String label, minMaxConstraint, min, max,
      {error}) {
    if (minMaxConstraint == "value") {
      if (value.isEmpty) {
        return "$label is a required field";
      } else {
        final yearComparison = compareDateWithToday(value);
        if (yearComparison < min) {
          return "$label requires a minimum of $min years";
        } else if (max != null && yearComparison > max) {
          return "$label cannot be greater than $max years";
        } else {
          return null;
        }
      }
    }

    return null;
  }

  static int compareDateWithToday(String dateString) {
    final providedDate = DateTime.parse(dateString);
    final today = DateTime.now();
    final providedYear = providedDate.year;
    final currentYear = today.year;
    final yearComparison = currentYear - providedYear;
    return yearComparison;
  }

  static String removeCommas(String value) {
    return value.replaceAll(',', '');
  }

  static String? validateForm(String value, String label, int? min,
      {String? errorMessage}) {
    try {
      if (label.toLowerCase().contains("email")) {
        // Regular expression for email validation
        final emailRegex =
            RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");
        if (!emailRegex.hasMatch(value)) {
          return "Please enter a valid $label";
        }
      } else if (label.toLowerCase().contains("phone")) {
        final phoneRegex = RegExp(r"^0\d{10}$");

        if (!phoneRegex.hasMatch(value)) {
          return "Invalid phone number. Use this format (080 000 0000)";
        }

        return null;
      } else if (min != null) {
        if (value.length < min) {
          return errorMessage ?? "Please enter a valid $label";
        }
      }
      return null;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  static String? howDidItHappen(String? value, {int minChars = 150}) {
    final text = (value ?? '').trim();
    if (text.isEmpty) {
      return 'Tell us how it happened';
    }
    // final wordCount =
    //     text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    // if (wordCount < 150) {
    //   return 'Your description must be at least 150 words (currently $wordCount).';
    // }
    // return null;
//final charCount = text.replaceAll(RegExp(r'\s+'), '').length;
    final charCount = text.length; // counts spaces/newlines too
    if (charCount < minChars) {
      return 'Your description must be at least $minChars characters (currently $charCount).';
    }
    return null;
  }
}
