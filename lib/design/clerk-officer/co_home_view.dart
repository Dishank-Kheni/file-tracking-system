import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fts_mobile/core/providers/home_provider.dart';
import 'package:fts_mobile/core/routes/app_pages.dart';
import 'package:fts_mobile/core/services/gs_services.dart';
import 'package:fts_mobile/core/utils/core_constants.dart';
import 'package:fts_mobile/design/clerk-officer/co_home_controller.dart';
import 'package:fts_mobile/design/components/c_core_button.dart';
import 'package:fts_mobile/design/components/c_header.dart';
import 'package:fts_mobile/design/utils/design_utils.dart';
import 'package:fts_mobile/utils/enums.dart';
import 'package:fts_mobile/utils/extensions.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

class COHomeView extends StatefulWidget {
  const COHomeView({Key? key}) : super(key: key);

  @override
  State<COHomeView> createState() => _COHomeViewState();
}

class _COHomeViewState extends State<COHomeView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if (tabController.index == 0) {
        Get.find<COHomeController>().selectedTab.value = 'ongoing';
      } else {
        Get.find<COHomeController>().selectedTab.value = 'completed';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        child: Column(
          children: [
            const _AppBar(),
            const SizedBox(height: 25),
            _TabControl(tabController),
            const SizedBox(height: 10),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: TabBarView(
                  controller: tabController,
                  children: const [
                    _OngoingFilesList(),
                    _CompletedFilesList(),
                  ],
                ),
              ),
            ),
            SizedBox(height: context.bottomPadding),
          ],
        ),
      ),
    );
  }
}

class _CompletedFilesList extends StatelessWidget {
  const _CompletedFilesList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: HomeProvider().files.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        final List<QueryDocumentSnapshot<Object?>> fileList = (snapshot
                .data?.docs as List<QueryDocumentSnapshot<Object?>>)
            .where((file) =>
                (file['fileTracking'] as List).firstWhere(
                    (ft) =>
                        ft['servantRef'] ==
                            HomeProvider()
                                .servants
                                .doc(GSServices.getCurrentUserData()?['id']) &&
                        ft['startTime'] != null &&
                        ft['endTime'] != null,
                    orElse: () => false) !=
                false)
            .toList();

