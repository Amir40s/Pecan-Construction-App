import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/config/routes/routes_name.dart';
import 'package:pecan_construction/core/services/string_translation_extension.dart';
import 'package:pecan_construction/core/widgets/app_buttons.dart';
import 'package:pecan_construction/screens/auth_screens/controllers/signup_controller.dart';
import 'package:sizer/sizer.dart';
import '../../core/constant/app_images.dart';
import '../../core/localizations/locale_controller.dart';
import '../../core/widgets/app_text.dart';
import '../../core/widgets/appnetworkImage.dart';
import 'components/employee_home_screen_components.dart';
import 'controllers/employee_home_controller.dart';

class EmployHomeScreens extends GetView<EmployeeHomeController> {
  EmployHomeScreens({super.key});
  final profileController = Get.put(SignUpController());
  final localeController = Get.find<LocaleController>();

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: RefreshIndicator(
        onRefresh: () => controller.watchMySites(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Obx(() => AppNetworkImage(
                              url: profileController.avatarUrl.value,
                              isCircle: true,
                              width: 14.w,
                              height: 14.w,
                              placeholderAsset: AppImages.profileImage,
                              borderWidth: 3,
                              borderColor: Colors.white,
                            )
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Obx(
                            () => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  "welcome".tr,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff979796),
                                ),
                                AppText(
                                  profileController.employeeName.value,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      child: Container()
                      // EmployeeCalendarViewTabs(c: c),
                      ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Obx(() {
                      if (c.isLoading.value) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if (c.errorText.isNotEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              c.errorText.value,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      }
                      if (c.sites.isEmpty) {
                        return  Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text("no_sites_assigned".tr),
                          ),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            "${"assigned_sites".tr} (${c.sites.length})",
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                          const SizedBox(height: 8),
                          Obx(() {
                            controller.refreshTrigger.value;
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: c.filteredSites.length,
                              itemBuilder: (context, index) {
                                final s = c.filteredSites[index];
                                final isVisited = c.isSiteViewed(s.siteId);

                                final buttonText = isVisited ? "resume".tr : "check_in".tr;
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start, // Left align
                                          mainAxisSize: MainAxisSize.min,               // Take only needed height
                                          children: [
                                            // Site Name
                                            AppText(
                                              s.siteName.trn,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                            ),

                                            SizedBox(height: 4), // Small gap instead of large Gap

                                            // Site Description
                                            AppText(
                                              s.siteDescription!.trn,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey.shade600,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                            ),

                                            SizedBox(height: 12), // Small gap

                                            // Button
                                            AppButtonWidget(
                                              alignment: Alignment.centerLeft,
                                              onPressed: () {
                                                log(s.siteId);

                                                if (!isVisited) {
                                                  c.markSiteViewed(s.siteId);
                                                }

                                                Get.toNamed(
                                                  RoutesName.EmployeeSiteDetailsScreen,
                                                  arguments: {
                                                    "siteId": s.siteId,
                                                    "fromSitesScreen": false, //  or just don't send
                                                  },
                                                );
                                              },
                                              text: buttonText,
                                              width: 30.w,
                                              height: 4.h,
                                              buttonColor: isVisited ? const Color(0xffF2CFCE) : const Color(0xffC22522),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Gap(2.w),
                                      Expanded(
                                        flex: 1,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: (s.sitePhoto != null &&
                                                  s.sitePhoto!
                                                      .trim()
                                                      .isNotEmpty)
                                              ? AppNetworkImage(
                                            url: s.sitePhoto!,
                                            isCircle: false,
                                            width: 25.w,
                                            height: 24.w,
                                            placeholderAsset: AppImages.profileImage,
                                            borderWidth: 3,
                                            borderColor: Colors.white,
                                          )
                                              : Container(
                                                  height: 120,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade300),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    image:
                                                        const DecorationImage(
                                                      image: AssetImage(
                                                          "assets/images/site_thumb.png"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          })
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
      ),
    );
  }
}
