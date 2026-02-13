import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

import '../../core/models/site_model.dart';
import '../../core/widgets/app_text.dart';
import 'controllers/site_screen_controller.dart' hide SiteStatus;

class EmployeeSitesScreen extends GetView<EmployeeSitesController> {
  const EmployeeSitesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF6F7FB);
    final card = Colors.white;
    final textPrimary = const Color(0xFF111827);
    final textSecondary = const Color(0xFF6B7280);
    final border = const Color(0xFFE5E7EB);
    const red = Color(0xFFC22522);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                children: [
                  AppText(
                    "Construction Sites",
                    color: textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: controller.onTapSearch,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: border),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.search_rounded,
                        size: 20,
                        color: textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tabs (All / Active / Completed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: border),
                ),
                child: Obx(() {
                  final idx = controller.tabIndex.value;

                  Widget tab(String label, int i) {
                    final selected = idx == i;
                    return Expanded(
                      child: InkWell(
                        onTap: () => controller.changeTab(i),
                        child: Column(
                          children: [
                            const Gap(10),
                            AppText(
                              label,
                              color: selected ? textPrimary : textSecondary,
                              fontSize: 12.5,
                              fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
                            ),
                            const Gap(8),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              height: 3,
                              width: 38,
                              decoration: BoxDecoration(
                                color: selected ? red : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Row(
                    children: [
                      tab("All Sites", 0),
                      tab("Active", 1),
                      tab("Completed", 2),
                    ],
                  );
                }),
              ),
            ),

            const Gap(12),

            // List
            Expanded(
              child: Obx(() {
                final list = controller.filtered;

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final site = list[index];
                    final isCompleted = site.status == SiteStatus.completed;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 14,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // left content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // progress badge row
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: isCompleted ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const Gap(6),
                                    AppText(
                                      site.progressLabel,
                                      color: textSecondary,
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ],
                                ),
                                const Gap(6),

                                AppText(
                                  site.title,
                                  color: textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                                const Gap(4),
                                AppText(
                                  site.subtitle,
                                  color: textSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),

                                const Gap(10),

                                Row(
                                  children: [
                                    // main action button
                                    InkWell(
                                      onTap: () => controller.onTapAction(site),
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: isCompleted ? const Color(0xFFF3F4F6) : red,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: AppText(
                                          site.actionText,
                                          color: isCompleted ? textPrimary : Colors.white,
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    const Gap(10),
                                    // info icon
                                    InkWell(
                                      onTap: () => controller.openSite(site),
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        width: 34,
                                        height: 34,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF3F4F6),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.info_outline_rounded,
                                          size: 18,
                                          color: textSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const Gap(10),

                          // thumbnail on right
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _Thumb(
                              path: site.imageAssetOrUrl,
                              isNetwork: site.isNetworkImage,
                            ),
                          ),
                        ],
                      ),
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

class _Thumb extends StatelessWidget {
  final String path;
  final bool isNetwork;

  const _Thumb({required this.path, required this.isNetwork});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      height: 92,
      child: isNetwork
          ? Image.network(path, fit: BoxFit.cover)
          : Image.asset(path, fit: BoxFit.cover),
    );
  }
}
