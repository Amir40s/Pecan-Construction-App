enum NotificationType { reminder, update }

class EmployeeNotificationItem {
  final String id;
  final String title;
  final String subtitle;
  final String timeLabel; // e.g "Now", "15m", "2h"
  final NotificationType type;
  final bool isUnread; // red dot
  final bool isHighPriority; // "High Priority" tag in subtitle (optional)
  final String? siteId;
  const EmployeeNotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timeLabel,
    required this.type,
    this.isUnread = false,
    this.isHighPriority = false,
    this.siteId,
  });

  EmployeeNotificationItem copyWith({
    bool? isUnread,
    String? siteId,
  }) {
    return EmployeeNotificationItem(
      id: id,
      title: title,
      subtitle: subtitle,
      timeLabel: timeLabel,
      type: type,
      isUnread: isUnread ?? this.isUnread,
      isHighPriority: isHighPriority,
      siteId: siteId ?? this.siteId,
    );
  }
}