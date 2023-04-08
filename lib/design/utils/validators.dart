import 'package:get/utils.dart';

class AuthValidator {
  static String? phoneValidator(String? value) {
    if (value?.trim().isEmpty ?? true) return "required!";
    if (value != null && value.length != 10) {
      return "Mobile number must be of exact 10 digits!";
    }
    if (value != null && !GetUtils.isPhoneNumber(value.trim())) {
      return "Invalid mobile number!";
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value?.trim().isEmpty ?? true) return "required!";

    if (value != null && !GetUtils.isEmail(value.trim())) {
      return "Invalid Email Address!";
    }
    return null;
  }

  static String? emptyNullValidator(
    String? value, {
    String? errorMessage = "required!",
  }) {
    //TODO: Add Extra Validation If Needed
    if (value?.trim().isEmpty ?? true) return errorMessage;

    return null;
  }

  static String? passwordValidator(String? value) {
    if (value?.trim().isEmpty ?? true) return "required!";

    if (value != null && value.trim().length < 6) {
      return "Password must contain atleast 6 characters";
    }

    return null;
  }
}
