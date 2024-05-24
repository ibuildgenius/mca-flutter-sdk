import 'const.dart';

class EmailValidator {
  static String? validate(String value, {error}) {
    if (value.isEmpty) {
      return error ?? emptyEmailField;
    }
    final regExp = RegExp(emailRegex);
    if (regExp.hasMatch(value)) {
      return null;
    }
    return invalidEmailField;
  }
}

class PhoneNumberValidator {
  static String? validate(String value, {error}) {
    if (value.isEmpty) {
      return error ?? emptyTextField;
    }

    if (value.length != 11) {
      return phoneNumberLengthError;
    }
    // Regex for phone number validation
    final regExp = RegExp(phoneNumberRegex);
    if (regExp.hasMatch(value)) {
      return null;
    }
    return invalidPhoneNumberField;
  }
}

class BVNValidator {
  static String? validate(String value, {error}) {
    if (value.isEmpty) {
      return error ?? emptyTextField;
    }

    if (value.length != 10) {
      return bvnLengthError;
    }

    return null;
  }
}

class FieldValidator {
  static String? validate(String value, {error}) {
    if (value.isEmpty) {
      return error ?? emptyTextField;
    }

    return null;
  }
}

class CustomValidator {
  static String? validate(String value, String label, minMaxConstraint, min,
      {error}) {
    if (label.toLowerCase().contains("email")) {
      // Regular expression for email validation
      RegExp emailRegex =
          RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");

      if (!emailRegex.hasMatch(value)) {
        return "Please enter a valid $label";
      }
    } else if (minMaxConstraint == "value" && min != null) {
      int newValue = value.isEmpty ? 0 : int.tryParse(removeCommas(value)) ?? 0;
      if (newValue < min) {
        return "$label cannot be less than $min";
      } else {
        return null;
      }
    } else if (minMaxConstraint == "length" && min != null) {
      if (value.toString().length < min) {
        return "$label length should not be less than $min";
      } else {
        return null;
      }
    }
    return null;
  }
}

class DropdownValidator {
  static String? validate(String value, String label, minMaxConstraint, min,
      {error}) {
    if (minMaxConstraint == "value") {
      int newValue = value.isEmpty ? 0 : int.tryParse(removeCommas(value)) ?? 0;
      if (newValue < min) {
        return "$label field is required";
      } else {
        return null;
      }
    } else if (minMaxConstraint == "length") {
      if (value.toString().length < min) {
        return "$label field is required";
      } else {
        return null;
      }
    }
    return null;
  }
}

class DateValidator {
  static String? validate(String value, String label, minMaxConstraint, min,
      {error}) {
    if (minMaxConstraint == "value") {
      if (value.isEmpty) {
        return "$label is a required field";
      } else {
        int yearComparison = compareDateWithToday(value);
        if (yearComparison < min) {
          return "$label requires a minimum of $min years";
        } else {
          return null;
        }
      }
    }

    return null;
  }
}

int compareDateWithToday(String dateString) {
  DateTime providedDate = DateTime.parse(dateString);
  DateTime today = DateTime.now();
  int providedYear = providedDate.year;
  int currentYear = today.year;
  int yearComparison = currentYear - providedYear;
  return yearComparison;
}

String removeCommas(String stringWithCommas) {
  return stringWithCommas.replaceAll(',', '');
}
