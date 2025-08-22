import 'package:flutter/services.dart';

class Validators {
  static String? validateMobile(String value) {
    if (value.isEmpty) {
      return 'Mobile Number is Required';
    }
    return null;
  }

  static String? validateName(String value, String type) {
    const String pattern = r'(^[a-zA-Z ]*$)';
    final RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return '$type is Required';
    } else if (!regExp.hasMatch(value)) {
      return '$type must be a-z and A-Z';
    }
    return null;
  }

  static String? validateDob(DateTime? date) {
    if (date == null) {
      return 'Date of birth is Required';
    } else if (date.year < 18) {
      return 'Your date of birth must be more then 18 year.';
    }
    return null;
  }

  static String? validateEmail(String value) {
    const String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    final RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Email is Required';
    } else if (!regExp.hasMatch(value)) {
      return 'Invalid Email';
    }
    return null;
  }

  static String? validateRequired(String value, String type) {
    if (value.isEmpty) {
      return '$type is Required';
    }
    return null;
  }

  static String? validatecountryControllerCode(String value) {
    const String pattern = r'(^\d{0,3}$)';
    final RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'countryController code is Required';
    } else if (!regExp.hasMatch(value)) {
      return 'countryController Code is not valid';
    }
    return null;
  }

  static String? validatePassword(String value) {
    const String pattern =
        r'^.*(?=.{8,})(?=.*\d)((?=.*[a-z]){1})((?=.*[A-Z]){1}).*$';
    // String pattern =
    //     r'^.*(?=.{8,})((?=.*[!@#$%^&*()\-_=+{};:,<.>]){1})(?=.*\d)((?=.*[a-z]){1})((?=.*[A-Z]){1}).*$';
    final RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Password is Required';
    } else if (!regExp.hasMatch(value)) {
      return 'Minimum 8 characters password required\nwith a combination of uppercase and lowercase letter and number are required.';
    } else {
      return null;
    }
  }

  static String? validateConfirmPassword(String value1, String value2) {
    if (value2.isEmpty) {
      return 'Confirm Password is Required';
    } else if (value2 != value1) {
      return 'Password & Confirm Password does not match.';
    }
    return null;
  }

  String? validateDate(String value) {
    const String pattern = r'([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))';
    final RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Date is Required';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid date';
    }
    return null;
  }

  static String? validateCardNumber(
      String value,
      ) {
    if (value.isEmpty) {
      return '  Account Number is Required';
    } else if (value.length < 9) {
      return '  Account Number is Not Required';
    }
    return null;
  }

  static String? validateConfirmCardNumber(String value1, String value2) {
    if (value1.isEmpty) {
      return '  Account Number is Required';
    } else if (value1 != value2) {
      return '  Account Number does not match.';
    }
    return null;
  }

  static String? validatePassengers(String value1, String val) {
    if (value1.isEmpty) {
      return '$val is Required';
    } else if (int.parse(value1) == 10) {
      return 'Max $val limit is 10';
    }
    return null;
  }

  static String? validatePasswordParent(String value) {
    const String pattern =
        r'^.*(?=.{8,})((?=.*[!@#$%^&*()\-_=+{};:,<.>]){1})(?=.*\d)((?=.*[a-z]){1})((?=.*[A-Z]){1}).*$';
    final RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return '  Password is Required';
    } else if (!regExp.hasMatch(value)) {
      return '  Minimum 8 characters password required\nwith a combination of uppercase and lowercase letter and number are required.';
    }
    return null;
  }

  static String? isValidIFSCode(String value) {
    const String pattern = r'(^[A-Z]{4}[0][A-Z0-9]{6}$)';
    final RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return ' Please enter IFSC Code';
    }
    if (!regExp.hasMatch(value)) {
      return ' Please enter valid IFSC Code';
    }

    return null;
  }

  String hideDigits(String numberStr) {
    if (numberStr.length <= 4) {
      return numberStr;
    } else {
      final String visibleDigits = numberStr.substring(numberStr.length - 4);
      final String hiddenDigits = '•' * (numberStr.length - 4);
      return hiddenDigits + visibleDigits;
    }
  }

  final textFormatter = TextInputFormatter.withFunction(
        (oldValue, newValue) {
      if (newValue.text.isEmpty) {
        return newValue.copyWith(text: '');
      } else if (oldValue.text.length < newValue.text.length) {
        final String newText = newValue.text.replaceFirstMapped(
          RegExp(r'(?<=\s|^)(\w)'),
              (match) => match.group(0)!.toUpperCase(),
        );
        return newValue.copyWith(text: newText);
      }
      return newValue;
    },
  );

  String getDocumentType(String documentName) {
    final List<String> parts = documentName.split('.');
    final String lastExtension = parts.last.toLowerCase();

    switch (lastExtension) {
      case 'pdf':
        return 'pdf';
      case 'doc':
      case 'docx':
        return 'doc';
      case 'jpeg':
      case 'jpg':
      case 'png':
        return 'image';
      default:
        return '';
    }
  }
}
