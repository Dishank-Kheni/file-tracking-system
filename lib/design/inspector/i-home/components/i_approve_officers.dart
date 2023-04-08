import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fts_mobile/core/providers/home_provider.dart';
import 'package:fts_mobile/core/services/gs_services.dart';
import 'package:fts_mobile/design/components/on_hover.dart';
import 'package:fts_mobile/design/inspector/i-home/components/i_approve_officers_controller.dart';
import 'package:fts_mobile/design/utils/design_utils.dart';
import 'package:fts_mobile/utils/enums.dart';
import 'package:fts_mobile/utils/extensions.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class IApproveOfficers extends GetWidget<IApproveOfficersController> {
  const IApproveOfficers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: IApproveOfficersController(),
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
                    title: 'Approve Officers',
                    officerStatus: OfficerStatus.approve,
                  ),
                  const _FileTypeToggle(
                    title: 'Rejected Officers',
                    officerStatus: OfficerStatus.rejected,
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
                child: _OfficerListView(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OfficerListView extends GetWidget<IApproveOfficersController> {
  const _OfficerListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? currentUser = GSServices.getCurrentUserData();

    return Obx(
      () => CupertinoScrollbar(
        child: StreamBuilder<QuerySnapshot>(
          stream: HomeProvider()
              .servants
              .where('departmentRef',
                  isEqualTo: HomeProvider()
                      .departments
                      .doc(currentUser?['departmentId']))
              .where('isApproved', isEqualTo: false)
              .where('isRejected',
                  isEqualTo:
                      controller.officerStatus.value == OfficerStatus.approve
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
            return ListView.builder(
              itemCount: snapshot.data?.size,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final QueryDocumentSnapshot<Object?>? officerDetails =
                    snapshot.data?.docs[index];
                return OnHover(
                  onTap: () {},
                  builder: (isHovered, _) {
                    return Container(
                      decoration: BoxDecoration(
                        color: isHovered ? hoverColor : null,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '0${index + 1}',
                              style: TextThemeX.text11.copyWith(
                                color: getPrimaryTextColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: getNunitoFontFamily,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              officerDetails?['governmentId'] ?? 'N/A',
                              style: TextThemeX.text11.copyWith(
                                color: getPrimaryColor,
                                fontFamily: getNunitoFontFamily,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              officerDetails?['name'] ?? 'N/A',
                              style: TextThemeX.text11.copyWith(
                                color: getPrimaryTextColor,
                                fontFamily: getNunitoFontFamily,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              officerDetails?['dob'] ?? 'N/A',
                              style: TextThemeX.text11.copyWith(
                                color: getPrimaryTextColor,
                                fontFamily: getNunitoFontFamily,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              officerDetails?['contactNumber'] ?? 'N/A',
                              style: TextThemeX.text11.copyWith(
                                color: getPrimaryTextColor,
                                fontFamily: getNunitoFontFamily,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              officerDetails?['email'] ?? 'N/A',
                              style: TextThemeX.text11.copyWith(
                                color: getPrimaryTextColor,
                                fontFamily: getNunitoFontFamily,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OnHover(
                                  onTap: () {
                                    HomeProvider()
                                        .servants
                                        .doc(officerDetails?.id)
                                        .update({
                                      'isApproved': true,
                                      'isRejected': false,
                                    });
                                  },
                                  builder: (isHovered, _) {
                                    return CircleAvatar(
                                      radius: 10,
                                      backgroundColor: greenColor
                                          .withOpacity(isHovered ? .4 : .2),
                                      child: const Icon(
                                        CupertinoIcons.checkmark_alt,
                                        color: greenColor,
                                        size: 13,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 10),
                                if (controller.officerStatus.value ==
                                    OfficerStatus.approve)
                                  OnHover(
                                    onTap: () {
                                      HomeProvider()
                                          .servants
                                          .doc(officerDetails?.id)
                                          .update({
                                        'isRejected': true,
                                      });
                                    },
                                    builder: (isHovered, _) {
                                      return CircleAvatar(
                                        radius: 10,
                                        backgroundColor: redColor
                                            .withOpacity(isHovered ? .4 : .2),
                                        child: const Icon(
                                          CupertinoIcons.clear,
                                          color: redColor,
                                          size: 13,
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                        ],
                      ).only(l: 20, b: 10, t: 10),
                    );
                  },
                );
              },
            );
          },
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
        _HeaderText(text: 'Gov. ID'),
        _HeaderText(text: 'Officer', flex: 2),
        _HeaderText(text: 'D.O.B', flex: 2),
        _HeaderText(text: 'Phone Number', flex: 2),
        _HeaderText(text: 'E-mail', flex: 2),
        _HeaderText(text: 'Actions', flex: 1),
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

class _FileTypeToggle extends GetWidget<IApproveOfficersController> {
  final String title;
  final OfficerStatus officerStatus;
  const _FileTypeToggle({
    Key? key,
    required this.title,
    required this.officerStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnHover(
      onTap: () => controller.officerStatus.value = officerStatus,
      builder: (isHovered, _) {
        return Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            decoration: BoxDecoration(
              color: isHovered &&
                      !(officerStatus == controller.officerStatus.value)
                  ? hoverColor
                  : officerStatus == controller.officerStatus.value
                      ? getPrimaryColor
                      : getColor21,
              border: officerStatus == controller.officerStatus.value
                  ? null
                  : Border.all(color: getColor23),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                    officerStatus == OfficerStatus.approve ? 10 : 0),
                bottomLeft: Radius.circular(
                    officerStatus == OfficerStatus.approve ? 10 : 0),
                topRight: Radius.circular(
                    officerStatus == OfficerStatus.rejected ? 10 : 0),
                bottomRight: Radius.circular(
                    officerStatus == OfficerStatus.rejected ? 10 : 0),
              ),
            ),
            child: Text(
              title,
              style: TextThemeX.text10.copyWith(
                color: officerStatus == controller.officerStatus.value
                    ? getColor21
                    : getPrimaryTextColor,
                fontWeight: officerStatus == controller.officerStatus.value
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
