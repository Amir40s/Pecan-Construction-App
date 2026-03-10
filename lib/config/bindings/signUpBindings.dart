import 'package:get/get.dart';
import 'package:pecan_construction/core/repo/employee_repository.dart';

import '../../screens/auth_screens/controllers/signup_controller.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<SignUpController>(SignUpController(),permanent: true);

  }

}