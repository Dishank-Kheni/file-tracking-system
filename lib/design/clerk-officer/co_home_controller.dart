import 'package:fts_mobile/core/providers/auth_provider.dart';
import 'package:get/get.dart';

class COHomeController extends GetxController {
  final AuthProvider _authProvider = AuthProvider();
  RxString selectedTab = 'ongoing'.obs;

  Future<void> logOut() async {
    await _authProvider.signOut();
  }
}
