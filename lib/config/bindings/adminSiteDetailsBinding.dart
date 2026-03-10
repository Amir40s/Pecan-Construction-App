import 'package:get/get.dart';

import '../../screens/admin_screens/admin_controller/admin_site_detailsController.dart';

class AdminSiteDetailsBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<AdminSiteDetailsController>(() => AdminSiteDetailsController());
  }

}