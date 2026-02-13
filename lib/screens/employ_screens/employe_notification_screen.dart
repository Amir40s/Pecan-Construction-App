import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

import '../../core/models/notification_model.dart';
import '../../core/widgets/app_text.dart';
import 'controllers/employee_notification_controller.dart';

class EmployeNotificationScreen extends GetView<EmployeeNotificationController> {
  const EmployeNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Gap(10),

              /// Top Tabs (All | Reminders | Updates)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: _TopTabs(c: c),
              ),

              const Gap(8),

              /// List
              Expanded(
                child: Obx(() {
                  final items = c.filteredItems;

                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 6),
                    itemCount: items.length,

                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _NotificationTile(
                        item: item,
                        onTap: () => c.markAsRead(item.id),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// -------------------- Tabs Widget --------------------
class _TopTabs extends StatelessWidget {
  final EmployeeNotificationController c;
  const _TopTabs({required this.c});

  @override
  Widget build(BuildContext context) {
    Widget tab(String title, NotificationTab tab) {
      return Obx(() {
        final selected = c.selectedTab.value == tab;
        return InkWell(
          onTap: () => c.setTab(tab),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 2.2,
                  color: selected ? Colors.red : Colors.transparent,
                ),
              ),
            ),
            child: AppText(
              title,
              fontSize: 16,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              color: selected ? Colors.black : Colors.grey.shade600,
            ),
          ),
        );
      });
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        tab("All", NotificationTab.all),
        const Gap(18),
        tab("Reminders", NotificationTab.reminders),
        const Gap(18),
        tab("Updates", NotificationTab.updates),
      ],
    );
  }
}

/// -------------------- Tile Widget --------------------
class _NotificationTile extends StatelessWidget {
  final EmployeeNotificationItem item;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAlert = item.type == NotificationType.reminder;

    final iconBg = isAlert ? const Color(0xFFFFE1E1) : const Color(0xFFEAEAEA);
    final iconColor = isAlert ? const Color(0xFFC22522) : Colors.grey.shade700;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: BoxBorder.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 2
            )
          ]
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Left Icon Box
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                color: iconColor,
                size: 22,
              ),
            ),

            const Gap(12),

            /// Middle Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          item.title,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                      if (item.isUnread) ...[
                        const Gap(8),
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFFC22522),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const Gap(4),
                  AppText(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    item.subtitle,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),

            const Gap(10),

            /// Right Time
            AppText(
              item.timeLabel,
              fontSize: 10.8,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ],
        ),
      ),
    );
  }
}
