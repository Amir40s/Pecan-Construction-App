import 'package:get/get.dart';
import '../../screens/employ_screens/controllers/employee_notification_controller.dart';

class EmployeeNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmployeeNotificationController>(
          () => EmployeeNotificationController(),
    );
  }
}
