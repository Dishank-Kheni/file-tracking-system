import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fts_mobile/core/providers/home_provider.dart';
import 'package:fts_mobile/core/services/gs_services.dart';
import 'package:fts_mobile/design/components/c_core_button.dart';
import 'package:fts_mobile/design/components/on_hover.dart';
import 'package:fts_mobile/design/inspector/i-home/components/i_file_list_controller.dart';
import 'package:fts_mobile/design/utils/design_utils.dart';
import 'package:fts_mobile/utils/enums.dart';
import 'package:fts_mobile/utils/extensions.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:timeline_tile/timeline_tile.dart';

class IFilesList extends GetWidget<IFileListController> {
  const IFilesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: IFileListController(),
      builder: (controller) {
        return Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 35, 10),
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: getColor21,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const _FileTypeToggle(
                    title: 'Ongoing Files',
                    fileTypes: FileTypes.ongoings,
                  ),
                  const _FileTypeToggle(
                    title: 'Completed Files',
                    fileTypes: FileTypes.completed,
                  ),
                  const Spacer(),
                  Text(
                    'See More',
                    style: TextThemeX.text10.copyWith(
                      color: getPrimaryColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: getNunitoFontFamily,
                    ),
                  ),
                ],
              ).only(r: 40),
              const SizedBox(height: 30),
              const _Header(),
              const SizedBox(height: 15),
              const Expanded(
                child: _FileListView(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FileListView extends GetWidget<IFileListController> {
  const _FileListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? currentUser = GSServices.getCurrentUserData();

    return Obx(
      () => CupertinoScrollbar(
        child: StreamBuilder<QuerySnapshot>(
            stream: HomeProvider()
                .files
                .where('fileClosed',
                    isEqualTo: controller.fileType.value == FileTypes.ongoings
                        ? false
                        : true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }

              final List<QueryDocumentSnapshot<Object?>> fileList =
                  (snapshot.data?.docs as List<QueryDocumentSnapshot<Object?>>)
                      .where((file) =>
                          (file['fileTracking'] as List).firstWhere(
                              (ft) =>
                                  ft['departmentRef'] ==
                                  HomeProvider()
                                      .departments
                                      .doc(currentUser?['departmentId']),
                              orElse: () => false) !=
                          false)
                      .toList();

              return ListView.builder(
                itemCount: fileList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return _FileDetailsTile(
                    file: fileList[index],
                    index: index,
                  );
                },
              );
            }),
      ),
    );
  }
}

class _FileDetailsTile extends StatefulWidget {
  final int index;
  final QueryDocumentSnapshot<Object?> file;
  const _FileDetailsTile({
    Key? key,
    required this.index,
    required this.file,
  }) : super(key: key);

  @override
  State<_FileDetailsTile> createState() => _FileDetailsTileState();
}

class _FileDetailsTileState extends State<_FileDetailsTile> {
  RxBool isExpanded = false.obs;

  @override
  void initState() {
    super.initState();
    getCustomerDetails();
  }

  String customerName = 'N/A';
  String customerEmail = 'N/A';

