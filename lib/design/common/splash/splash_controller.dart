import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fts_mobile/core/providers/auth_provider.dart';
import 'package:fts_mobile/core/providers/home_provider.dart';
import 'package:fts_mobile/core/routes/app_pages.dart';
import 'package:fts_mobile/core/services/gs_services.dart';
import 'package:fts_mobile/utils/enums.dart';
import 'package:fts_mobile/utils/extensions.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final HomeProvider _homeProvider = HomeProvider();
  final AuthProvider _authProvider = AuthProvider();

  @override
  void onReady() {
    super.onReady();
    checkUserSignedIn();
  }

  Future<void> checkUserSignedIn() async {
    // ?Authenticated through local(GS) User
    // TODO: Check if user is authenticated through firebase user(previously it returns null on web)
    User? currentFirebaseUser = _authProvider.getCurrentFirebaseUser();
    Map? currentLocalUser = GSServices.getCurrentUserData();

    debugPrint("currentFirebaseUser: $currentFirebaseUser");
    debugPrint("CurrentLocalUser: $currentLocalUser");

    Timer(
      const Duration(seconds: 2),
      () => currentLocalUser == null
          ? Get.offNamed(kIsWeb ? Routes.ISIGNIN : Routes.SIGNIN)
          : _navigateToHome(currentLocalUser['contactNumber']),
    );
  }

  void _navigateToHome(String? phoneNumber) async {
    if (phoneNumber != null) {
      QueryDocumentSnapshot<Object?>? user = await _homeProvider
          .getUserFromContactNumber(phoneNumber: phoneNumber);

      if (user != null) {
        if (user['role'] == UserTypeEnum.citizen.toMap()) {
          kIsWeb
              ? "For Citizen install mobile app !".infoSnackbar()
              : Get.offAllNamed(Routes.CHOME);
        } else if (user['role'] == UserTypeEnum.clerk.toMap() ||
            user['role'] == UserTypeEnum.officer.toMap()) {
          kIsWeb
              ? "For Officer install mobile app !".infoSnackbar()
              : Get.offAllNamed(Routes.COHOME);
        } else if (user['role'] == UserTypeEnum.inspector.toMap()) {
          kIsWeb
              ? Get.offAllNamed(Routes.IHOME)
              : "For Inspector go to website !".infoSnackbar();
        } else if (user['role'] == UserTypeEnum.superAdmin.toMap()) {
          // TODO: Add Route
        } else {
          Get.toNamed(Routes.UNKNOW_404);
        }
      } else {
        debugPrint("User got Null !!!");
      }
    } else {
      debugPrint("Phone Number got Null !!!");
    }
  }
}
