import 'package:get/get.dart';

import '../../screens/employ_screens/controllers/employee_home_controller.dart';

class EmployeeHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmployeeHomeController>(() => EmployeeHomeController(), fenix: true);
  }
}
