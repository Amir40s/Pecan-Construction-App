import 'package:get/get.dart';
import '../../../core/models/notification_model.dart';

enum NotificationTab { all, reminders, updates }


class EmployeeNotificationController extends GetxController {
  final Rx<NotificationTab> selectedTab = NotificationTab.all.obs;

  final RxList<EmployeeNotificationItem> allItems =
      <EmployeeNotificationItem>[].obs;

  void setTab(NotificationTab tab) => selectedTab.value = tab;

  List<EmployeeNotificationItem> get filteredItems {
    final tab = selectedTab.value;

    if (tab == NotificationTab.all) return allItems;

    if (tab == NotificationTab.reminders) {
      return allItems.where((e) => e.type == NotificationType.reminder).toList();
    }

    // updates
    return allItems.where((e) => e.type == NotificationType.update).toList();
  }

  void markAsRead(String id) {
    final idx = allItems.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    allItems[idx] = allItems[idx].copyWith(isUnread: false);
  }

  @override
  void onInit() {
    super.onInit();

    // Dummy data
    allItems.assignAll([
      const EmployeeNotificationItem(
        id: "1",
        title: "Safety Inspection due in 2 hours",
        subtitle: "Site: North Wing Expansion . High Priority",
        timeLabel: "Now",
        type: NotificationType.reminder,
        isUnread: true,
        isHighPriority: true,
      ),
      const EmployeeNotificationItem(
        id: "2",
        title: "RFI # 402 has been approved",
        subtitle: "Project: Downtown Metro Mall . Structured Team",
        timeLabel: "15m",
        type: NotificationType.update,
        isUnread: false,
      ),
      const EmployeeNotificationItem(
        id: "3",
        title: "New Blueprint",
        subtitle: "By Architectures . Replaces version 2.4",
        timeLabel: "2h",
        type: NotificationType.update,
        isUnread: true,
      ),
      const EmployeeNotificationItem(
        id: "4",
        title: "Safety Inspection due in 2 hours",
        subtitle: "Site: North Wing Expansion . High Priority",
        timeLabel: "1d",
        type: NotificationType.reminder,
        isUnread: false,
        isHighPriority: true,
      ),
      const EmployeeNotificationItem(
        id: "5",
        title: "RFI # 402 has been approved",
        subtitle: "Project: Downtown Metro Mall . Structured Team",
        timeLabel: "15m",
        type: NotificationType.update,
        isUnread: false,
      ),
      const EmployeeNotificationItem(
        id: "6",
        title: "RFI # 402 has been approved",
        subtitle: "Project: Downtown Metro Mall . Structured Team",
        timeLabel: "15m",
        type: NotificationType.update,
        isUnread: false,
      ),
      const EmployeeNotificationItem(
        id: "7",
        title: "RFI # 402 has been approved",
        subtitle: "Project: Downtown Metro Mall . Structured Team",
        timeLabel: "15m",
        type: NotificationType.update,
        isUnread: false,
      ),
      const EmployeeNotificationItem(
        id: "8",
        title: "RFI # 402 has been approved",
        subtitle: "Project: Downtown Metro Mall . Structured Team",
        timeLabel: "15m",
        type: NotificationType.update,
        isUnread: false,
      ),
    ]);
  }
}
