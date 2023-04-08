import 'package:fts_mobile/utils/enums.dart';
import 'package:get/get.dart';

class IApproveOfficersController extends GetxController {
  Rx<OfficerStatus> officerStatus = OfficerStatus.approve.obs;
}
