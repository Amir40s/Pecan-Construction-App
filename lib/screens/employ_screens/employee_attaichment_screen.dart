import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/core/constant/app_icons.dart';
import 'package:pecan_construction/core/widgets/header_widget.dart';
import 'package:sizer/sizer.dart';

import '../../core/widgets/app_text.dart';
import 'controllers/attaichment_controller.dart';

class AttachmentsScreen extends GetView<AttachmentsController> {
  const AttachmentsScreen({super.key});

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
                    AppText("Attachments", fontSize: 20,fontWeight: FontWeight.w800,)
                  ],
                ),
                Spacer(),
                IconButton(onPressed: () {}, icon: Icon(Icons.add_a_photo,size: 30,)),
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
                      "Recent Uploads",
                      color: textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                    const SizedBox(height: 10),

                    SizedBox(
                      height: 24.h,
                      child: Obx(() {
                        final list = controller.recentUploads;
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: list.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final item = list[index];
                            return _RecentUploadTile(
                              item: item,
                              border: border,
                              onOpen: () => controller.openAttachment(item),
                              onDownload: () =>
                                  controller.downloadAttachment(item),
                            );
                          },
                        );
                      }),
                    ),

                    const SizedBox(height: 18),

                    // All Files
                    AppText(
                      "All Files",
                      color: textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                    const SizedBox(height: 10),

                    Obx(() {
                      final files = controller.allFiles;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: files.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.15,
                            ),
                        itemBuilder: (context, index) {
                          final item = files[index];
                          return _FileCard(
                            item: item,
                            border: border,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                            onTap: () => controller.openAttachment(item),
                          );
                        },
                      );
                    }),
                    SizedBox(height: 2.h),
                    AppText(
                      "Employee Photos",
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
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

class _RecentUploadTile extends StatelessWidget {
  final AttachmentItem item;
  final Color border;
  final VoidCallback onOpen;
  final VoidCallback onDownload;

  const _RecentUploadTile({
    required this.item,
    required this.border,
    required this.onOpen,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 40.w,
        height: 22.h,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Stack(
          children: [
            // image
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: item.isThumbNetwork
                    ? Image.network(item.thumbPath ?? "", fit: BoxFit.cover)
                    : Image.asset(item.thumbPath ?? "", fit: BoxFit.cover),
              ),
            ),

            // download icon
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

            // filename label bottom-left
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
                  item.title,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
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

class _FileCard extends StatelessWidget {
  final AttachmentItem item;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onTap;

  const _FileCard({
    required this.item,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPdf = item.isPdf;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isPdf
                    ? const Color(0xFFEFF6FF)
                    : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(child: SvgPicture.asset(AppIcons.pdfFileIcon)),
            ),
            const SizedBox(height: 10),
            AppText(
              item.title,
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: textPrimary,
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            AppText(
              item.subtitle,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
