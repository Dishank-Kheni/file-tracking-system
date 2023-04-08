import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fts_mobile/core/providers/home_provider.dart';
import 'package:fts_mobile/core/routes/app_pages.dart';
import 'package:fts_mobile/core/services/gs_services.dart';
import 'package:fts_mobile/core/utils/core_constants.dart';
import 'package:fts_mobile/design/citizen/c_home_controller.dart';
import 'package:fts_mobile/design/citizen/show_timeline.dart';
import 'package:fts_mobile/design/clerk-officer/co_home_view.dart';
import 'package:fts_mobile/design/components/c_core_button.dart';
import 'package:fts_mobile/design/components/c_header.dart';
import 'package:fts_mobile/design/utils/design_utils.dart';
import 'package:fts_mobile/utils/extensions.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rive/rive.dart';

class CHomeView extends StatelessWidget {
  const CHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          _AppBar(),
          _CitizenFilesList(),
        ],
      ),
    );
  }
}

class _CitizenFilesList extends StatelessWidget {
  const _CitizenFilesList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: HomeProvider()
          .files
          .where('citizenRef',
              isEqualTo: HomeProvider()
                  .citizens
                  .doc(GSServices.getCurrentUserData()?['id']))
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        final List<QueryDocumentSnapshot<Object?>> fileList =
            (snapshot.data?.docs as List<QueryDocumentSnapshot<Object?>>);

        return ListView.builder(
          shrinkWrap: true,
          physics: defaultPhysics,
          itemCount: fileList.length,
          itemBuilder: (context, index) {
            return CCoreButton(
              onPressed: () {
                showCupertinoModalBottomSheet(
                  context: context,
                  barrierColor: getPrimaryColor.withOpacity(.5),
                  builder: (context) {
                    return ShowTimeline(
                      fileId: fileList[index]['fileId'],
                    );
                  },
                );
              },
              child: Container(
                margin: const EdgeInsets.only(
                  bottom: 10,
                  left: horizontalPadding,
                  right: horizontalPadding,
                ),
                padding: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: getColor6.withOpacity(.33)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      fileList[index]['fileClosed'] ? 'CLOSED' : 'OPEN',
                      style: TextStyle(
                        color: fileList[index]['fileClosed']
                            ? greenColor
                            : yellowColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ).symmentric(h: 15),
                    const SizedBox(height: 2),
                    KeyValue('File ID', fileList[index]['fileId']),
                    if (fileList[index]['createdAt'] != null)
                      KeyValue('Created On',
                          (fileList[index]['createdAt'] as Timestamp).format()),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _AppBar extends GetWidget<CHomeController> {
  const _AppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? currentUser = GSServices.getCurrentUserData();
    return StreamBuilder<DocumentSnapshot>(
      stream: HomeProvider().citizens.doc(currentUser?['id']).snapshots(),
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
                onPressed: () => Get.toNamed(Routes.CMESSAGE),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: getColor21,
                  child: const Icon(
                    CupertinoIcons.bell_fill,
                    size: 20,
                    color: Colors.amber,
                  ),
                ),
              ),
              const SizedBox(width: 5),
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
            ],
          ).symmentric(h: horizontalPadding),
        );
      },
    );
  }
}
