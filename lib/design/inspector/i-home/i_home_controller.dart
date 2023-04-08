import 'package:fts_mobile/utils/enums.dart';
import 'package:get/get.dart';

class IHomeController extends GetxController {
  Rx<InspectorHomeMenu> selectedMenu = InspectorHomeMenu.files.obs;
}
