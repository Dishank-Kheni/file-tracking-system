import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

part 'api_exceptions.dart';

mixin BaseService {
  Future<T> tryOrCatch<T>(Future<T> Function() methodToRun) async {
    try {
      return await methodToRun();
    } on AppException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw AppException(e.message, e.code);
    } catch (e, trace) {
      debugPrint("$e\n$trace");
      throw AppException(
        'Internal Error occured, please try again later ! 😭',
        "App Exception: ",
      );
    }
  }
}
