import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/config/routes/routes_name.dart';
import '../../../core/repo/employee_repository.dart';
import '../../../core/services/notification_services.dart';

class signInController extends GetxController {
  final EmployeeRepository repository = EmployeeRepository();
  final _auth =  FirebaseAuth.instance;
  // Form (optional, agar aap future me Form widget use karna chaho)
  final formKey = GlobalKey<FormState>();

  // Text Controllers
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final resetPasswordC = TextEditingController();
  RxBool isresetPasswordLoading = false.obs;

  RxBool isLogging = false.obs;

  // UI State
  final RxBool obscurePassword = true.obs;

  // Language
  final RxString selectedLang = "English".obs;

  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  void onLanguageChanged(String value) {
    selectedLang.value = value;
  }


  //////login controller
  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLogging.value = true;
      final auth = FirebaseAuth.instance;
      final res = await auth.signInWithEmailAndPassword(
        email: emailC.text.trim(),
        password: passwordC.text.trim(),
      );
      print("LOGIN OK uid=${res.user?.uid}");
      await NotificationService().setup();
      isLogging.value = false;
      Get.offAllNamed(RoutesName.EmployeeBottomNavScreen);
    } on FirebaseAuthException catch (e) {
      print("FIREBASE LOGIN ERROR: ${e.code} - ${e.message}");
      Get.snackbar(
        "Login Error",
        e.message ?? "An error occurred during sign in.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } catch (e, st) {
      print("LOGIN ERROR: $e");
      print("STACK: $st");
      Get.snackbar(
        "Error",
        "An unexpected error occurred: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLogging.value = false;
    }
  }


  Future<void> sendResetPasswordLink(String email) async {
    try {

      if(email.isEmpty){
        Get.snackbar("Error", "Please enter your email");
        return;
      }
      isresetPasswordLoading.value = true;
      await _auth.sendPasswordResetEmail(email: email);

      Get.snackbar(
        "Success",
        "Password reset link has been sent to your email",
        snackPosition: SnackPosition.BOTTOM,
      );

    } catch (e) {
      isresetPasswordLoading.value = false;
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    finally {
      isresetPasswordLoading.value = false;
    }
  }

  void goSignup() {
    Get.toNamed(RoutesName.signup);
  }
}