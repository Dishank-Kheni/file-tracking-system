import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fts_mobile/core/providers/auth_provider.dart';
import 'package:fts_mobile/core/services/base_services.dart';
import 'package:fts_mobile/core/services/gs_services.dart';
import 'package:fts_mobile/utils/enums.dart';
import 'package:fts_mobile/utils/extensions.dart';

class HomeProvider with BaseService {
  HomeProvider._internal();
  factory HomeProvider() => _homeProvider;
  static final HomeProvider _homeProvider = HomeProvider._internal();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final AuthProvider _authProvider = AuthProvider();

  final CollectionReference citizens =
      FirebaseFirestore.instance.collection('citizens');
  final CollectionReference departments =
      FirebaseFirestore.instance.collection('departments');
  final CollectionReference files =
      FirebaseFirestore.instance.collection('files');
  final CollectionReference fixed =
      FirebaseFirestore.instance.collection('fixed');
  final CollectionReference servants =
      FirebaseFirestore.instance.collection('servants');
  final CollectionReference docRequests =
      FirebaseFirestore.instance.collection('docRequests');

  Future<QueryDocumentSnapshot<Object?>?> getUserFromContactNumber({
    required String phoneNumber,
  }) async {
    return await tryOrCatch<QueryDocumentSnapshot<Object?>?>(() async {
      QuerySnapshot citizensQuerySnapshot =
          await citizens.where('contactNumber', isEqualTo: phoneNumber).get();
      // log('citizensQuerySnapshot: ${citizensQuerySnapshot.docs}');
      if (citizensQuerySnapshot.docs.isNotEmpty) {
        return citizensQuerySnapshot.docs[0];
      }

      QuerySnapshot servantsQuerySnapshot =
          await servants.where('contactNumber', isEqualTo: phoneNumber).get();

      if (servantsQuerySnapshot.docs.isNotEmpty) {
        return servantsQuerySnapshot.docs[0];
      }
      return null;
    });
  }

  Future<QueryDocumentSnapshot<Object?>?> getServantFromGovId({
    required String govId,
    required String dob,
  }) async {
    return await tryOrCatch<QueryDocumentSnapshot<Object?>?>(() async {
      QuerySnapshot servantsQuerySnapshot = await servants
          .where('governmentId', isEqualTo: govId)
          .where('dob', isEqualTo: dob)
          .get();

      log(servantsQuerySnapshot.docs.toString());

      if (servantsQuerySnapshot.docs.isNotEmpty) {
        return servantsQuerySnapshot.docs[0];
      }
      return null;
    });
  }

  Future<QueryDocumentSnapshot<Object?>?> getCurrentUserDocument() async {
    return await tryOrCatch<QueryDocumentSnapshot<Object?>?>(() async {
      final String? phoneNumber =
          _authProvider.getCurrentFirebaseUser()?.phoneNumber;

      if (phoneNumber != null) {
        return await getUserFromContactNumber(phoneNumber: phoneNumber);
      }
      return null;
    });
  }

  Future<bool> signUpClerkOrOfficer({
    required String name,
    required String email,
    required String phoneNumber,
    required String governmentId,
    required String departmentId,
    required UserTypeEnum role,
  }) async {
    return await tryOrCatch<bool>(() async {
      if (await getUserFromContactNumber(phoneNumber: phoneNumber) != null) {
        throw AppException('User already exist !', 'user-exist');
      }

      await servants.add({
        'image': '',
        'filesRef': [],
        'deviceToken': '',
        'isDeleted': false,
        'isApproved': false,
        'name': name.trim(),
        'role': role.toMap(),
        'email': email.trim(),
        'governmentId': governmentId,
        'contactNumber': phoneNumber.trim(),
        'canCreateFile': role == UserTypeEnum.officer ? true : false,
        'departmentRef': departments.doc(departmentId),
        'createdAt': Timestamp.now(),
      });
      return true;
    });
  }

  Future<DocumentReference<Object?>> createOrUpdateCitizen({
    required String phoneNumber,
    String? name,
    String? email,
  }) async {
    return await tryOrCatch<DocumentReference<Object?>>(() async {
      final QueryDocumentSnapshot<Object?>? citizenDoc =
          await getUserFromContactNumber(phoneNumber: phoneNumber);

      return citizens.doc(citizenDoc?.id)
        ..set({
          'image': '',
          'deviceToken': '',
          'role': UserTypeEnum.citizen.toMap(),
          'contactNumber': phoneNumber.trim(),
          'name': name?.trim() ?? citizenDoc?['name'] ?? '',
          'email': email?.trim() ?? citizenDoc?['email'] ?? '',
          if (citizenDoc == null) 'createdAt': Timestamp.now(),
        });
    });
  }

  Future<DocumentReference<Object?>?> createFile({
    required String fileId,
    required String description,
    required String citizenId,
    required String fileTypeRefId,
    required List fileTracking,
  }) async {
    return await tryOrCatch<DocumentReference<Object?>?>(() async {
      if (await getFileFromId(fileId: fileId) != null) {
        throw AppException(
          'File number already used !',
          'file-exist',
        );
      }
      final QueryDocumentSnapshot<Object?>? currentUserDoc =
          await getCurrentUserDocument();

      if (currentUserDoc != null) {
        return await files.add({
          'fileId': fileId,
          // 'description': description,
          'citizenRef': citizens.doc(citizenId),
          'fixedRef': fixed.doc(fileTypeRefId),
          // 'fileCreatedByRef': servants.doc(currentUserDoc.id),
          'fileTracking': fileTracking,
          'fileClosed': false,
          'createdAt': Timestamp.now(),
        });
      }
      return null;
    });
  }

  Future<QueryDocumentSnapshot<Object?>?> getFileFromId({
    required String fileId,
  }) async {
    return await tryOrCatch<QueryDocumentSnapshot<Object?>?>(() async {
      QuerySnapshot filesSnapshot =
          await files.where('fileId', isEqualTo: fileId).get();

      if (filesSnapshot.docs.isNotEmpty) {
        return filesSnapshot.docs[0];
      }
      return null;
    });
  }

  Future<DocumentSnapshot<Object?>> getCitizenFromDocRef({
    required DocumentReference citizenRef,
  }) async {
    return await tryOrCatch<DocumentSnapshot<Object?>>(() async {
      return await citizenRef.get();
    });
  }

  Future<DocumentReference<Object?>?> requestDocument({
    required String message,
    required bool isUrgent,
    required DocumentReference citizenRef,
  }) async {
    return await tryOrCatch<DocumentReference<Object?>?>(() async {
      return await docRequests.add({
        'message': message,
        'urgent': isUrgent,
        'citizenRef': citizenRef,
        'createdAt': Timestamp.now(),
        'servantRef': servants.doc(GSServices.getCurrentUserData()?['id'])
      });
    });
  }
}
