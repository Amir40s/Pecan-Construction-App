import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart'; // <-- Make sure to add this in pubspec.yaml

import '../../../config/routes/routes_name.dart';
import 'adminLogincontroller.dart';

class NotificationSettingController extends GetxController {
  final box = GetStorage();

  RxBool isNotificationEnabled = true.obs;
  RxBool isLogging = false.obs;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final  adminC = Get.put(AdminLoginController());

  @override
  void onInit() {
    super.onInit();

    bool saved = box.read("notifications") ?? true;
    isNotificationEnabled.value = saved;
  }

  Future<void> toggleNotification(bool value) async {
    isNotificationEnabled.value = value;
    box.write("notifications", value);

    try {
      final user = auth.currentUser;
      if (user == null) return;

      await firestore.collection("users").doc(user.uid).update({
        "isNotificationEnabled": value,
      });
    } catch (e) {
      log("Notification toggle error: $e");

      Get.snackbar(
        "Error",
        "Failed to update notification settings",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }


  Future<void> deleteAdminAccount() async {
    log("deleting admin account");
    isLogging.value = true;

    try {
      final query = await firestore
          .collection("admin")
          .where("email", isEqualTo: adminC.adminEmail.toString())
          .get();

      for (var doc in query.docs) {
        await firestore.collection("admin").doc(doc.id).delete();
      }
      final box = GetStorage();
      box.remove('logged_in_admin_email');
      Get.offAllNamed(RoutesName.RoleSelectionScreen);

    } catch (e) {
      log("Delete admin error: $e");

      Get.snackbar(
        "Error",
        "Failed to delete admin account",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLogging.value = false;
    }
  }
  /// -------------------------
  /// New methods for URLs
  /// -------------------------

  Future<void> openPrivacyPolicy() async {
    const urlString = "https://zeeshankhan2026.github.io/pecan-privacy-policy/"; // Replace with actual URL
    await _launchUrl(urlString);
  }

  Future<void> openTermsAndConditions() async {
    const urlString = "https://zeeshankhan2026.github.io/terms-policy/"; // Replace with actual URL
    await _launchUrl(urlString);
  }
  Future<void> openeula() async {
    const urlString = "https://pecan-construction.netlify.app/user-agreement"; // Replace with actual URL
    await _launchUrl(urlString);
  }
  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
        Get.snackbar('Error', 'Could not launch $urlString');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }
}