        return ListView.builder(
          physics: defaultPhysics,
          itemCount: fileList.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(
                bottom: 10,
                left: horizontalPadding,
                right: horizontalPadding,
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                border: Border.all(color: getColor6.withOpacity(.33)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  KeyValue('File ID', fileList[index]['fileId']),
                  StreamBuilder<DocumentSnapshot>(
                    stream: (fileList[index]['citizenRef'] as DocumentReference)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading");
                      }

                      return KeyValue('Citizen Name', snapshot.data?['name']);
                    },
                  ),
                  if (fileList[index]['createdAt'] != null)
                    KeyValue('Created On',
                        (fileList[index]['createdAt'] as Timestamp).format()),
                  // if (fileList[index]['fileTracking'] != null &&
                  //     (fileList[index]['fileTracking'] as List).isNotEmpty)
                  //   KeyValue(
                  //       'Last Scanned',
                  //       ((fileList[index]['fileTracking'] as List).last['time']
                  //               as Timestamp)
                  //           .format()),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _OngoingFilesList extends StatelessWidget {
  const _OngoingFilesList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: HomeProvider()
          .files
          .where('fileClosed', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        final List<QueryDocumentSnapshot<Object?>> fileList = (snapshot
                .data?.docs as List<QueryDocumentSnapshot<Object?>>)
            .where((file) =>
                (file['fileTracking'] as List).firstWhere(
                    (ft) =>
                        ft['servantRef'] ==
                            HomeProvider()
                                .servants
                                .doc(GSServices.getCurrentUserData()?['id']) &&
                        ft['startTime'] != null &&
                        ft['endTime'] == null,
                    orElse: () => false) !=
                false)
            .toList();

        return ListView.builder(
          physics: defaultPhysics,
          itemCount: fileList.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(
                bottom: 10,
                left: horizontalPadding,
                right: horizontalPadding,
              ),
              padding: const EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                border: Border.all(color: getColor6.withOpacity(.33)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  KeyValue('File ID', fileList[index]['fileId']),
                  StreamBuilder<DocumentSnapshot>(
                    stream: (fileList[index]['citizenRef'] as DocumentReference)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading");
                      }

                      return KeyValue(
                        'Citizen Name',
                        snapshot.data?['name'],
                      );
                    },
                  ),
                  if (fileList[index]['createdAt'] != null)
                    KeyValue('Created On',
                        (fileList[index]['createdAt'] as Timestamp).format()),
                  // if (fileList[index]['fileTracking'] != null ||
                  //     (fileList[index]['fileTracking'] as List).isNotEmpty)
                  //   KeyValue(
                  //       'Last Scanned',
                  //       ((fileList[index]['fileTracking'] as List).last['time']
                  //               as Timestamp)
                  //           .format()),
                  const SizedBox(height: 15),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class KeyValue extends StatelessWidget {
  final String key1;
  final String value;
  const KeyValue(
    this.key1,
    this.value, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          child: Text(
            '$key1:',
            style: TextThemeX.text14.copyWith(
              color: getPrimaryTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 9,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextThemeX.text14.copyWith(
              color: getPrimaryTextColor,
              // fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ).symmentric(h: 15);
  }
}

class _TabControl extends GetWidget<COHomeController> {
  final TabController tabController;
  const _TabControl(this.tabController);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return CupertinoSlidingSegmentedControl<String>(
          onValueChanged: (value) {
            if (value != null) {
              controller.selectedTab.value = value;
              if (value == 'ongoing') {
                tabController.animateTo(0);
              } else {
                tabController.animateTo(1);
              }
            }
          },
          thumbColor: getPrimaryColor,
          groupValue: controller.selectedTab.value,
          children: {
            'ongoing': Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'ONGOING FILES',
                style: TextStyle(
                  color: controller.selectedTab.value == 'ongoing'
                      ? getColor21
                      : getColor11,
                ),
              ),
            ),
            'completed': Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'COMPETED FILES',
                style: TextStyle(
                  color: controller.selectedTab.value == 'completed'
                      ? getColor21
                      : getColor11,
                ),
              ),
            ),
          },
        );
      },
    );
  }
}

class _AppBar extends GetWidget<COHomeController> {
  const _AppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? currentUser = GSServices.getCurrentUserData();
    log(currentUser.toString());
    return StreamBuilder<DocumentSnapshot>(
      stream: HomeProvider().servants.doc(currentUser?['id']).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return CHeader(
          child: Row(
            children: [
              if (isNullEmptyOrFalse(snapshot.data?['image']))
                SizedBox(
                  width: 45,
                  height: 45,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6.5),
                    child: RiveAnimation.asset(
                      AppAnimations.person1,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              if (!isNullEmptyOrFalse(snapshot.data?['image']))
                networkImage(
                  width: 45,
                  height: 45,
                  borderRadius: 6.5,
                  image: snapshot.data?['image'],
                ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    snapshot.data?['name'],
                    style: TextThemeX.text14.copyWith(
                      color: getColor21,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    snapshot.data?['role'],
                    style: TextThemeX.text11.copyWith(
                      height: 0.9,
                      color: getColor22,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              CCoreButton(
                onPressed: controller.logOut,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: getColor21,
                  child: const Icon(
                    Icons.logout_rounded,
                    size: 20,
                    color: redColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CCoreButton(
                onPressed: () => Get.toNamed(Routes.SCANFILE),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: getColor21,
                  child: Icon(
                    CupertinoIcons.qrcode_viewfinder,
                    size: 20,
                    color: getColor13,
                  ),
                ),
              ),
              if ((snapshot.data?['role'] == UserTypeEnum.clerk.toMap() &&
                      snapshot.data?['canCreateFile']) ||
                  snapshot.data?['role'] == UserTypeEnum.officer.toMap()) ...[
                const SizedBox(width: 8),
                CCoreButton(
                  onPressed: () => Get.toNamed(Routes.CREATEFILE),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: getColor21,
                    child: Icon(
                      CupertinoIcons.add,
                      size: 20,
                      color: getColor13,
                    ),
                  ),
                ),
              ],
            ],
          ).symmentric(h: horizontalPadding),
        );
      },
    );
  }
}
