import 'package:get/get.dart';

import '../../screens/auth_screens/controllers/signIn_controller.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=> signInController());
  }

}