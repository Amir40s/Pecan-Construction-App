import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum NotificationType { all, reminders, updates }

class AppNotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String subtitle;
  final String timeAgo; // e.g. "Now", "15m", "2h", "1d"
  final bool isUnread;
  final bool isActive; // red bell vs grey bell (screenshot style)

  const AppNotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    this.isUnread = false,
    this.isActive = false,
  });
}

class NotificationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final TabController tabController;

  // 0=All, 1=Reminders, 2=Updates
  final RxInt tabIndex = 0.obs;

  final RxList<AppNotificationItem> _all = <AppNotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        tabIndex.value = tabController.index;
      }
    });

    // dummy data (same as screenshot vibe)
    _all.assignAll([
      const AppNotificationItem(
        id: "1",
        type: NotificationType.reminders,
        title: "Safety Inspection due in 2 hours",
        subtitle: "Site: North Wing Expansion . High Priority",
        timeAgo: "Now",
        isUnread: true,
        isActive: true,
      ),
      const AppNotificationItem(
        id: "2",
        type: NotificationType.updates,
        title: "RFI # 402 has been approved",
        subtitle: "Project: Downtown Metro Mall . Structured Team",
        timeAgo: "15m",
        isUnread: false,
        isActive: false,
      ),
      const AppNotificationItem(
        id: "3",
        type: NotificationType.updates,
        title: "New Blueprint",
        subtitle: "By Architectures . Replaces version 2.4",
        timeAgo: "2h",
        isUnread: true,
        isActive: true,
      ),
      const AppNotificationItem(
        id: "4",
        type: NotificationType.reminders,
        title: "Safety Inspection due in 2 hours",
        subtitle: "Site: North Wing Expansion . High Priority",
        timeAgo: "1d",
        isUnread: false,
        isActive: true,
      ),
      const AppNotificationItem(
        id: "5",
        type: NotificationType.updates,
        title: "RFI # 402 has been approved",
        subtitle: "Project: Downtown Metro Mall . Structured Team",
        timeAgo: "15m",
        isUnread: false,
        isActive: false,
      ),
      const AppNotificationItem(
        id: "6",
        type: NotificationType.updates,
        title: "RFI # 402 has been approved",
        subtitle: "Project: Downtown Metro Mall . Structured Team",
        timeAgo: "15m",
        isUnread: false,
        isActive: false,
      ),
    ]);
  }

  List<AppNotificationItem> get filtered {
    final i = tabIndex.value;
    if (i == 0) return _all;
    if (i == 1) return _all.where((e) => e.type == NotificationType.reminders).toList();
    return _all.where((e) => e.type == NotificationType.updates).toList();
  }

  void markAsRead(String id) {
    final idx = _all.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    final item = _all[idx];
    _all[idx] = AppNotificationItem(
      id: item.id,
      type: item.type,
      title: item.title,
      subtitle: item.subtitle,
      timeAgo: item.timeAgo,
      isUnread: false,
      isActive: item.isActive,
    );
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
