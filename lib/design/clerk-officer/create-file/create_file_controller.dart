import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fts_mobile/core/providers/home_provider.dart';
import 'package:fts_mobile/core/routes/app_pages.dart';
import 'package:fts_mobile/core/services/base_services.dart';
import 'package:fts_mobile/utils/extensions.dart';
import 'package:get/get.dart';

class CreateFileController extends GetxController {
  final HomeProvider _homeProvider = HomeProvider();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController citizenNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController citizenEmailController = TextEditingController();
  TextEditingController fileIdController = TextEditingController();
  TextEditingController citizenMobileController = TextEditingController();
  TextEditingController fileTypeController = TextEditingController();
  String selectedFileTypeId = '';

  RxBool isFileCreating = false.obs;

  Future<void> createFile() async {
    if (formKey.currentState!.validate()) {
      try {
        isFileCreating.value = true;

        final DocumentReference<Object?> createdCitizen =
            await _homeProvider.createOrUpdateCitizen(
          name: citizenNameController.text.trim(),
          email: citizenEmailController.text.trim(),
          phoneNumber: '+91${citizenMobileController.text.trim()}',
        );

        final DocumentSnapshot<Object?> fileAssignee =
            await _homeProvider.fixed.doc(selectedFileTypeId).get();

        await _homeProvider.createFile(
          citizenId: createdCitizen.id,
          fileTypeRefId: selectedFileTypeId,
          fileId: fileIdController.text.trim(),
          fileTracking: fileAssignee['assignee'],
          description: descriptionController.text.trim(),
        );

        Get.back();
        "File has been created !".successSnackbar();
      } on AppException catch (e) {
        if (e.prefix == 'file-exist') {
          e.message?.infoSnackbar();
        }
        debugPrint(e.toString());
      } finally {
        isFileCreating.value = false;
      }
    }
  }

  Future<void> navigateToScanner() async {
    fileIdController.text =
        (await Get.toNamed(Routes.SCANFILESCANNER))?['data'];
  }
}
