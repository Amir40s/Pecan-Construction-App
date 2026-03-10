import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/config/routes/routes_name.dart';
import 'package:sizer/sizer.dart';
import 'package:pecan_construction/core/widgets/app_text.dart';
import '../../core/constant/app_images.dart';
import '../../core/widgets/appnetworkImage.dart';
import '../employ_screens/controllers/adminLogincontroller.dart';
import 'admin_controller/admin_home_controller.dart';
import 'components/admin_home_widgets.dart';

class AdminHomeScreen extends StatelessWidget {
  AdminHomeScreen({super.key});

  final c = Get.put(AdminHomeController());
  final adminC = Get.put(AdminLoginController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                /// Top Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Obx(() {
                        if (adminC.selectedProfileImage.value != null) {
                          return Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xffDC9291), width: 2),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.file(
                              adminC.selectedProfileImage.value!,
                              fit: BoxFit.cover,
                            ),
                          );
                        }

                        return AppNetworkImage(
                          url: adminC.adminProfileImage.value,
                          width: 20.w,
                          height: 20.w,
                          isCircle: true,
                          fit: BoxFit.cover,
                          placeholderAsset: AppImages.profileImage,
                          borderWidth: 2,
                          borderColor: const Color(0xffDC9291),
                        );
                      }),
                      SizedBox(width: 3.w),
                      Obx(() {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              "welcome".tr,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff979796),
                            ),
                            AppText(
                              adminC.adminName.value.isEmpty
                                  ? "admin".tr
                                  : adminC.adminName.value,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ],
                        );
                      })
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                const Divider(height: 1),

                /// Summary Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  child: Obx(() {
                    final totalSites = c.sites.length;
                    final activeSites = c.sites
                        .where((e) => e.siteStatus.toLowerCase() == "active")
                        .length;
                    final completedSites = c.sites
                        .where((e) => e.siteStatus.toLowerCase() == "completed")
                        .length;

                    return Row(
                      children: [
                        Expanded(
                          child: _summaryCard(
                            title: "total_sites".tr,
                            value: totalSites.toString(),
                            icon: CupertinoIcons.building_2_fill,
                            iconColor: Colors.blue,
                            iconBgColor: Colors.blue.withOpacity(0.12),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _summaryCard(
                            title: "active_sites".tr,
                            value: activeSites.toString(),
                            icon: CupertinoIcons.time_solid,
                            iconColor: Colors.redAccent,
                            iconBgColor: Colors.redAccent.withOpacity(0.12),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _summaryCard(
                            title: "completed_sites".tr,
                            value: completedSites.toString(),
                            icon: CupertinoIcons.check_mark_circled_solid,
                            iconColor: Colors.green,
                            iconBgColor: Colors.green.withOpacity(0.12),
                          ),
                        ),
                      ],
                    );
                  }),
                ),

                /// Active Sites
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Obx(
                        () => ActiveSitesHeader(
                      count: c.sites.length,

                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Obx(
                        () => Column(
                      children: c.sites
                          .map((s) => SiteCard(
                          site: s,
                          onView: () {
                            Get.toNamed(RoutesName.SiteDetailsScreen, arguments: s.siteId);
                          },
                        ),
                      ).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
    Color iconColor = Colors.black87,
    Color iconBgColor = const Color(0xffF2F2F7),
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 8, top: 12,bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xffE9E9EE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36,
            width: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 20,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 14),
          AppText(
            value,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
          const SizedBox(height: 4),
          AppText(
            title,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: const Color(0xff8E8E93),
          ),
        ],
      ),
    );
  }
}