import 'package:get/get.dart';

import '../../screens/employ_screens/controllers/attaichment_controller.dart';

class AttachmentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AttachmentsController>(AttachmentsController());
  }
}
