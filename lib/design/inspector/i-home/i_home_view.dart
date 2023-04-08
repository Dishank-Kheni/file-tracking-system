import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fts_mobile/core/providers/auth_provider.dart';
import 'package:fts_mobile/core/providers/home_provider.dart';
import 'package:fts_mobile/core/services/gs_services.dart';
import 'package:fts_mobile/design/components/on_hover.dart';
import 'package:fts_mobile/design/inspector/i-home/components/i_approve_officers.dart';
import 'package:fts_mobile/design/inspector/i-home/components/i_files_list.dart';
import 'package:fts_mobile/design/inspector/i-home/components/i_officer_list.dart';
import 'package:fts_mobile/design/inspector/i-home/i_home_controller.dart';
import 'package:fts_mobile/design/utils/design_utils.dart';
import 'package:fts_mobile/utils/enums.dart';
import 'package:fts_mobile/utils/extensions.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';

class IHomeView extends GetWidget<IHomeController> {
  const IHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Expanded(
            flex: 2,
            child: _Drawer(),
          ),
          Expanded(
            flex: 10,
            child: Container(
              color: getBgColor,
              child: Obx(
                () => Column(
                  children: [
                    const _AppBar(),
                    Divider(color: getColor11, height: 0),
                    const _Header(),
                    if (controller.selectedMenu.value ==
                        InspectorHomeMenu.files)
                      const Expanded(child: IFilesList()),
                    if (controller.selectedMenu.value ==
                        InspectorHomeMenu.officers)
                      const Expanded(child: IOfficerList()),
                    if (controller.selectedMenu.value ==
                        InspectorHomeMenu.approveOfficers)
                      const Expanded(child: IApproveOfficers()),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _Header extends GetWidget<IHomeController> {
  const _Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: getColor21,
      child: Row(
        children: [
          // Text(
          //   'Dashboard',
          //   style: TextThemeX.text12.copyWith(
          //     color: getColor11,
          //     fontFamily: getPoppinsFontFamily,
          //   ),
          // ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffF3F6F9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Text(
                  'Today',
                  style: TextThemeX.text12.copyWith(
                    color: getColor11,
                    fontWeight: FontWeight.w400,
                    fontFamily: getPoppinsFontFamily,
                  ),
                ),
                const SizedBox(width: 3),
                Text(
                  DateFormat('MMM dd').format(DateTime.now()),
                  style: TextThemeX.text12.copyWith(
                    color: const Color(0xff5880D4),
                    fontWeight: FontWeight.w400,
                    fontFamily: getPoppinsFontFamily,
                  ),
                ),
              ],
            ),
          ),
        ],
      ).symmentric(v: 5, h: 20),
    );
  }
}

class _AppBar extends GetWidget<IHomeController> {
  const _AppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? currentUser = GSServices.getCurrentUserData();

    return StreamBuilder<DocumentSnapshot>(
        stream: HomeProvider().servants.doc(currentUser?['id']).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          return Container(
            color: getColor21,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(CupertinoIcons.search, size: 19),
                const SizedBox(width: 10),
                const Icon(CupertinoIcons.bell, size: 19),
                const SizedBox(width: 10),
                const Icon(CupertinoIcons.chart_pie, size: 19),
                const SizedBox(width: 20),
                selectImage(AppImages.india, width: 25, height: 25),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, ${snapshot.data?['name']}',
                      style: TextThemeX.text12.copyWith(
                        color: lPrimaryTextColor,
                        fontFamily: getPoppinsFontFamily,
                      ),
                    ),
                    Text(
                      '${snapshot.data?['role']}',
                      style: TextThemeX.text10.copyWith(
                        color: lPrimaryColor,
                        fontFamily: getPoppinsFontFamily,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Container(
                  width: 25,
                  height: 25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xffC9F1EF),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    '${snapshot.data?['name'].substring(0, 1)}',
                    style: TextThemeX.text14.copyWith(
                      color: const Color(0xff33CCC5),
                      fontFamily: getPoppinsFontFamily,
                    ),
                  ),
                ),
              ],
            ).symmentric(v: 10, h: 20),
          );
        });
  }
}

class _Drawer extends GetWidget<IHomeController> {
  const _Drawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: getColor21,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          const _Logo(),
          const SizedBox(height: 30),
          // _Item(
          //     icon: AppIcons.dashboard,
          //     title: 'Dashboard',
          //     menuItem: InspectorHomeMenu.dashboard),
          _Item(
              icon: AppIcons.files,
              title: 'Files',
              menuItem: InspectorHomeMenu.files),
          _Item(
              icon: AppIcons.approveUser,
              title: 'Officer Requests',
              menuItem: InspectorHomeMenu.approveOfficers),
          _Item(
              icon: AppIcons.officer,
              title: 'Officers',
              menuItem: InspectorHomeMenu.officers),
          _Item(
              icon: AppIcons.logout,
              title: 'Log out',
              menuItem: InspectorHomeMenu.logout),
        ],
      ),
    );
  }
}

class _Item extends GetWidget<IHomeController> {
  final String icon;
  final String title;
  final InspectorHomeMenu menuItem;
  const _Item({
    Key? key,
    required this.icon,
    required this.title,
    required this.menuItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnHover(
      onTap: () async {
        controller.selectedMenu.value = menuItem;
        if (controller.selectedMenu.value == InspectorHomeMenu.logout) {
          AuthProvider().signOut();
        }
      },
      builder: (isHovered, __) {
        return Obx(
          () => Container(
            decoration: BoxDecoration(
              color: isHovered && icon == AppIcons.logout
                  ? redColor.withOpacity(.1)
                  : isHovered && !(controller.selectedMenu.value == menuItem)
                      ? hoverColor
                      : null,
              gradient: controller.selectedMenu.value == menuItem
                  ? LinearGradient(
                      colors: [
                        const Color(0xffaba8ff).withOpacity(.3),
                        const Color(0x00aba8ff).withOpacity(.05)
                      ],
                      stops: const [0, 0.2],
                    )
                  : null,
            ),
            child: Row(
              children: [
                selectIcon(
                  icon,
                  width: 17,
                  color: icon == AppIcons.logout
                      ? redColor
                      : controller.selectedMenu.value == menuItem
                          ? lPrimaryColor
                          : getColor14.withOpacity(.5),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextThemeX.text12.copyWith(
                    fontFamily: getNunitoFontFamily,
                    color: controller.selectedMenu.value == menuItem
                        ? lPrimaryColor
                        : getColor14.withOpacity(.5),
                  ),
                ),
              ],
            ).only(b: 15, l: 40, t: 15),
          ),
        );
      },
    );
  }
}

class _Logo extends GetWidget<IHomeController> {
  const _Logo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        selectImage(setldImageIcon(AppImages.logo), height: 40),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'FILE',
              style: TextThemeX.text22.copyWith(
                color: getColor11,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
                fontFamily: getPoppinsFontFamily,
              ),
            ),
            Text(
              'TRACKER',
              style: TextThemeX.text10.copyWith(
                color: getColor11,
                height: 0.1,
                fontWeight: FontWeight.w600,
                fontFamily: getPoppinsFontFamily,
              ),
            ),
          ],
        ).only(b: 10),
      ],
    );
  }
}
