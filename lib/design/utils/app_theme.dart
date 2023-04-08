import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fts_mobile/design/utils/design_utils.dart';

class AppTheme {
  AppTheme._();

  static final lightTheme = ThemeData.light().copyWith(
    errorColor: redColor,
    backgroundColor: lbgColor,
    primaryColor: lPrimaryColor,
    primaryColorLight: lPrimaryColor,
    splashColor: Colors.transparent,
    scaffoldBackgroundColor: lbgColor,
    hintColor: lPrimaryColor.withOpacity(.4),
    iconTheme: const IconThemeData(size: 24),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: lbgColor,
    ),
    textSelectionTheme:
        const TextSelectionThemeData(cursorColor: lPrimaryColor),
    cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
      barBackgroundColor: lbgColor,
      primaryColor: lPrimaryColor,
      scaffoldBackgroundColor: lbgColor,
      textTheme: CupertinoTextThemeData(
        textStyle: TextStyle(
          fontSize: 14,
          color: lPrimaryTextColor,
          fontFamily: getPoppinsFontFamily,
        ),
        primaryColor: lPrimaryColor,
      ),
    ),
  );
}
