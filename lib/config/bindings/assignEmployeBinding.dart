import 'package:get/get.dart';
import 'package:pecan_construction/screens/admin_screens/admin_controller/assign_employee_controller.dart';

class AssignEmployeeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AssignEmployeeController>(AssignEmployeeController(), permanent: true);
  }

}