import 'package:fts_mobile/core/providers/auth_provider.dart';
import 'package:fts_mobile/core/providers/home_provider.dart';
import 'package:get/get.dart';

class CHomeController extends GetxController {
  final HomeProvider homeProvider = HomeProvider();
  final AuthProvider _authProvider = AuthProvider();

  Future<void> logOut() async {
    await _authProvider.signOut();
  }
}
