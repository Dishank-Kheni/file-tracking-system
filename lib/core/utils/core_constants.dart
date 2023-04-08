import 'package:fts_mobile/utils/extensions.dart';

const int defaultPage = 1;
const int defaultPageSize = 20;

const String defaultStringAssertion = "-";
const int defaultIntAssertion = -1;
const double defaultDoubleAssertion = -1.0;

RegExp allowDoubleRegExp = RegExp(r'^(\d+)?\.?\d{0,2}');

bool isNullEmptyOrFalse(dynamic o) {
  if (o is Map<String, dynamic> || o is List<dynamic>) {
    return o == null || o.length == 0;
  }
  return o == null ||
      o == false ||
      o == "" ||
      o == defaultIntAssertion ||
      o == defaultStringAssertion ||
      o == defaultDoubleAssertion;
}

int decodeInt(dynamic value, {int defaultValue = defaultIntAssertion}) {
  return isNullEmptyOrFalse(value) ? defaultValue : value.toInt() as int;
}

double decodeDouble(dynamic value,
    {double defaultValue = defaultDoubleAssertion}) {
  return isNullEmptyOrFalse(value) ? defaultValue : value.toDouble() as double;
}

String decodeString(dynamic value) {
  return isNullEmptyOrFalse(value) ? defaultStringAssertion : value as String;
}

bool decodeBool(dynamic value, {bool defaultValue = false}) {
  return value == null ? defaultValue : value as bool;
}

DateTime? decodeDateTime(dynamic value) {
  return value == null ? null : (value as String).stringToDateTime;
}
