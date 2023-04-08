import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fts_mobile/core/services/gs_services.dart';
import 'package:fts_mobile/design/clerk-officer/co_home_view.dart';
import 'package:fts_mobile/design/clerk-officer/scan-file/scan_file_controller.dart';
import 'package:fts_mobile/design/clerk-officer/scan-file/show_send_message.dart';
import 'package:fts_mobile/design/components/c_core_button.dart';
import 'package:fts_mobile/design/components/c_flat_button.dart';
import 'package:fts_mobile/design/components/c_header.dart';
import 'package:fts_mobile/design/components/c_text_field.dart';
import 'package:fts_mobile/design/utils/design_utils.dart';
import 'package:fts_mobile/utils/extensions.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ScanFileView extends GetWidget<ScanFileController> {
  const ScanFileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScanFileController>(
      builder: (_) {
        return Scaffold(
          body: Column(
            children: [
              const CHeader(text: 'Scan File'),
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
                        const SizedBox(height: 20),
                        CTextField(
                          labelText: 'File ID',
                          controller: controller.fileIdController,
                          suffixIcon: CCoreButton(
                            onPressed: controller.getFile,
                            child: Icon(
                              CupertinoIcons.arrow_right_circle,
                              color: getPrimaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (controller.file != null &&
                            !controller.fetchingFile.value) ...[
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.only(top: 15),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: getColor6.withOpacity(.33)),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Column(
                              children: [
                                KeyValue('File ID', controller.file?['fileId']),
                                StreamBuilder<DocumentSnapshot>(
                                  stream: (controller.file?['citizenRef']
                                          as DocumentReference)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    log((controller.file?['fileTracking']
                                            as List)
                                        .length
                                        .toString());
                                    if (snapshot.hasError) {
                                      return const Text('Something went wrong');
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Text("Loading");
                                    }

                                    return KeyValue(
                                      'Citizen Name',
                                      snapshot.data?['name'],
                                    );
                                  },
                                ),
                                if (controller.file?['createdAt'] != null)
                                  KeyValue(
                                      'Created On',
                                      (controller.file?['createdAt']
                                              as Timestamp)
                                          .format()),
                                const SizedBox(height: 15),
                              ],
                            ),
                          ),
                          if (controller.file?['fileTracking'] != null &&
                              (controller.file?['fileTracking'] as List)
                                  .isNotEmpty)
                            for (int i = 0;
                                i <
                                    (controller.file?['fileTracking'] as List)
                                        .length;
                                i++)
                              StreamBuilder<DocumentSnapshot>(
                                stream: (controller.file?['fileTracking'][i]
                                        ['servantRef'] as DocumentReference)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text('Something went wrong');
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text("Loading");
                                  }

                                  return TimelineTile(
                                    alignment: TimelineAlign.manual,
                                    lineXY: 0.1,
                                    indicatorStyle: IndicatorStyle(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      color: i ==
                                              (controller.file?['fileTracking']
                                                          as List)
                                                      .length -
                                                  1
                                          ? getPrimaryColor
                                          : i == 0
                                              ? getColor3.withOpacity(.5)
                                              : greenColor,
                                    ),
                                    afterLineStyle:
                                        const LineStyle(thickness: 2),
                                    beforeLineStyle:
                                        const LineStyle(thickness: 2),
                                    isFirst: i == 0,
                                    isLast: i ==
                                        (controller.file?['fileTracking']
                                                    as List)
                                                .length -
                                            1,
                                    endChild: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        StreamBuilder<DocumentSnapshot>(
                                          stream:
                                              (snapshot.data?['departmentRef']
                                                      as DocumentReference)
                                                  .snapshots(),
                                          builder: (context, innersnapshot) {
                                            if (innersnapshot.hasError) {
                                              return const Text(
                                                  'Something went wrong');
                                            }

                                            if (innersnapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Text("Loading");
                                            }

                                            return Text(
                                              snapshot.data?['name'] +
                                                  ' (' +
                                                  innersnapshot.data?['name'] +
                                                  ')',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            if (controller.file?['fileTracking']
                                                    [i]['startTime'] !=
                                                null)
                                              Text(
                                                (controller.file?[
                                                                'fileTracking']
                                                            [i]['startTime']
                                                        as Timestamp)
                                                    .format(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            const Text('  --  '),
                                            if (controller.file?['fileTracking']
                                                    [i]['endTime'] !=
                                                null)
                                              Text(
                                                (controller.file?[
                                                                'fileTracking']
                                                            [i]['endTime']
                                                        as Timestamp)
                                                    .format(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            if (controller.file?['fileTracking']
                                                        [i]['startTime'] !=
                                                    null &&
                                                controller.file?['fileTracking']
                                                        [i]['endTime'] ==
                                                    null)
                                              const Text(
                                                'WORKING',
                                                style: TextStyle(
                                                  color: orangeColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )
                                          ],
                                        ),
                                      ],
                                    ).only(t: 35, l: 15),
                                  );
                                },
                              ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: CFlatButton(
                                  height: 50,
                                  text: 'SUBMIT',
                                  bgColor: greenColor,
                                  onPressed: controller.submitFile,
                                ),
                              ),
                              const SizedBox(width: 20),
                              CCoreButton(
                                onPressed: () {
                                  showCupertinoModalBottomSheet(
                                    expand: false,
                                    context: context,
                                    barrierColor:
                                        getPrimaryColor.withOpacity(.5),
                                    builder: (context) {
                                      return const ShowSendMessage();
                                    },
                                  );
                                },
                                child: const Icon(
                                  CupertinoIcons.paperplane_fill,
                                  color: CupertinoColors.activeBlue,
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (controller.file?['fileTracking'] != null &&
                              (controller.file?['fileTracking'] as List)
                                  .isNotEmpty &&
                              (controller.file?['fileTracking'] as List)
                                      .last['servantRef'] ==
                                  controller.homeProvider.servants.doc(
                                    GSServices.getCurrentUserData()?['id'],
                                  ))
                            CFlatButton(
                              height: 50,
                              width: 150,
                              bgColor: redColor,
                              text: 'DISPOSE FILE',
                              onPressed: controller.disposeFile,
                            ),
                          const SizedBox(height: 15),
                        ] else if (controller.fetchingFile.value)
                          Center(child: defaultLoader()),
                      ],
                    ).symmentric(h: horizontalPadding),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
