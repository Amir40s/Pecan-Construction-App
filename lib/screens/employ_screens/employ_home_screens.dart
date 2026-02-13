import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/config/routes/routes_name.dart';
import 'package:pecan_construction/core/widgets/app_buttons.dart';
import 'package:sizer/sizer.dart';

import '../../core/widgets/app_text.dart';
import '../admin_screens/components/admin_home_widgets.dart';
import 'components/employee_home_screen_components.dart';
import 'controllers/employee_home_controller.dart';

class EmployHomeScreens extends GetView<EmployeeHomeController> {
  const EmployHomeScreens({super.key});

  @override
  Widget build(BuildContext context) {
    // NOTE: controller will come from Binding (recommended)
    // If you are not using binding yet, you can uncomment:
    // final c = Get.put(EmployeeHomeController());
    final c = controller;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: SafeArea(
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
                  child: EmployeeCalendarViewTabs(c: c),
                ),

                /// Calendar Box
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
                        EmployeeMonthHeaderRow(c: c),
                        const SizedBox(height: 6),
                        EmployeeMonthCalendarGrid(c: c),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                /// Active Sites Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Obx(() {
                    if (c.sites.isEmpty) {
                      return SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          "Assigned Sites (${c.sites.length})",
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: c.sites.length,
                          itemBuilder: (context, index) {
                            final site = c.sites[index];
                            return Container(
                              width: 95.w,
                              height: 15.h,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: BoxBorder.all(
                                  color: Colors.grey.shade300,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 2,
                                  )
                                ]
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Gap(1.h),
                                        AppText(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          site.title,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        Gap(0.5.h),
                                        AppText(
                                          site.subtitle,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade600,
                                        ),
                                        Gap(1.5.h),
                                        Row(
                                          children: [
                                            AppButtonWidget(
                                              onPressed: (){
                                                Get.toNamed(RoutesName.EmployeeSiteDetailsScreen);
                                              },
                                              text: site.buttonText,
                                              width: 30.w,
                                              height: 4.h,
                                              buttonColor:
                                                  site.buttonText == "Resume"
                                                  ? Color(0xffF2CFCE)
                                                  : Color(0xffC22522),
                                            ),
                                            Gap(0.5.h),
                                            AppButtonWidget(
                                              text: "!",
                                              width: 10.w,
                                              height: 4.h,
                                              buttonColor: Color(0xffDADADA),
                                              textColor: Colors.black87,
                                              fontSize: 23,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Gap(0.5.h),
                                  Expanded(
                                    flex:1,
                                    child: Container(
                                       height: 120,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(image: AssetImage(site.imageAsset), fit: BoxFit.cover)
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }),
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
