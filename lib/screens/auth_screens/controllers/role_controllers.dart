import 'package:get/get.dart';
import 'package:pecan_construction/config/routes/routes_name.dart';

enum AppRoleType { admin, employee }

class RoleSelectionController extends GetxController {
  final Rx<AppRoleType?> selectedRole = Rx<AppRoleType?>(null);

  void selectRole(AppRoleType role) {
    selectedRole.value = role;
  }

  void continueNext() {
    final role = selectedRole.value;
    if (role == null) {
      Get.snackbar("Select Role", "Please select a role to continue");
      return;
    }

    if (role == AppRoleType.admin) {
      Get.offAllNamed(RoutesName.login); // change to your route
    } else {
      Get.offAllNamed(""); //  change to your route
    }
  }
}
