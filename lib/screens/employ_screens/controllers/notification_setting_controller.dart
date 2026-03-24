import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart'; // <-- Make sure to add this in pubspec.yaml

import '../../../config/routes/routes_name.dart';

class NotificationSettingController extends GetxController {
  final box = GetStorage();

  RxBool isNotificationEnabled = true.obs;
  RxBool isLogging = false.obs;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

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

  Future<void> deleteAccount() async {
    log("deleting account");
    isLogging.value = true;

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      String uid = user.uid;

      await firestore.collection("users").doc(uid).delete();
      await user.delete();

      Get.offAllNamed(RoutesName.splash);
    } catch (e) {
      log("Delete account error: $e");

      Get.snackbar(
        "Error",
        "Failed to delete account",
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
    const urlString = "https://zeeshankhan2026.github.io/pecan-user-agreement/"; // Replace with actual URL
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