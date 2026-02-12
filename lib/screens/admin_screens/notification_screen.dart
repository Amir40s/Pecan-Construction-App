import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:pecan_construction/screens/admin_screens/admin_controller/notification_controller.dart';

import '../../core/widgets/app_text.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final bg = const Color(0xFFF6F7FB);
    final textPrimary = const Color(0xFF111827);
    final textSecondary = const Color(0xFF6B7280);
    final border = const Color(0xFFE5E7EB);
    final red = const Color(0xFFDC2626);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(22),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppText(
                "Notification",
                color: textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),

            const Gap(8),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TabBar(
                controller: controller.tabController,
                isScrollable: false,
                labelPadding: EdgeInsets.zero,
                indicatorColor: red,
                indicatorWeight: 3,
                dividerColor: border,
                labelColor: textPrimary,
                unselectedLabelColor: textSecondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                tabs: const [
                  Tab(text: "All"),
                  Tab(text: "Reminders"),
                  Tab(text: "Updates"),
                ],
              ),
            ),

            const Gap(8),

            // List
            Expanded(
              child: Obx(() {
                final items = controller.filtered;

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Gap(10),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _NotificationTile(
                      item: item,
                      border: border,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      red: red,
                      onTap: () => controller.markAsRead(item.id),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotificationItem item;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color red;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.item,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.red,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconBg = item.isActive ? const Color(0xFFFFE7E7) : const Color(0xFFE5E7EB);
    final bellColor = item.isActive ? red : const Color(0xFF9CA3AF);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // left icon
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(Icons.notifications_rounded, color: bellColor, size: 20),
              ),
            ),

            const Gap(12),

            // middle text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    item.title,
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                  const Gap(4),
                  AppText(
                    item.subtitle,
                    color: Colors.grey,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),

            const Gap(10),

            // right time + unread dot
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText(
                  item.timeAgo,
                  color: textSecondary,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                ),
                const Gap(6),
                if (item.isUnread)
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: red,
                      shape: BoxShape.circle,
                    ),
                  )
                else
                  const SizedBox(height: 7, width: 7),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
