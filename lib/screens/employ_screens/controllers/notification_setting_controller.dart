import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../config/routes/routes_name.dart';

class NotificationSettingController extends GetxController {

  final box = GetStorage();

  RxBool isNotificationEnabled = true.obs;
  RxBool isLogging = false.obs;


  @override
  void onInit() {
    super.onInit();

    bool saved = box.read("notifications") ?? true;
    isNotificationEnabled.value = saved;

    if (saved) {
      FirebaseMessaging.instance.subscribeToTopic("all_users");
    }
  }

  void toggleNotification(bool value) async {

    isNotificationEnabled.value = value;

    box.write("notifications", value);

    if (value) {
      await FirebaseMessaging.instance.subscribeToTopic("all_users");
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic("all_users");
    }
  }
  Future<void> deleteAccount() async {
    log("deleting account");
    isLogging.value = true;

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      String uid = user.uid;

      // Delete user data from Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .delete();

      // Delete auth user
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
}