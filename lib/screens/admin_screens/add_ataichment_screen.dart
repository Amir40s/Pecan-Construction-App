import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/core/constant/app_icons.dart';
import 'package:pecan_construction/core/widgets/app_buttons.dart';
import 'package:pecan_construction/core/widgets/app_text.dart';
import 'package:pecan_construction/core/widgets/appnetworkImage.dart';
import 'package:sizer/sizer.dart';
import 'package:pecan_construction/core/widgets/header_widget.dart';
import '../../core/models/attaichment_model.dart';
import 'admin_controller/create_site_controller.dart';

class AddAttachmentScreen extends StatelessWidget {
  AddAttachmentScreen({super.key});

  final controller = Get.put(CreateSiteController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               CustomHeader(title: "add_attachment".tr, showBack: true),
              SizedBox(height: 2.h),

              _ActionTile(
                iconContainerColor: Color(0xffEBC9C9),
                icon: SvgPicture.asset(AppIcons.cameraIcon),
                title: "take_photo".tr,
                subTitle: "take_photo_sub".tr,
                onTap: controller.captureAttachmentFromCamera,
              ),
              const SizedBox(height: 10),

              _ActionTile(
                iconContainerColor: Color(0xffC7CDEC),
                icon: SvgPicture.asset(AppIcons.galleryIcon),
                title: "upload_gallery".tr,
                subTitle: "upload_gallery_sub".tr,
                onTap: controller.pickAttachmentImagesFromGallery,
              ),
              const SizedBox(height: 10),

              _ActionTile(
                iconContainerColor: Color(0xffF4E8BC),

                icon: SvgPicture.asset(AppIcons.fileIcon),
                title: "upload_file".tr,
                subTitle: "upload_file_sub".tr,
                onTap: controller.pickFiles,
              ),

              SizedBox(height: 2.h),

               Text(
                "attachments".tr,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),

              Obx(() {
                final list = controller.attachmentPreviewList;

                if (list.isEmpty) {
                  return  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "no_attachments".tr,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.08,
                  ),
                  itemBuilder: (context, i) {
                    return AttachmentCard(
                      model: list[i],
                      onRemove: () => controller.removeAttachmentAt(i),
                    );
                  },
                );
              }),
              SizedBox(height: 3.h),

             Obx((){
               return AppButtonWidget(
                 width: 90.w,
                 height: 15.w,
                 buttonColor: Colors.redAccent.shade200,
                 onPressed: controller.isSaving.value ? null :  (){
                    controller.saveSite();
                 },
                 text: "save_site".tr,
                 loader: controller.isSaving.value,

               );
             }
             ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subTitle;
  final VoidCallback onTap;
  final Color iconContainerColor;
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.onTap,
    required this.iconContainerColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xffffffff),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xffEAEAEA)),
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: iconContainerColor,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Center(child: icon),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xff8E8E8E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AttachmentCard extends StatelessWidget {
  final AttachmentModel model;
  final VoidCallback onRemove;

  const AttachmentCard({
    super.key,
    required this.model,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isPdf = model.type == AttachmentType.pdf;
    final isFile = model.type == AttachmentType.file;

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xffEAEAEA)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: isPdf || isFile ? _filePreview(isPdf: isPdf) : _imagePreview(),
          ),
        ),

        Positioned(
          top: 6,
          right: 6,
          child: InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 26,
              width: 26,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xffEAEAEA)),
              ),
              child: const Icon(Icons.close, size: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _filePreview({required bool isPdf}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xffF6F6F6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 22.w,
            height: 6.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffF2CFCE),
            ),
            child: Center(
              child: SvgPicture.asset(
                isPdf ? AppIcons.pdfFileIcon : AppIcons.fileIcon,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            model.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Color(0xff8E8E8E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            model.sizeText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 11,
              color: Color(0xff8E8E8E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePreview() {
    return Stack(
      children: [
        Positioned.fill(
          child: model.thumbnailPath != null && model.thumbnailPath!.isNotEmpty
              ? Image.file(
            File(model.thumbnailPath!),
            fit: BoxFit.cover,
          )
              : Container(
            color: const Color(0xffF6F6F6),
            child: const Center(
              child: Icon(Icons.image, size: 30),
            ),
          ),
        ),
        Positioned(
          left: 8,
          right: 8,
          bottom: 8,
          child: AppText(
            model.name,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
