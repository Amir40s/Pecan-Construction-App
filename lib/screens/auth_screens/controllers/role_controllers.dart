import 'package:get/get.dart';
import 'package:pecan_construction/config/routes/routes_name.dart';

enum AppRoleType { admin, employee }

class RoleSelectionController extends GetxController {
  final Rx<AppRoleType?> selectedRole = Rx<AppRoleType?>(null);

  void selectRole(AppRoleType role) {
    selectedRole.value = role;
  }

  void continueNext() async {
    final role = selectedRole.value;

    if (role == null) {
      Get.snackbar("Select Role", "Please select a role to continue");
      return;
    }

    await Future.delayed(const Duration(milliseconds: 100));

    if (role == AppRoleType.admin) {
      Get.offAllNamed(RoutesName.adminLoginScreen);
    } else {
      Get.offAllNamed(RoutesName.login);
    }
  }
}