  Future<void> getCustomerDetails() async {
    final DocumentSnapshot citizenData = await HomeProvider()
        .getCitizenFromDocRef(
            citizenRef: widget.file['citizenRef'] as DocumentReference);

    setState(() {
      customerName = citizenData['name'];
      customerEmail = citizenData['email'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return CCoreButton(
      onPressed: () {
        isExpanded.value = !isExpanded.value;
      },
      child: Obx(
        () => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isExpanded.value ? getPrimaryColor.withOpacity(.1) : null,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        AnimatedContainer(
                          transformAlignment: Alignment.center,
                          duration: const Duration(milliseconds: 200),
                          transform: Matrix4.identity()
                            ..rotateZ(
                              isExpanded.value ? math.pi / 2 : 2 * math.pi,
                            ),
                          child: const Icon(
                            CupertinoIcons.arrowtriangle_right_fill,
                            size: 8,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '0${widget.index + 1}',
                          style: TextThemeX.text11.copyWith(
                            color: getPrimaryTextColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: getNunitoFontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.file['fileId'],
                      style: TextThemeX.text11.copyWith(
                        color: getPrimaryColor,
                        fontFamily: getNunitoFontFamily,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      customerName,
                      style: TextThemeX.text11.copyWith(
                        color: getPrimaryColor,
                        fontFamily: getNunitoFontFamily,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      customerEmail,
                      style: TextThemeX.text11.copyWith(
                        color: getPrimaryColor,
                        fontFamily: getNunitoFontFamily,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      (widget.file['createdAt'] as Timestamp).format(),
                      style: TextThemeX.text11.copyWith(
                        color: getPrimaryTextColor,
                        fontFamily: getNunitoFontFamily,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                ],
              ),
              if (isExpanded.value)
                if (widget.file['fileTracking'] != null &&
                    (widget.file['fileTracking'] as List).isNotEmpty)
                  SizedBox(
                          height: 90,
                          width: double.infinity,
                          child: ListView.builder(
                              itemCount:
                                  (widget.file['fileTracking'] as List).length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, i) {
                                return StreamBuilder<DocumentSnapshot>(
                                  stream: (widget.file['fileTracking'][i]
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
                                      axis: TimelineAxis.horizontal,
                                      alignment: TimelineAlign.manual,
                                      lineXY: 0.3,
                                      indicatorStyle: IndicatorStyle(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        color: i ==
                                                (widget.file['fileTracking']
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
                                          (widget.file['fileTracking'] as List)
                                                  .length -
                                              1,
                                      endChild: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        // crossAxisAlignment: CrossAxisAlignment.center,
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

                                              if (innersnapshot
                                                      .connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Text("Loading");
                                              }

                                              return Column(
                                                children: [
                                                  Text(
                                                    snapshot.data?['name']
                                                    // ' (' +
                                                    // innersnapshot.data?['name'] +
                                                    // ')'
                                                    ,
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    // snapshot.data?['name'] +
                                                    '${' (' + innersnapshot.data?['name']})',
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              if (widget.file['fileTracking'][i]
                                                      ['startTime'] !=
                                                  null)
                                                Text(
                                                  (widget.file['fileTracking']
                                                              [i]['startTime']
                                                          as Timestamp)
                                                      .format(),
                                                  style: const TextStyle(
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              const Text(
                                                '  --  ',
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              if (widget.file['fileTracking'][i]
                                                      ['endTime'] !=
                                                  null)
                                                Text(
                                                  (widget.file['fileTracking']
                                                              [i]['endTime']
                                                          as Timestamp)
                                                      .format(),
                                                  style: const TextStyle(
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              if (widget.file['fileTracking'][i]
                                                          ['startTime'] !=
                                                      null &&
                                                  widget.file['fileTracking'][i]
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
                                      ).only(t: 0, l: 15),
                                    );
                                  },
                                );
                              }),
                        )

              // for (int i = 0;
              //     i < (widget.file['fileTracking'] as List).length;
              //     i++)
            ],
          ).only(l: 20, b: 10, t: 10, r: 20),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _HeaderText(text: 'S.No.'),
        _HeaderText(text: 'FileID'),
        _HeaderText(text: 'Citizen Name', flex: 2),
        _HeaderText(text: 'E-mail', flex: 2),
        _HeaderText(text: 'Created On', flex: 3),
      ],
    ).only(l: 20);
  }
}

class _HeaderText extends StatelessWidget {
  final String text;
  final int flex;

  const _HeaderText({
    Key? key,
    required this.text,
    this.flex = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextThemeX.text11.copyWith(
          color: getPrimaryTextColor.withOpacity(.5),
          fontWeight: FontWeight.w600,
          fontFamily: getNunitoFontFamily,
        ),
      ),
    );
  }
}

class _FileTypeToggle extends GetWidget<IFileListController> {
  final String title;
  final FileTypes fileTypes;
  const _FileTypeToggle({
    Key? key,
    required this.title,
    required this.fileTypes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnHover(
      onTap: () => controller.fileType.value = fileTypes,
      builder: (isHovered, _) {
        return Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            decoration: BoxDecoration(
              color: isHovered && !(fileTypes == controller.fileType.value)
                  ? hoverColor
                  : fileTypes == controller.fileType.value
                      ? getPrimaryColor
                      : getColor21,
              border: fileTypes == controller.fileType.value
                  ? null
                  : Border.all(color: getColor23),
              borderRadius: BorderRadius.only(
                topLeft:
                    Radius.circular(fileTypes == FileTypes.ongoings ? 10 : 0),
                bottomLeft:
                    Radius.circular(fileTypes == FileTypes.ongoings ? 10 : 0),
                topRight:
                    Radius.circular(fileTypes == FileTypes.completed ? 10 : 0),
                bottomRight:
                    Radius.circular(fileTypes == FileTypes.completed ? 10 : 0),
              ),
            ),
            child: Text(
              title,
              style: TextThemeX.text10.copyWith(
                color: fileTypes == controller.fileType.value
                    ? getColor21
                    : getPrimaryTextColor,
                fontWeight: fileTypes == controller.fileType.value
                    ? FontWeight.w600
                    : FontWeight.w400,
                fontFamily: getNunitoFontFamily,
              ),
            ),
          ),
        );
      },
    );
  }
}
