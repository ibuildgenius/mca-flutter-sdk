import 'const.dart';

class EmailValidator {
  static String? validate(String value,{error}) {
    if (value.isEmpty) {
      return error?? emptyEmailField;
    }
    final regExp = RegExp(emailRegex);
    if (regExp.hasMatch(value)) {
      return null;
    }
    return invalidEmailField;
  }
}

class PhoneNumberValidator {
  static String? validate(String value,{error}) {
    if (value.isEmpty) {
      return error?? emptyTextField;
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
  static String? validate(String value,{error}) {
    if (value.isEmpty) {
      return error?? emptyTextField;
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
      return error??emptyTextField;
    }

    return null;
  }
}
