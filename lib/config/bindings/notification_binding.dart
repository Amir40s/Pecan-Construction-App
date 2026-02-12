import 'package:get/get.dart';
import 'package:pecan_construction/screens/admin_screens/admin_controller/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<NotificationController>(NotificationController(),permanent: true);
  }

}