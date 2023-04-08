import 'package:flutter/cupertino.dart';
import 'package:fts_mobile/design/utils/design_utils.dart';

String dummyNetworkImage = '';

bool get isDarkMode => false; // !Get.isPlatformDarkMode

double bottomButtonHeight = 160;

const double flatButtonHeight = 55;

double textFieldHeight = 50;

const String iconPath = 'assets/icons';
const String imagePath = 'assets/images';

const ScrollPhysics defaultPhysics = BouncingScrollPhysics(
  parent: FixedExtentScrollPhysics(),
);

const ScrollPhysics neverScrollablePhysics = NeverScrollableScrollPhysics();

const double defaultButtonPressedOpacity = 0.6;

const TextOverflow defaultOverflow = TextOverflow.ellipsis;

const double horizontalPadding = 15;

Widget defaultLoader({Color? color}) =>
    CupertinoActivityIndicator(color: color ?? getPrimaryColor);
