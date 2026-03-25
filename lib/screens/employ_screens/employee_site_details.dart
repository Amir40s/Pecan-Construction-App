import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/config/routes/routes_name.dart';
import 'package:pecan_construction/core/constant/app_icons.dart';
import 'package:pecan_construction/core/constant/app_images.dart';
import 'package:pecan_construction/core/services/string_translation_extension.dart';
import 'package:pecan_construction/core/widgets/header_widget.dart';
import '../../core/widgets/app_text.dart';
import 'components/employeeSiteDetails_components.dart';
import 'controllers/employee_site_details_controller.dart';

class EmployeeSiteDetailsScreen extends GetView<EmployeeSiteDetailsController> {
   EmployeeSiteDetailsScreen({super.key});
   final args = Get.arguments ?? {};
  @override
  Widget build(BuildContext context) {
    final bool fromSitesScreen = args["fromSitesScreen"] ?? false;

    final bg = const Color(0xFFF6F7FB);
    final card = Colors.white;
    final textPrimary = const Color(0xFF111827);
    final textSecondary = const Color(0xFF6B7280);
    final border = const Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Obx(() {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top bar
                    CustomHeader(
                      title: "site_details".tr,
                      showBack: true,
                    ),
                    const SizedBox(height: 12),
          SiteStatusRow(
          title: controller.siteTitle.toString().trn,
          subtitle: controller.siteDescription.toString().trn,

          status: controller.siteStatus.value.trim().toLowerCase() == "active"
          ? "Active"
              : controller.siteStatus.value.trim().toLowerCase() == "completed"
          ? "Completed"
              : controller.siteStatus.value.trim().toLowerCase() == "paused"
          ? "Paused"
              : "Unknown",

          statusColor: controller.siteStatus.value.trim().toLowerCase() == "active"
          ? const Color(0xFFC22522) // red
              : controller.siteStatus.value.trim().toLowerCase() == "completed"
          ? const Color(0xFF10B981) // green
              : controller.siteStatus.value.trim().toLowerCase() == "paused"
          ? Colors.grey // grey
              : Colors.amber,
          ),
                    // Top Site Card (Title + Open in Maps + Map)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // left icon
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE7E7),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: SvgPicture.asset( AppIcons.locationIcon,)

                                ),
                              ),
                              const SizedBox(width: 10),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                     "ABC Testing ",
                                      color: textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    const SizedBox(height: 2),
                                    InkWell(
                                      onTap: controller.onTapOpenInMaps,
                                      child: AppText(
                                        controller.openInMapsText.value,
                                        color: textSecondary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              InkWell(
                                onTap: (){
                                },
                                child: Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child:  Image.asset(
                                AppImages.GoogleMapImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Assigned Staff
                    AppText(
                      "assigned_staff".tr,
                      color: textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                    const SizedBox(height: 8),
                    Obx(() {
                      final staff = controller.assignedStaff;
                      return Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: staff.map((name) => _NameChip(
                            name: name,
                            border: border,
                            textColor: textPrimary,),).toList(),
                      );
                    }),

                    const SizedBox(height: 14),

                    // Site Description
                    AppText(
                      "site_description".tr,
                      color: textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: border),
                      ),
                      child: AppText(
                        controller.siteNote.value.trn,
                        color: textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Attachments header
                  Row(
                    children: [
                      AppText(
                        "attachments".tr,
                        color: textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                      const Spacer(),

                      if (!fromSitesScreen) //  condition
                        InkWell(
                          onTap: () {
                            Get.toNamed(
                              RoutesName.AttachmentsScreen,
                              arguments: {
                                "siteId": args["siteId"],
                              },
                            );
                          },
                          child: AppText(
                            "see_all".tr,
                            color: const Color(0xffC22522),
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                    ],
                  ),

                    const SizedBox(height: 10),

                    // Attachments grid (2 columns like screenshot)
                    Obx(() {
                      final items = controller.attachments;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.35,
                        ),
                        itemBuilder: (context, index) {
                          final att = items[index];
                          if (att.isImage) {
                            return _ImageAttachmentTile(
                              att: att,
                              border: border,
                              onTap: () => controller.onTapAttachment(att),
                              onDownload: () => controller.onTapDownload(att),
                            );
                          }
                          return _PdfAttachmentTile(
                            att: att,
                            border: border,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                            onTap: () => controller.onTapAttachment(att),
                            onDownload: () => controller.onTapDownload(att),
                          );
                        },
                      );
                    }),

                    const SizedBox(height: 18),
                  ],
                ),
              ),

              // Loader overlay
              if (controller.isLoading.value)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.12),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class SiteStatusRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final Color statusColor;

  const SiteStatusRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Left side (title + subtitle)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          /// Status indicator
          Row(
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ------- Chips -------
class _NameChip extends StatelessWidget {
  final String name;
  final Color border;
  final Color textColor;

  const  _NameChip({
    required this.name,
    required this.border,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(999),
      ),
      child: AppText(
        overflow: TextOverflow.ellipsis,
        name,
        color: textColor,
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

/// ------- Image attachment tile (with download icon) -------
class _ImageAttachmentTile extends StatelessWidget {
  final SiteAttachment att;
  final Color border;
  final VoidCallback onTap;
  final VoidCallback onDownload;

  const _ImageAttachmentTile({
    required this.att,
    required this.border,
    required this.onTap,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: att.isThumbNetwork
                    ? Image.network(att.thumbPathOrUrl ?? "", fit: BoxFit.cover)
                    : Image.asset(att.thumbPathOrUrl ?? "", fit: BoxFit.cover),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: InkWell(
                onTap: onDownload,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.download_rounded, size: 18),
                ),
              ),
            ),
            Positioned(
              left: 8,
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: AppText(
                  att.title,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ------- PDF attachment tile -------
class _PdfAttachmentTile extends StatelessWidget {
  final SiteAttachment att;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onTap;
  final VoidCallback onDownload;

  const _PdfAttachmentTile({
    required this.att,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.onTap,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final isBlue = att.title.toLowerCase().contains("safety");

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isBlue ? const Color(0xFFEFF6FF) : const Color(0xFFFFE7E7),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.picture_as_pdf_rounded,
                        color: isBlue ? const Color(0xFF2563EB) : const Color(0xFFC22522),
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  AppText(
                    att.title,
                    color: textPrimary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    att.subtitle,
                    color: textSecondary,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: InkWell(
                onTap: onDownload,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.download_rounded, size: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
