import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fts_mobile/design/citizen/c_home_controller.dart';
import 'package:fts_mobile/design/utils/design_utils.dart';
import 'package:fts_mobile/utils/extensions.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ShowTimeline extends GetWidget<CHomeController> {
  final String fileId;
  const ShowTimeline({Key? key, required this.fileId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: StreamBuilder<QuerySnapshot>(
        stream: controller.homeProvider.files
            .where('fileId', isEqualTo: fileId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          log(snapshot.data!.docs[0]['fixedRef'].toString());

          return Column(
            children: [
              if (snapshot.data!.docs[0]['fileTracking'] != null &&
                  (snapshot.data!.docs[0]['fileTracking'] as List).isNotEmpty)
                for (int i = 0;
                    i < (snapshot.data!.docs[0]['fileTracking'] as List).length;
                    i++)
                  StreamBuilder<DocumentSnapshot>(
                    stream: (snapshot.data!.docs[0]['fileTracking'][i]
                            ['servantRef'] as DocumentReference)
                        .snapshots(),
                    builder: (context, internalSnapshot) {
                      if (internalSnapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (internalSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Text("Loading");
                      }

                      return TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.1,
                        indicatorStyle: IndicatorStyle(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          color: i ==
                                  (snapshot.data!.docs[0]['fileTracking']
                                              as List)
                                          .length -
                                      1
                              ? getPrimaryColor
                              : i == 0
                                  ? getColor3.withOpacity(.5)
                                  : greenColor,
                        ),
                        afterLineStyle: const LineStyle(thickness: 2),
                        beforeLineStyle: const LineStyle(thickness: 2),
                        isFirst: i == 0,
                        isLast: i ==
                            (snapshot.data!.docs[0]['fileTracking'] as List)
                                    .length -
                                1,
                        endChild: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StreamBuilder<DocumentSnapshot>(
                              stream: (internalSnapshot.data?['departmentRef']
                                      as DocumentReference)
                                  .snapshots(),
                              builder: (context, innersnapshot) {
                                if (innersnapshot.hasError) {
                                  return const Text('Something went wrong');
                                }

                                if (innersnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text("Loading");
                                }

                                return Text(
                                  internalSnapshot.data?['name'] +
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
                                if (snapshot.data!.docs[0]['fileTracking'][i]
                                        ['startTime'] !=
                                    null)
                                  Text(
                                    (snapshot.data!.docs[0]['fileTracking'][i]
                                            ['startTime'] as Timestamp)
                                        .format(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                const Text('  --  '),
                                if (snapshot.data!.docs[0]['fileTracking'][i]
                                        ['endTime'] !=
                                    null)
                                  Text(
                                    (snapshot.data!.docs[0]['fileTracking'][i]
                                            ['endTime'] as Timestamp)
                                        .format(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                if (snapshot.data!.docs[0]['fileTracking'][i]
                                            ['startTime'] !=
                                        null &&
                                    snapshot.data!.docs[0]['fileTracking'][i]
                                            ['endTime'] ==
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
            ],
          );
        },
      ).symmentric(h: horizontalPadding, v: 20),
    );
  }
}
