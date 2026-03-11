import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pecan_construction/core/services/string_translation_extension.dart';
import '../../../config/routes/routes_name.dart';
import '../../../core/models/notification_model.dart';

enum NotificationTab { all, reminders, updates }

class EmployeeNotificationController extends GetxController {

  final Rx<NotificationTab> selectedTab = NotificationTab.all.obs;

  final RxList<EmployeeNotificationItem> allItems =
      <EmployeeNotificationItem>[].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void setTab(NotificationTab tab) => selectedTab.value = tab;

  List<EmployeeNotificationItem> get filteredItems {

    final tab = selectedTab.value;

    if (tab == NotificationTab.all) return allItems;

    if (tab == NotificationTab.reminders) {
      return allItems
          .where((e) => e.type == NotificationType.reminder)
          .toList();
    }

    return allItems
        .where((e) => e.type == NotificationType.update)
        .toList();
  }

  /// 🔴 REALTIME NOTIFICATIONS
  void listenNotifications() {

    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    _firestore
        .collection("notifications")
        .where("userId", isEqualTo: uid)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .listen((snapshot) {

      final items = snapshot.docs.map((doc) {

        final data = doc.data();

        final type = data['type'] == 'reminder'
            ? NotificationType.reminder
            : NotificationType.update;

        final timestamp = data['createdAt'] as Timestamp?;

        return EmployeeNotificationItem(
          id: doc.id,
          title: data['title'] ?? '',
          subtitle: data['body'] ?? '',
          timeLabel: _timeAgo(timestamp),
          siteId: data["siteId"] ?? "",
          type: type,
          isUnread: !(data['isRead'] ?? false),
          isHighPriority: data['priority'] == 'high',
        );

      }).toList();

      allItems.assignAll(items);

    });
  }

  void openNotification(EmployeeNotificationItem item) {

    markAsRead(item.id);

    /// 🔴 Reminder → show dialog
    if (item.type == NotificationType.reminder) {
      showReminderDialog(item);
      return;
    }

    /// 🔵 Site notification → open site
    if (item.siteId != null && item.siteId!.isNotEmpty) {

      Get.toNamed(
        RoutesName.EmployeeSiteDetailsScreen,
        arguments: {"siteId": item.siteId},
      );

    }
  }

  void showReminderDialog(EmployeeNotificationItem item) {

    Get.dialog(

      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// icon
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE5E5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.notifications_active_outlined,
                  color: Color(0xFFC22522),
                  size: 26,
                ),
              ),

              const SizedBox(height: 16),

              /// title
              Text(
                item.title.trn,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 10),

              /// body
              Text(
                item.subtitle.trn,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 16),

              /// time
              Text(
                item.timeLabel,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),

              const SizedBox(height: 20),

              /// button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC22522),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child:  Text(
                    "close".tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),

      barrierDismissible: true,

    );
  }


  /// MARK AS READ
  Future<void> markAsRead(String id) async {

    final idx = allItems.indexWhere((e) => e.id == id);
    if (idx == -1) return;

    allItems[idx] = allItems[idx].copyWith(isUnread: false);

    await _firestore
        .collection("notifications")
        .doc(id)
        .update({"isRead": true});
  }

  /// TIME FORMAT
  String _timeAgo(Timestamp? timestamp) {

    if (timestamp == null) return "";

    final now = DateTime.now();
    final date = timestamp.toDate();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return "Now";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m";
    if (diff.inHours < 24) return "${diff.inHours}h";

    return "${diff.inDays}d";
  }

  @override
  void onInit() {
    super.onInit();
    listenNotifications();
  }
}