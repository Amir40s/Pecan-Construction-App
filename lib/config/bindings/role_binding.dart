import 'package:get/get.dart';
import 'package:pecan_construction/screens/auth_screens/controllers/role_controllers.dart';

class RoleSelectionBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<RoleSelectionController>(RoleSelectionController(), permanent: true);
  }


}