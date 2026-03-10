import 'package:get/get.dart';
import 'package:pecan_construction/screens/employ_screens/controllers/adminLogincontroller.dart';

class AdminLoginBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<AdminLoginController>(()=> AdminLoginController());
  }

}