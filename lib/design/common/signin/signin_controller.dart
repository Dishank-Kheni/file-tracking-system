import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fts_mobile/core/providers/auth_provider.dart';
import 'package:fts_mobile/core/providers/home_provider.dart';
import 'package:fts_mobile/core/routes/app_pages.dart';
import 'package:fts_mobile/core/services/base_services.dart';
import 'package:fts_mobile/core/services/gs_services.dart';
import 'package:fts_mobile/utils/enums.dart';
import 'package:fts_mobile/utils/extensions.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SignInController extends GetxController {
  final AuthProvider _authProvider = AuthProvider();
  final HomeProvider _homeProvider = HomeProvider();

  RxBool isOTPSent = false.obs;

  RxBool isSendingOtp = false.obs;
  FocusNode mobileFocusNode = FocusNode();
  GlobalKey<FormState> mobileNumberFormKey = GlobalKey<FormState>();
  TextEditingController mobileController = TextEditingController();

  String? verificationId;

  Future<void> signInWithPhoneNumber() async {
    if (mobileNumberFormKey.currentState!.validate()) {
      try {
        isSendingOtp.value = true;

        final QueryDocumentSnapshot<Object?>? queryDocumentSnapshot =
            await _homeProvider.getUserFromContactNumber(
                phoneNumber: '+91${mobileController.text}');

        if (queryDocumentSnapshot == null) {
          return "You are not registered with us !".infoSnackbar();
        }

        if (queryDocumentSnapshot['role'] == 'inspector' && !kIsWeb) {
          return "For Inspector go to website !".infoSnackbar();
        }

        if ((queryDocumentSnapshot['role'] == 'officer' ||
                queryDocumentSnapshot['role'] == 'clerk' ||
                queryDocumentSnapshot['role'] == 'citizen') &&
            kIsWeb) {
          return "Install mobile app !".infoSnackbar();
        }

        if ((queryDocumentSnapshot['role'] == 'officer' ||
                queryDocumentSnapshot['role'] == 'clerk') &&
            queryDocumentSnapshot['isRejected']) {
          return "Your registration request is rejected !".infoSnackbar();
        }

        if ((queryDocumentSnapshot['role'] == 'officer' ||
                queryDocumentSnapshot['role'] == 'clerk') &&
            queryDocumentSnapshot['isApproved'] == false) {
          return "Your registration request is pending !".infoSnackbar();
        }

        // if (queryDocumentSnapshot['isDeleted'] == true) {
        //   return "Your account is deleted !".infoSnackbar();
        // }

        await _authProvider.signInWithPhoneNumber(
          phoneNumber: '+91${mobileController.text}',
          onCodeSent: (String vId, int? forceResendingToken) {
            verificationId = vId;
            isOTPSent.value = true;
            debugPrint("Code Has Been Sent: $verificationId");
            'OTP has been sent !'.successSnackbar();
          },
        );
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        isSendingOtp.value = false;
      }
    }
  }

  FocusNode otpFocusNode = FocusNode();
  TextEditingController otpController = TextEditingController();
  StreamController<ErrorAnimationType> otpErrorController =
      StreamController<ErrorAnimationType>();

  Future<void> verifyOTP(String otp) async {
    if (verificationId != null) {
      try {
        UserCredential userCredential = await _authProvider.verifyOTP(
          verificationId: verificationId!,
          otp: otpController.text,
        );
        debugPrint('userCredential: $userCredential');
        "OTP Verified Successfully !".successSnackbar();
        _navigateToHomeAndSaveUserType(userCredential.user?.phoneNumber);
      } on AppException catch (e) {
        if (e.prefix == 'invalid-verification-code') {
          "Invalid OTP !".errorSnackbar();
          otpErrorController.add(ErrorAnimationType.shake);
        } else {
          "Internal error occured !".errorSnackbar();
        }
        debugPrint(e.toString());
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  void navigateToSingUp() {
    Get.toNamed(Routes.SIGNUP);
  }

  void _navigateToHomeAndSaveUserType(String? phoneNumber) async {
    if (phoneNumber != null) {
      QueryDocumentSnapshot<Object?>? userSnapshot = await _homeProvider
          .getUserFromContactNumber(phoneNumber: phoneNumber);

      debugPrint('UserSnapshot: ${userSnapshot?.data()}');

      if (userSnapshot != null) {
        final Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        await GSServices.setCurrentUserData({
          'id': userSnapshot.id,
          'role': userData['role'],
          'name': userData['name'],
          'contactNumber': userData['contactNumber'],
          if (userData['role'] != 'citizen')
            'departmentId': (userData['departmentRef']
                    as DocumentReference<Map<String, dynamic>>)
                .id,
        });

        if (userData['role'] == UserTypeEnum.citizen.toMap()) {
          kIsWeb
              ? "For Citizen install mobile app !".infoSnackbar()
              : Get.offAllNamed(Routes.CHOME);
        } else if (userData['role'] == UserTypeEnum.clerk.toMap() ||
            userData['role'] == UserTypeEnum.officer.toMap()) {
          kIsWeb
              ? "For Officer install mobile app !".infoSnackbar()
              : Get.offAllNamed(Routes.COHOME);
        } else if (userData['role'] == UserTypeEnum.inspector.toMap()) {
          kIsWeb
              ? Get.offAllNamed(Routes.IHOME)
              : "For Inspector go to website !".infoSnackbar();
        } else if (userData['role'] == UserTypeEnum.superAdmin.toMap()) {
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
