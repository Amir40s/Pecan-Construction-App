import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationSettingController extends GetxController {

  final box = GetStorage();

  RxBool isNotificationEnabled = true.obs;

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
}