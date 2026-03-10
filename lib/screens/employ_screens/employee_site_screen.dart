import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:pecan_construction/config/routes/routes_name.dart';
import 'package:pecan_construction/core/constant/app_images.dart';
import 'package:sizer/sizer.dart';

import '../../core/models/site_model.dart';
import '../../core/widgets/app_text.dart';
import '../../core/widgets/appnetworkImage.dart';
import 'controllers/site_screen_controller.dart';

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
              child: Obx(() {
                final isSearching = controller.isSearching.value;
                return Row(
                  children: [
                    if (!isSearching)
                      AppText(
                        "construction_sites".tr,
                        color: textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      )
                    else
                      Expanded(
                        child: Container(
                          height: 42,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: border),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: controller.searchC,
                            autofocus: true,
                            style: TextStyle(
                              color: textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: InputDecoration(
                              hintText: "search_site_name".tr,
                              hintStyle: TextStyle(
                                color: textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ),
                    if (!isSearching) const Spacer(),
                    const Gap(10),
                    InkWell(
                      onTap: controller.onTapSearch,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: border),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isSearching ? Icons.close_rounded : Icons.search_rounded,
                          size: 20,
                          color: textPrimary,
                        ),
                      ),
                    ),
                  ],
                );
              }),
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
                      tab("all_sites".tr, 0),
                      tab("active".tr, 1),
                      tab("completed".tr, 2),
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
                    final status = site.siteStatus.trim().toLowerCase();

                    Color statusColor;

                    if (status == "completed") {
                      statusColor = const Color(0xFF10B981).withOpacity(0.35); // green
                    } else if (status == "paused") {
                      statusColor = Colors.grey.shade300; // grey
                    } else if (status == "active") {
                      statusColor = const Color(0xFFC22522).withOpacity(0.74); // red
                    } else {
                      statusColor = const Color(0xFFF59E0B).withOpacity(0.43); // fallback
                    }
                    return InkWell(
                      onTap: (){
                        Get.toNamed(RoutesName.EmployeeSiteDetailsScreen, arguments: site.siteId);
                      },
                      child: Container(
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
                                          color: statusColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const Gap(6),
                                      AppText(
                                        site.siteStatus.capitalizeFirst ?? site.siteStatus,
                                        color: textSecondary,
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ],
                                  ),
                                  const Gap(6),

                                  AppText(
                                    site.siteName,
                                    color: textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  const Gap(4),
                                  AppText(
                                    maxLines: 1,
                                    site.siteDescription.toString() ?? "",
                                    color: textSecondary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),

                                  const Gap(10),

                                  Row(
                                    children: [
                                      // main action button
                                      InkWell(
                                        onTap: () {
                                          Get.toNamed(RoutesName.EmployeeSiteDetailsScreen, arguments: site.siteId);
                                        },
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: statusColor,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: AppText(
                                            "view_site".tr,
                                            color: Colors.black54,
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w800,
                                          )
                                        ),
                                      ),
                                      const Gap(10),
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
                                path: site.sitePhoto.toString(),
                                isNetwork: true,
                              ),
                            ),
                          ],
                        ),
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
      child: AppNetworkImage(
        url: path,
        isCircle: false,
        width: 20.w,
        height: 20.w,
        placeholderAsset: AppImages.profileImage,
        borderWidth: 3,
        borderColor: Colors.white,
      )
    );
  }
}
