import 'package:flutter/material.dart' hide Card;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/core/constant/app_icons.dart';
import 'package:pecan_construction/core/constant/app_images.dart';
import 'package:pecan_construction/core/widgets/header_widget.dart';
import 'package:sizer/sizer.dart';
import '../../core/models/attaichment_model.dart';
import '../../core/widgets/app_text.dart';
import '../../core/widgets/appnetworkImage.dart';
import 'admin_controller/admin_site_detailsController.dart';
import 'components/site_details_components/site_details_component.dart';

class SiteDetailsScreen extends StatelessWidget {
  SiteDetailsScreen({super.key});

  final AdminSiteDetailsController controller =
  Get.put(AdminSiteDetailsController());
  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF6F7FB);
    final card = Colors.white;
    final textPrimary = const Color(0xFF111827);
    final border = const Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomHeader(title: "site_details".tr, showBack: true),                SizedBox(height: 4.h),

                /// Title + status
                Row(
                  children: [
                    Expanded(
                      child: AppText(
                        controller.siteTitle.value.isEmpty
                            ? "site".tr
                            : controller.siteTitle.value,
                        color: textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 4.w,
                          height: 2.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: controller.siteStatus.value.toLowerCase() ==
                                "active"
                                ? Colors.green
                                : Colors.yellowAccent,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        AppText(
                          controller.siteStatus.value,
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 1.h),

                /// Location Card
                Card(
                  color: card,
                  borderColor: border,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: controller.onTapOpenInMaps,
                        child: Row(
                          children: [
                            Container(
                              width: 12.w,
                              height: 5.h,
                              decoration: BoxDecoration(
                                color: const Color(0xffF2CFCE),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: CircleIcon(
                                  bg: const Color(0xFFFFE7E7),
                                  child: SvgPicture.asset(
                                    AppIcons.locationIcon,
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: GestureDetector(
                                onTap: controller.onTapOpenInMaps,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      controller.siteAddress.value.isEmpty
                                          ? "no_address".tr
                                          : controller.siteAddress.value,
                                      color: textPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    AppText(
                                      controller.openInMapsText.value,
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: controller.onTapOpenInMaps,
                              child: Container(
                                height: 8.h,
                                width: 8.w,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(Icons.arrow_right_sharp),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 2.h),

                      GestureDetector(
                        onTap: controller.onTapOpenInMaps,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: AspectRatio(
                            aspectRatio: 12 / 9,
                            child: AppNetworkImage(
                              url: "",
                              fit: BoxFit.cover,
                              placeholderAsset: AppImages.GoogleMapImage,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2.h),

                /// Assigned Staff
                 AppText(
                  "assign_staff".tr,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
                SizedBox(height: 1.h),

                controller.assignedStaff.isNotEmpty
                    ? GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.assignedStaff.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3.2,
                  ),
                  itemBuilder: (context, index) {
                    return NameChip(
                      name: controller.assignedStaff[index],
                    );
                  },
                )
                    : AppText(
                  "no_staff_assigned".tr,
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),

                SizedBox(height: 2.h),

                /// Description
                 AppText(
                  "site_description".tr,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
                SizedBox(height: 1.h),
                Container(
                  width: 95.w,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: AppText(
                    controller.siteDescription.value.isEmpty
                        ? "no_description_available".tr
                        : controller.siteDescription.value,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff757575),
                  ),
                ),

                SizedBox(height: 2.h),

                /// Attachments
                Row(
                  children: [
                    AppText(
                      "attachments".tr,
                      color: textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
            controller.attachments.isNotEmpty
                ? GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.attachments.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.81,
              ),
              itemBuilder: (context, i) {
                final attachment = controller.attachments[i];

                return GestureDetector(
                  onTap: () {
                    if (attachment.url != null && attachment.url!.isNotEmpty) {
                      controller.downloadAndOpenFile(
                        attachment.url!,
                        attachment.title ?? "file_${DateTime.now().millisecondsSinceEpoch}",
                      );
                    } else {
                      Get.snackbar("Error", "File not available");
                    }
                  },
                  child: AttachmentTile(
                    title: attachment.title,
                    subtitle: attachment.subtitle ?? 'File',
                    iconSvg: controller.getAttachmentIcon(attachment.type),
                    networkUrl: attachment.url,
                    isImageThumb: attachment.type == AttachmentType.image,
                  ),
                );
              },
            )
                : AppText(
              "no_attachments_found".tr,
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
              ],
            ),
          );
        }),
      ),
    );
  }
}