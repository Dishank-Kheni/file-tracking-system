import '/design/utils/select_image.dart';

class AppImages {
  AppImages._();

  static const String _imagePath = 'assets/images';

  static String get splash => setldImageIcon('$_imagePath/splash.png');
  static String get logo => setldImageIcon('$_imagePath/logo.png');
  static String get webSplash => setldImageIcon('$_imagePath/web-splash.jpg');
  static String get india => setldImageIcon('$_imagePath/india.png');
}

class AppIcons {
  AppIcons._();

  static const String _iconPath = 'assets/icons';

  static String get handshake => setldImageIcon('$_iconPath/handshake.svg');
  static String get users => setldImageIcon('$_iconPath/users.svg');
  static String get add => setldImageIcon('$_iconPath/add.svg');
  static String get cross => setldImageIcon('$_iconPath/cross.svg');
  static String get dashboard => setldImageIcon('$_iconPath/dashboard.svg');
  static String get files => setldImageIcon('$_iconPath/files.svg');
  static String get logout => setldImageIcon('$_iconPath/logout.svg');
  static String get officer => setldImageIcon('$_iconPath/officer.svg');
  static String get approveUser =>
      setldImageIcon('$_iconPath/approve_user.svg');
}

class AppAnimations {
  AppAnimations._();

  static const String _animationPath = 'assets/animations';

  static String get person1 => setldImageIcon('$_animationPath/person1.riv');
  static String get person2 => setldImageIcon('$_animationPath/person2.riv');
  static String get person3 => setldImageIcon('$_animationPath/person3.riv');
}
