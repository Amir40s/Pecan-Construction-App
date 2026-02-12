import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/config/routes/routes_name.dart';

class AssignEmployeeController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameC = TextEditingController();
  final emailC = TextEditingController();

  final jobRoles = <String>[
    "Architecture",
    "Engineer",
    "Supervisor",
    "Project Manager",
    "Electrician",
    "Plumber",
  ];

  final selectedJobRole = "Architecture".obs;

  void changeRole(String? role) {
    if (role == null) return;
    selectedJobRole.value = role;
  }

  String? nameValidator(String? v) {
    final value = (v ?? "").trim();
    if (value.isEmpty) return "Please enter employee name";
    if (value.length < 3) return "Name too short";
    return null;
  }

  String? emailValidator(String? v) {
    final value = (v ?? "").trim();
    if (value.isEmpty) return "Please enter email";
    final ok = RegExp(r"^[\w\.\-]+@([\w\-]+\.)+[\w]{2,}$").hasMatch(value);
    if (!ok) return "Enter valid email";
    return null;
  }

  void onNext() {
    // final isValid = formKey.currentState?.validate() ?? false;
    // if (!isValid) return;
    //
    // // TODO: API call / Firestore save etc
    // // Example:
    // // Get.toNamed(AppRoutes.nextScreen);
    //
    // Get.snackbar("Success", "Employee assigned (demo)");
    Get.toNamed(RoutesName.AddAttachmentScreen);
  }

  @override
  void onClose() {
    nameC.dispose();
    emailC.dispose();
    super.onClose();
  }
}
