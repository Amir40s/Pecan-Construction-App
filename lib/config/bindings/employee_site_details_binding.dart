import 'package:get/get.dart';

import '../../screens/employ_screens/controllers/employee_site_details_controller.dart';

class EmployeeSiteDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<EmployeeSiteDetailsController>(EmployeeSiteDetailsController());
  }
}
