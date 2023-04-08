import 'package:fts_mobile/utils/enums.dart';
import 'package:get/get.dart';

class IFileListController extends GetxController {
  Rx<FileTypes> fileType = FileTypes.ongoings.obs;
}
