import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fts_mobile/core/providers/home_provider.dart';
import 'package:fts_mobile/design/clerk-officer/create-file/create_file_controller.dart';
import 'package:fts_mobile/design/components/c_core_button.dart';
import 'package:fts_mobile/design/components/c_flat_button.dart';
import 'package:fts_mobile/design/components/c_header.dart';
import 'package:fts_mobile/design/components/c_text_field.dart';
import 'package:fts_mobile/design/utils/design_utils.dart';
import 'package:fts_mobile/design/utils/validators.dart';
import 'package:fts_mobile/utils/extensions.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CreateFileView extends GetWidget<CreateFileController> {
  const CreateFileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CHeader(text: 'Create File'),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              physics: defaultPhysics,
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    CFlatButton(
                      onPressed: controller.navigateToScanner,
                      text: 'SCAN QR CODE',
                    ).symmentric(h: 10),
                    const SizedBox(height: 30),
                    CTextField(
                      // readOnly: true,
                      labelText: 'File ID / QR Number',
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      controller: controller.fileIdController,
                      validator: AuthValidator.emptyNullValidator,
                    ).only(b: 10),
                    CTextField(
                      labelText: 'Citizen Name',
                      controller: controller.citizenNameController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      validator: AuthValidator.emptyNullValidator,
                    ).only(b: 10),
                    CTextField(
                      labelText: 'Citizen Mobile Number',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      controller: controller.citizenMobileController,
                      validator: AuthValidator.phoneValidator,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ).only(b: 10),
                    CTextField(
                      labelText: 'Citizen Email',
                      controller: controller.citizenEmailController,
                      textInputAction: TextInputAction.done,
                      validator: AuthValidator.emailValidator,
                      keyboardType: TextInputType.emailAddress,
                    ).only(b: 10),
                    CTextField(
                      readOnly: true,
                      labelText: 'File Type',
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      controller: controller.fileTypeController,
                      validator: AuthValidator.emptyNullValidator,
                      suffixIcon: Icon(
                        CupertinoIcons.chevron_down_circle,
                        size: 21,
                        color: getColor12,
                      ),
                      onTap: () {
                        showCupertinoModalBottomSheet(
                          context: context,
                          barrierColor: getPrimaryColor.withOpacity(.5),
                          builder: (context) {
                            return const _SelectFileType();
                          },
                        );
                      },
                    ).only(b: 10),
                    const SizedBox(height: 40),
                    Obx(() {
                      return CFlatButton(
                        text: 'CREATE FILE',
                        isLoading: controller.isFileCreating.value,
                        onPressed: controller.createFile,
                      ).symmentric(h: 15);
                    }),
                  ],
                ).symmentric(h: horizontalPadding),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectFileType extends GetWidget<CreateFileController> {
  const _SelectFileType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: CCoreButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextThemeX.text14.copyWith(
                color: CupertinoColors.activeBlue,
              ),
            ),
          ),
          middle: Text(
            'Select File Type',
            style: TextThemeX.text18.copyWith(
              color: getColor12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: HomeProvider().fixed.snapshots(),
          builder: (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot,
          ) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }

            return ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 15, bottom: context.bottomPadding),
              itemCount: snapshot.data!.docs.length,
              controller: ModalScrollController.of(context),
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(indent: 10, endIndent: 10, thickness: 1);
              },
              itemBuilder: (context, index) {
                final QueryDocumentSnapshot<Object?> departmentSnapshot =
                    snapshot.data!.docs[index];
                return CCoreButton(
                  alignment: Alignment.centerLeft,
                  onPressed: () {
                    controller.fileTypeController.text =
                        departmentSnapshot['fileType'];
                    controller.selectedFileTypeId = departmentSnapshot.id;
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Text(
                          departmentSnapshot['fileType'],
                          style: TextThemeX.text14.copyWith(
                            color: controller.selectedFileTypeId ==
                                    departmentSnapshot.id
                                ? greenColor
                                : blackColor1,
                          ),
                        ),
                        const Spacer(),
                        if (controller.selectedFileTypeId ==
                            departmentSnapshot.id)
                          const Icon(
                            CupertinoIcons.checkmark_alt,
                            color: greenColor,
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ).only(t: 35),
      ),
    );
  }
}
