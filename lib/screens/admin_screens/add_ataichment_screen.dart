import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/core/constant/app_icons.dart';
import 'package:pecan_construction/core/widgets/app_text.dart';
import 'package:sizer/sizer.dart';
import 'package:pecan_construction/core/widgets/header_widget.dart';
import '../../core/models/attaichment_model.dart';
import 'admin_controller/add_attaichment_controller.dart';

class AddAttachmentScreen extends GetView<AddAttachmentController> {
  AddAttachmentScreen({super.key});

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
              const CustomHeader(title: "Add Attachment", showBack: true),
              SizedBox(height: 2.h),

              _ActionTile(
                iconContainerColor: Color(0xffEBC9C9),
                icon: SvgPicture.asset(AppIcons.cameraIcon),
                title: "Take Photo",
                subTitle: "Capture an image using camera",
                onTap: controller.takePhoto,
              ),
              const SizedBox(height: 10),

              _ActionTile(
                iconContainerColor: Color(0xffC7CDEC),
                icon: SvgPicture.asset(AppIcons.galleryIcon),
                title: "Upload from Gallery",
                subTitle: "Choose from your photo library",
                onTap: controller.uploadFromGallery,
              ),
              const SizedBox(height: 10),

              _ActionTile(
                iconContainerColor: Color(0xffF4E8BC),

                icon: SvgPicture.asset(AppIcons.fileIcon),
                title: "Upload File / PDF",
                subTitle: "Select documents or blueprints",
                onTap: controller.uploadFilePdf,
              ),

              SizedBox(height: 2.h),

              const Text(
                "Attachments",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),

              Obx(() {
                final list = controller.attachments;
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
                      onRemove: () => controller.removeAt(i),
                    );
                  },
                );
              }),

              SizedBox(height: 3.h),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffC22522),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: controller.onSaveSite,
                  child: const Text(
                    "Save Site",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
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
    required this.model,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isPdf = model.type == AttachmentType.pdf;

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xffEAEAEA)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: isPdf
                      ? Container(
                    width: double.infinity,
                    color: const Color(0xffF6F6F6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Container(
                          width: 22.w,
                            height: 6.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffF2CFCE)
                            ),
                            child: Center(child: SvgPicture.asset(AppIcons.pdfFileIcon))),
                        SizedBox(height: 6),
                        const SizedBox(height: 2),
                        Text(
                          model.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xff8E8E8E),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          model.sizeText,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Color(0xff8E8E8E),
                          ),
                        ),
                      ],
                    ),
                  )
                      : Stack(
                        children: [
                          Image.asset(
                            model.thumbnailPath ?? "",
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                                child: AppText(model.name, fontSize: 11,fontWeight: FontWeight.w800,color: Colors.white,)),
                          )
                        ],
                      ),
                ),
              ),

            ],
          ),
        ),

        // remove button
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
}
