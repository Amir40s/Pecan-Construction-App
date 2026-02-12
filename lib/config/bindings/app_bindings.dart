import 'package:get/get.dart';
import 'package:pecan_construction/screens/admin_screens/admin_controller/create_site_controller.dart';

class createSiteControllerBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<CreateSiteController>(CreateSiteController(),permanent: true);
  }
}