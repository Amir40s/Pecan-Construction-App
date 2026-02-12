import 'package:get/get.dart';
import 'package:pecan_construction/screens/admin_screens/admin_controller/add_attaichment_controller.dart';

class AddAttachmentbinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<AddAttachmentController>(AddAttachmentController(), permanent: true);
  }

}