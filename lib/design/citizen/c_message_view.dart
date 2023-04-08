import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fts_mobile/core/providers/home_provider.dart';
import 'package:fts_mobile/core/services/gs_services.dart';
import 'package:fts_mobile/design/clerk-officer/co_home_view.dart';
import 'package:fts_mobile/design/components/c_header.dart';
import 'package:fts_mobile/utils/extensions.dart';

class CMessageView extends StatelessWidget {
  const CMessageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CHeader(text: 'Messages'),
          const SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
            stream: HomeProvider().docRequests.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }

              final List<QueryDocumentSnapshot<Object?>>? dataList =
                  snapshot.data?.docs.where((element) {
                return element['citizenRef'] ==
                    HomeProvider()
                        .citizens
                        .doc(GSServices.getCurrentUserData()?['id']);
              }).toList();

              return ListView.builder(
                shrinkWrap: true,
                itemCount: dataList?.length,
                itemBuilder: (context, index) {
                  final docRequest = dataList?[index];
                  return Card(
                    child: Column(
                      children: [
                        KeyValue('Message', docRequest?['message']),
                        KeyValue(
                          'Sent On',
                          (docRequest?['createdAt'] as Timestamp).format(),
                        ),
                        StreamBuilder<DocumentSnapshot>(
                          stream:
                              (docRequest?['servantRef'] as DocumentReference)
                                  .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text("Loading");
                            }

                            return KeyValue(
                                'Officer Name', snapshot.data?['name']);
                          },
                        ),
                      ],
                    ).symmentric(v: 5, h: 5),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
