part of 'extensions.dart';

extension UserTypeX7n on UserTypeEnum {
  String toMap() {
    switch (this) {
      case UserTypeEnum.citizen:
        return 'citizen';
      case UserTypeEnum.clerk:
        return 'clerk';
      case UserTypeEnum.inspector:
        return 'inspector';
      case UserTypeEnum.officer:
        return 'officer';
      case UserTypeEnum.superAdmin:
        return 'superAdmin';
    }
  }

  static UserTypeEnum fromMap(String value) {
    switch (value) {
      case "citizen":
        return UserTypeEnum.citizen;
      case "clerk":
        return UserTypeEnum.clerk;
      case "inspector":
        return UserTypeEnum.inspector;
      case "officer":
        return UserTypeEnum.officer;
      case "superAdmin":
        return UserTypeEnum.superAdmin;
      default:
        return UserTypeEnum.citizen;
    }
  }
}
