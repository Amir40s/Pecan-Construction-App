import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/core/constant/app_icons.dart';
import 'package:pecan_construction/core/widgets/header_widget.dart';
import 'package:sizer/sizer.dart';

import '../../core/models/attaichment_model.dart';
import '../../core/widgets/app_text.dart';
import '../../core/widgets/appnetworkImage.dart';
import 'components/employeeSiteDetails_components.dart';
import 'controllers/attaichment_controller.dart';
import 'controllers/employee_site_details_controller.dart';

class AttachmentsScreen extends GetView<AttachmentsController> {
   AttachmentsScreen({super.key});
  final args = Get.arguments;
  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF6F7FB);
    final textPrimary = const Color(0xFF111827);
    final textSecondary = const Color(0xFF6B7280);
    final border = const Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 2.h),
            // Header
            Row(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 19),
                        width: 7.w,
                        height: 4.h,
                        padding: EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black87),
                        child: Center(child: Icon(Icons.arrow_back_ios, color: Colors.white,size: 20,)),
                      ),
                    ),
                    SizedBox(width: 20.w,),
                    AppText( "attachments".tr, fontSize: 20,fontWeight: FontWeight.w800,)
                  ],
                ),
                Spacer(),
                Obx(() => controller.isLoading.value
                    ? Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          print(controller.siteId);
                          controller.captureAndUploadPhoto(controller.siteId!);
                          print(args["siteId"]);
                        },
                        icon: Icon(Icons.add_a_photo, size: 30),
                      ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recent Uploads
                    AppText(
                      "admin_uploads".tr,
                      color: textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),


                    const SizedBox(height: 18),

                    // All Files Section - Horizontal Scroll
                    SizedBox(
                      height: 28.h, // adjust card height
                      child: Obx(() {
                        final files = controller.allFiles;
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: files.length,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final item = files[index];

                            return _FileCardHorizontal(
                              item: item,
                              textPrimary: textPrimary,
                              textSecondary: textSecondary,
                              onTap: () => controller.openAttachment(item),
                            );
                          },
                        );
                      }),
                    ),
                    SizedBox(height: 2.h),
                    AppText(
                      "employee_photos".tr,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      final photos = controller.employeePhotos;

                      if (photos.isEmpty) {
                        return  Center(child: Text("no_photos_yet".tr));
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 columns
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1, // square cards
                        ),
                        itemCount: photos.length,
                        itemBuilder: (context, index) {
                          final url = photos[index];
                          return _EmployeePhotoCard(
                            url: url,
                            onTap: () {
                              Get.to(() => FullScreenImagePreview(
                                att: SiteAttachment(
                                  id: url,
                                  title: "employee_photo".tr,
                                  subtitle: "",
                                  type: AttachmentType.image,
                                  thumbPathOrUrl: url,
                                  isThumbNetwork: true,
                                  url: url,
                                ),
                              ));
                            },
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmployeePhotoCard extends StatelessWidget {
  final String url;
  final VoidCallback onTap;

  const _EmployeePhotoCard({
    required this.url,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 40.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AppNetworkImage(
            url: url,
            isCircle: false,
            width: 20.w,
            height: 20.w,
            placeholderAsset: "",
            borderWidth: 3,
            borderColor: Colors.white,
          )
        ),
      ),
    );
  }
}


class _FileCardHorizontal extends StatelessWidget {
  final AttachmentItem item;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onTap;

  const _FileCardHorizontal({
    required this.item,
    required this.textPrimary,
    required this.textSecondary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPdf = item.isPdf;
    final isImage = item.isImage;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 40.w, // card width
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // File / Image Preview
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: isImage
                    ? AppNetworkImage(
                  url: item.thumbPath,
                  isCircle: false,
                  width:double.infinity,
                  height: 20.w,
                  placeholderAsset: "",
                  borderWidth: 3,
                  borderColor: Colors.white,
                )
                    : Container(
                  color: const Color(0xFFF3F4F6),
                  child: Center(
                    child: isPdf
                        ? SvgPicture.asset(AppIcons.pdfFileIcon, width: 40)
                        : Icon(Icons.insert_drive_file, size: 40, color: Colors.grey),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // File Name
            AppText(
              item.title,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: textPrimary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // File Type / Extension
            AppText(
              item.subtitle,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}