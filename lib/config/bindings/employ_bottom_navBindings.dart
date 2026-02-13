import 'package:get/get.dart';
import 'package:pecan_construction/screens/employ_screens/controllers/bottom_nav_bar_controller.dart';

import '../../screens/employ_screens/controllers/employee_home_controller.dart';
import '../../screens/employ_screens/controllers/employee_notification_controller.dart';
import '../../screens/employ_screens/controllers/site_screen_controller.dart';

class EmployeeBottomBinding  extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<EmployeeBottomNavController>(EmployeeBottomNavController());
    Get.put<EmployeeSitesController>(EmployeeSitesController());
    Get.lazyPut<EmployeeHomeController>(() => EmployeeHomeController(),);
    Get.lazyPut<EmployeeNotificationController>(() => EmployeeNotificationController(),);

  }

}