import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fts_mobile/core/providers/home_provider.dart';
import 'package:fts_mobile/core/routes/app_pages.dart';
import 'package:fts_mobile/core/services/gs_services.dart';
import 'package:fts_mobile/utils/extensions.dart';
import 'package:get/get.dart';

class ScanFileController extends GetxController {
  final HomeProvider homeProvider = HomeProvider();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController fileIdController = TextEditingController();
  RxBool fetchingFile = false.obs;

  QueryDocumentSnapshot<Object?>? file;
  Future<QueryDocumentSnapshot<Object?>?> getFile() async {
    if (formKey.currentState!.validate()) {
      try {
        fetchingFile.value = true;
        file = await homeProvider.getFileFromId(
            fileId: fileIdController.text.trim());
        update();
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        fetchingFile.value = false;
      }
    }
    return null;
  }

  Future<void> submitFile() async {
    try {
      final QueryDocumentSnapshot<Object?>? currentUserDoc =
          await homeProvider.getCurrentUserDocument();

      dynamic fileTrackingArray =
          (await homeProvider.files.doc(file!.id).get()).data();

      if (fileTrackingArray != null && currentUserDoc != null) {
        fileTrackingArray['fileTracking'] =
            (fileTrackingArray['fileTracking'] as List).map((e) {
          if (e['servantRef'] ==
              HomeProvider()
                  .servants
                  .doc(GSServices.getCurrentUserData()?['id'])) {
            (e as Map).containsKey('startTime')
                ? e['endTime'] = Timestamp.now()
                : e['startTime'] = Timestamp.now();
          }
          return e;
        }).toList();

        await homeProvider.files.doc(file!.id).update({
          'fileTracking': fileTrackingArray['fileTracking'],
        });

        Get.back();
        "File Submitted Successfully".successSnackbar();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> disposeFile() async {
    try {
      await submitFile();
      await homeProvider.files.doc(file!.id).update({'fileClosed': true});
      Get.back();
      "File Disposed Successfully".successSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> navigateToScanner() async {
    fileIdController.text =
        (await Get.toNamed(Routes.SCANFILESCANNER))?['data'];
    await getFile();
  }

  TextEditingController messageController = TextEditingController();
  RxBool isUrgent = false.obs;

  Future<void> sendMessage() async {
    if (messageController.text.isEmpty) {
      return "Message is required".errorSnackbar();
    }
    await homeProvider.requestDocument(
      isUrgent: isUrgent.value,
      citizenRef: file!['citizenRef'],
      message: messageController.text.trim(),
    );
    Get.back();
    "Request has been raised.".successSnackbar();
  }
}
