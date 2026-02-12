import 'package:flutter/material.dart' hide Card;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:pecan_construction/core/constant/app_icons.dart';
import 'package:pecan_construction/core/constant/app_images.dart';
import 'package:pecan_construction/core/widgets/header_widget.dart';
import 'package:pecan_construction/screens/admin_screens/add_ataichment_screen.dart';
import 'package:sizer/sizer.dart';
import '../../core/models/attaichment_model.dart';
import '../../core/widgets/app_text.dart';
import 'components/site_details_components/site_details_component.dart';

class SiteDetailsScreen extends StatelessWidget {
  const SiteDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF6F7FB);
    final card = Colors.white;
    final textPrimary = const Color(0xFF111827);
    final textSecondary = const Color(0xFF6B7280);
    final border = const Color(0xFFE5E7EB);
  List<String> assignEmployee = ['Uzair ahmad', "Farhan (MP)", "Haron khan", "Hussan khan", "Arbaz khan"];
  List<AttachmentModel> attaichedment_list = [
    AttachmentModel(
      name: "Foundation_Steel.jpg",
      sizeText: "1.4 MB",
      type: AttachmentType.image,
      thumbnailPath: AppImages.SiteAttichmentPic, // replace with real preview image asset
    ),
    AttachmentModel(
      name: "Blueprints_V2.pdf",
      sizeText: "2.4 MB",
      type: AttachmentType.pdf,
    ),
    AttachmentModel(
      name: "Excavation_Update.png",
      sizeText: "1.8 MB",
      type: AttachmentType.image,
      thumbnailPath: AppImages.SiteAttichmentPic2, // replace with real preview image asset
    ),
    AttachmentModel(
      name: "Safety_Manual.pdf",
      sizeText: "1.4 MB",
      type: AttachmentType.pdf,
    ),
  ];
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeader(title: "Site Details", showBack: true),
              SizedBox(height: 4.h),

              Row(
                children: [
                  AppText(
                    "Downtown Plaza Renovation",
                    color: textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Container(
                        width: 4.w,
                        height: 2.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.yellowAccent,
                        ),
                      ),
                      SizedBox(width: 1.w,),
                      AppText("In progress", fontSize: 11,color: Colors.grey.shade500,),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  AppText(
                    "Site #420",
                    color: textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(width: 2.w),
                  AppText("•", color: textSecondary, fontSize: 13),
                  SizedBox(width: 2.w),
                  AppText(
                    "Interior Finishing",
                    color: textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),

              SizedBox(height: 4.h),

              Card(
                color: card,
                borderColor: border,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                            color: Color(0xffF2CFCE),
                            borderRadius: BorderRadius.circular(12)
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              "123B Construction",
                              color: textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                            AppText("Open in Maps", fontSize: 12,color: Colors.grey.shade700,fontWeight: FontWeight.bold,)
                          ],
                        ),
                        Spacer(),
                        Container(
                          height: 8.h,
                          width: 8.w,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle
                          ),
                          child: Center(child: Icon(Icons.arrow_right_sharp),),
                        )
                      ],
                    ),

                    SizedBox(height: 2.h),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: AspectRatio(
                        aspectRatio: 12 / 9,
                        child: Image.asset(
                          AppImages.GoogleMapImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              AppText("Assign Staff", fontSize: 16, fontWeight: FontWeight.w800),
              SizedBox(height: 1.h),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: assignEmployee.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3.2, // chip width/height adjust
                ),
                itemBuilder: (context, index) {
                  return NameChip(name: assignEmployee[index]);
                },
              ),
              SizedBox(height: 2.h),
              AppText("Site Description", fontSize: 16, fontWeight: FontWeight.w800),
              SizedBox(height: 1.h),
              Container(
                width: 95.w,
                height: 15.h,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: BoxBorder.all(color: Colors.grey.shade300)
                ),
                child: AppText("Main logistics terminal with 24-bay loading dock.Foundations completed. Currently in steel framing phase.Ensure all safety equipment is inspected by EOD Friday. ",fontSize: 15,fontWeight: FontWeight.w400, color: Color(0xff757575),),
              ),
              SizedBox(height: 2.h),

              Row(
                children: [
                  AppText(
                    "Attachments",
                    color: textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                  const Spacer(),
                  AppText(
                    "See All",
                    color: const Color(0xFFC22522),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
              SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: attaichedment_list.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.08,
            ),
            itemBuilder: (context, i) {
              return AttachmentCard(
                model: attaichedment_list[i],
                onRemove: () {

                },
              );
            },
          ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _GlassIconButton({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}
