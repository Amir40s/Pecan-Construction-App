import 'package:get/get.dart';

import '../../screens/auth_screens/controllers/signup_controller.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<SignUpController>(SignUpController(),permanent: true);

  }

}