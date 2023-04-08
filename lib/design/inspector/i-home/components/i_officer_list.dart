import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fts_mobile/core/providers/home_provider.dart';
import 'package:fts_mobile/core/services/gs_services.dart';
import 'package:fts_mobile/design/components/on_hover.dart';
import 'package:fts_mobile/design/inspector/i-home/components/i_officer_list_controller.dart';
import 'package:fts_mobile/design/utils/design_utils.dart';
import 'package:fts_mobile/utils/extensions.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:rive/rive.dart';

class IOfficerList extends GetWidget<IOfficerListController> {
  const IOfficerList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IOfficerListController>(
      init: IOfficerListController(),
      builder: (controller) {
        final Map<String, dynamic>? currentUser =
            GSServices.getCurrentUserData();

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: Container(
                margin: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: getColor21,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 90,
                      offset: Offset(0, 4),
                      color: Color(0x3da3abb9),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const _Header(),
                    const SizedBox(height: 15),
                    Expanded(
                      child: CupertinoScrollbar(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: HomeProvider()
                                .servants
                                .where('departmentRef',
                                    isEqualTo: HomeProvider()
                                        .departments
                                        .doc(currentUser?['departmentId']))
                                .where('isApproved', isEqualTo: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Something went wrong');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text("Loading");
                              }

                              return ListView.builder(
                                itemCount: snapshot.data?.size,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final QueryDocumentSnapshot<Object?>?
                                      officerDetails =
                                      snapshot.data?.docs[index];
                                  return _OfficerTile(
                                    index,
                                    officerDetails: officerDetails,
                                  );
                                },
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () {
                if (controller.selectedOfficerId.value.isNotEmpty) {
                  return const Expanded(
                    flex: 3,
                    child: _OfficerCard(),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        );
      },
    );
  }
}

class _OfficerTile extends GetWidget<IOfficerListController> {
  final int index;
  final QueryDocumentSnapshot<Object?>? officerDetails;
  const _OfficerTile(this.index, {Key? key, required this.officerDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnHover(
      onTap: () {
        controller.selectedOfficerId.value = officerDetails?.id ?? '';
      },
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
                  '${index + 1}',
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
                    color: getPrimaryTextColor,
                    fontWeight: FontWeight.w600,
                    fontFamily: getNunitoFontFamily,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  officerDetails?['name'] ?? 'N/A',
                  style: TextThemeX.text11.copyWith(
                    color: getPrimaryColor,
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
                flex: 3,
                child: Text(
                  officerDetails?['email'] ?? 'N/A',
                  style: TextThemeX.text11.copyWith(
                    color: getPrimaryTextColor,
                    fontFamily: getNunitoFontFamily,
                  ),
                ),
              ),
              const SizedBox(width: 15),
            ],
          ).only(l: 20, b: 10, t: 10),
        );
      },
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
        _HeaderText(text: 'Gov. Id'),
        _HeaderText(text: 'Officer Name', flex: 2),
        _HeaderText(text: 'Phone Number', flex: 2),
        _HeaderText(text: 'Email Id', flex: 3),
      ],
    ).only(l: 20);
  }
}

class _OfficerCard extends GetWidget<IOfficerListController> {
  const _OfficerCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => StreamBuilder<DocumentSnapshot>(
        stream: HomeProvider()
            .servants
            .doc(controller.selectedOfficerId.value)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: defaultLoader());
          }

          final Map officerDetails = snapshot.data?.data() as Map;

          return Container(
            margin: const EdgeInsets.fromLTRB(0, 15, 20, 20),
            padding: const EdgeInsets.fromLTRB(15, 35, 15, 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: getColor21,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3da3abb9),
                  blurRadius: 90,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13.5),
                    child: (officerDetails['image'] as String).isNotEmpty
                        ? networkImage(image: officerDetails['image'])
                        : RiveAnimation.asset(
                            AppAnimations.person1,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  officerDetails['name'] ?? 'N/A',
                  style: TextThemeX.text14.copyWith(
                    color: getPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  officerDetails['role'].toUpperCase(),
                  style: TextThemeX.text8.copyWith(
                    height: .1,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
                Divider(color: getColor24),
                KeyValueWeb('D.O.B.', officerDetails['dob']),
                Divider(color: getColor24),
                KeyValueWeb('Government ID', officerDetails['governmentId']),
                Divider(color: getColor24),
                KeyValueWeb('Phone Number', officerDetails['contactNumber']),
                Divider(color: getColor24),
                KeyValueWeb('Email', officerDetails['email']),
              ],
            ),
          );
        },
      ),
    );
  }
}

class KeyValueWeb extends StatelessWidget {
  final String key1;
  final String value;
  const KeyValueWeb(
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
            style: TextThemeX.text12.copyWith(
              color: getPrimaryTextColor.withOpacity(.5),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 9,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextThemeX.text12.copyWith(
              color: getPrimaryTextColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
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
          color: getPrimaryTextColor,
          fontWeight: FontWeight.w600,
          fontFamily: getNunitoFontFamily,
        ),
      ),
    );
  }
}
