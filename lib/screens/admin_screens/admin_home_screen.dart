import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/config/routes/routes_name.dart';
import 'package:sizer/sizer.dart';
import 'package:pecan_construction/core/widgets/app_text.dart'; // if you want to use AppText
import 'admin_controller/admin_home_controller.dart';
import 'components/admin_home_widgets.dart';

class AdminHomeScreen extends StatelessWidget {
  AdminHomeScreen({super.key});

  final c = Get.put(AdminHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
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
                      Obx(
                        () => Container(
                          height: 9.h,
                          width: 12.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(c.profileImage.value),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              c.welcomeText.value,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff979796),
                            ),
                            AppText(
                              c.adminName.value,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                const Divider(height: 1),

                /// Day/Week/Month Tabs
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: CalendarViewTabs(c: c),
                ),

                /// Calendar Box (Month view shown like screenshot)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xffEAEAEA)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        MonthHeaderRow(c: c),
                        const SizedBox(height: 6),
                        MonthCalendarGrid(c: c),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                /// Active Sites
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Obx(
                    () => ActiveSitesHeader(
                      count: c.sites.length,
                      onSeeAll: () {

                      },
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Obx(
                    () => Column(
                      children: c.sites
                          .map(
                            (s) => SiteCard(
                              site: s,
                              onView: () {
                               Get.toNamed(RoutesName.SiteDetailsScreen);
                              },
                            ),
                          )
                          .toList(),
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
}
