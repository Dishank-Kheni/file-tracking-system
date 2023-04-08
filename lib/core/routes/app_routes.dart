// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const UNKNOW_404 = _Paths.UNKNOWN_404;

  // Common (Officer & Citizen)
  static const SPLASH = _Paths.SPLASH;
  static const SIGNIN = _Paths.SIGNIN;
  static const SIGNUP = _Paths.SIGNUP;

  // Clerk-Officer
  static const COHOME = _Paths.COHOME;
  static const CREATEFILE = COHOME + _Paths.CREATEFILE;
  static const CREATEFILESCANNER = CREATEFILE + _Paths.SCANNER;
  static const SCANFILE = COHOME + _Paths.SCANFILE;
  static const SCANFILESCANNER = SCANFILE + _Paths.SCANNER;

  // Citizen
  static const CHOME = _Paths.CHOME;
  static const CMESSAGE = CHOME + _Paths.CMESSAGE;

  // Inspector
  static const ISIGNIN = _Paths.ISIGNIN;
  static const IHOME = _Paths.IHOME;
}

// !co == clerk-officer
// !c == citizen

abstract class _Paths {
  static const UNKNOWN_404 = '/404';
  static const SPLASH = '/splash';
  static const SIGNIN = '/sign-in';
  static const SIGNUP = '/sign-up';
  static const COHOME = '/co-home';
  static const SCANFILE = '/scan-file';
  static const CREATEFILE = '/create-file';
  static const SCANNER = '/scanner';

  // Citizen
  static const CHOME = '/c-home';
  static const CMESSAGE = '/c-message';

  // Inspector
  static const ISIGNIN = '/inspector-sign-in';
  static const IHOME = '/home';
}
