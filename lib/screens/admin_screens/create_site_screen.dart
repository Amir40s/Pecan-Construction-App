import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/config/routes/routes_name.dart';
import 'package:pecan_construction/core/widgets/app_buttons.dart';
import 'package:pecan_construction/core/widgets/app_text.dart';
import 'package:pecan_construction/core/widgets/header_widget.dart';
import 'package:pecan_construction/screens/admin_screens/admin_controller/create_site_controller.dart';
import 'package:pecan_construction/screens/admin_screens/pick_location_screen.dart';
import 'package:sizer/sizer.dart';

import '../../core/constant/app_icons.dart';
import '../../core/widgets/app_text_field.dart';

class CreateSiteScreen extends GetView<CreateSiteController> {
  CreateSiteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomHeader(title: "create_new_site".tr, showBack: true),
                SizedBox(height: 1.h),
                AppText(
                  "add_site_photo".tr,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                SizedBox(height: 1.h),
                Obx(() => InkWell(
                  onTap: () {
                    controller.pickMainImageFromGallery();
                  },
                  child: Container(
                    width: 95.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: controller.selectedSiteImage.value != null
                        ? Image.file(
                      controller.selectedSiteImage.value!,
                      fit: BoxFit.cover,
                    )
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_rounded,
                          size: 90,
                          color: Colors.grey.shade300,
                        ),
                        AppText(
                          "upload_photo_hint".tr,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ),
                )),
                SizedBox(height: 2.h),
                AppText(
                  "site_name".tr,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
                SizedBox(height: 1.h),
                AppFormField(
                  title:"site_name_hint".tr,
                  textEditingController: controller.siteNameC,
                  showBorder: true,
                  borderColor: Colors.grey.shade300,
                ),
                SizedBox(height: 2.h),
                AppText(
                  "address".tr,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
                SizedBox(height: 1.h),
                AppFormField(
                  onTap: () async {
                    final result = await Get.to(() => const PickLocationScreen());

                    if (result != null) {
                      controller.siteAddressC.text = result['address'] ?? "";

                      controller.setCoordinates(
                        latitude: result['lat'],
                        longitude: result['lng'],
                      );
                    }
                  },
                  readOnly: true,

                  iconWidget: SvgPicture.asset(AppIcons.pointLocationIcon),
                  title: "site_address_hint".tr,
                  textEditingController: controller.siteAddressC,
                  showBorder: true,
                  borderColor: Colors.grey.shade300,
                ),
                SizedBox(height: 2.h),
                AppText(
                  "start_date".tr,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
                SizedBox(height: 1.h),
                AppFormField(
                  readOnly: true,
                  onTap: () => controller.pickDate(context),
                  iconWidget: SvgPicture.asset(AppIcons.calenderIcon),
                  textEditingController: controller.selectedStartDate,
                  title: "start_date_hint".tr,
                  showBorder: true,
                  borderColor: Colors.grey.shade300,
                ),
                SizedBox(height: 2.h),

                AppText(
                  "status".tr,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
                SizedBox(height: 1.h),
                AppFormField(
                  readOnly: true,
                  icon: Icons.arrow_drop_down,
                  textEditingController: controller.selectedStatus,
                  title:"active".tr,
                  showBorder: true,
                  borderColor: Colors.grey.shade300,

                  onTap: () {
                    _showStatusDropdown(context);
                  },
                ),

                SizedBox(height: 2.h),

                AppText(
                  "add_note".tr,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
                SizedBox(height: 1.h),
                AppFormField(
                  title:"add_note".tr,
                  textEditingController: controller.siteNoteC,
                  showBorder: true,
                  borderColor: Colors.grey.shade300,
                ),
                SizedBox(height: 2.h),
                AppButtonWidget(
                  onPressed: (){
                    Get.toNamed(RoutesName.AddAttachmentScreen);
                  },
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  text: "next".tr,
                  width: 94.w,
                  height: 6.h,
                  buttonColor: Color(0xffC22522),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _showStatusDropdown(BuildContext context) {
    final List<String> statusList = [ "active".tr,
      "completed".tr,
      "paused".tr];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: statusList.length,
          itemBuilder: (context, index) {
            final value = statusList[index];

            return ListTile(
              title: Text(value),
              onTap: () {
                controller.selectedStatus.text = value; // set selected
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

}
