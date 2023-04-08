import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fts_mobile/core/providers/home_provider.dart';
import 'package:fts_mobile/core/services/base_services.dart';
import 'package:fts_mobile/utils/enums.dart';
import 'package:fts_mobile/utils/extensions.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final HomeProvider _homeProvider = HomeProvider();
  Rx<UserTypeEnum> selectedUser = UserTypeEnum.clerk.obs;

  void onUserChanged(UserTypeEnum userType) {
    selectedUser.value = userType;
  }

  RxBool isCreating = false.obs;
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController govIdController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController departmentNameController = TextEditingController();

  String selectedDepartmentId = '';

  QueryDocumentSnapshot<Object?>? userData;

  Future<void> fetchDetails() async {
    userData = await _homeProvider.getServantFromGovId(
      govId: govIdController.text,
      dob: dobController.text,
    );
    update();
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      dobController.text =
          '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}';
    }
  }

  Future<void> createClerkOrOfficer() async {
    if (signUpFormKey.currentState!.validate()) {
      try {
        isCreating.value = true;
        await _homeProvider.signUpClerkOrOfficer(
          role: selectedUser.value,
          name: nameController.text,
          email: emailController.text,
          phoneNumber: '+91${mobileController.text}',
          governmentId: govIdController.text,
          departmentId: selectedDepartmentId,
        );
        Get.back();
        "Registration request has been sent to inspector !".successSnackbar();
      } on AppException catch (e) {
        debugPrint(e.toString());

        if (e.prefix == 'user-exist') {
          e.message?.errorSnackbar();
        }
      } finally {
        isCreating.value = false;
      }
    }
  }
}
