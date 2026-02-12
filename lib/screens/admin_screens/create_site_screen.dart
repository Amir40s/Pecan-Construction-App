import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/config/routes/routes_name.dart';
import 'package:pecan_construction/core/widgets/app_buttons.dart';
import 'package:pecan_construction/core/widgets/app_text.dart';
import 'package:pecan_construction/core/widgets/header_widget.dart';
import 'package:pecan_construction/screens/admin_screens/admin_controller/create_site_controller.dart';
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
                CustomHeader(title: "Create New Site", showBack: true),
                SizedBox(height: 1.h),
                AppText(
                  "Add Site Photo",
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                SizedBox(height: 1.h),
                Container(
                  width: 95.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: BoxBorder.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 7.h),
                      Icon(
                        Icons.camera_alt_rounded,
                        size: 90,
                        color: Colors.grey.shade300,
                      ),
                      AppText(
                        "Drag and Drop or Tap to Upload a Photo",
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                AppText(
                  "Site Name",
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
                SizedBox(height: 1.h),
                AppFormField(
                  title: "site name",
                  textEditingController: controller.siteNameC,
                  showBorder: true,
                  borderColor: Colors.grey.shade300,
                ),
                SizedBox(height: 2.h),
                AppText(
                  "Address",
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
                SizedBox(height: 1.h),
                AppFormField(
                  iconWidget: SvgPicture.asset(AppIcons.pointLocationIcon),
                  title: "site address",
                  textEditingController: controller.siteAddressC,
                  showBorder: true,
                  borderColor: Colors.grey.shade300,
                ),
                SizedBox(height: 2.h),
                AppText(
                  "Start Date",
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
                SizedBox(height: 1.h),
                AppFormField(
                  iconWidget: SvgPicture.asset(AppIcons.calenderIcon),
                  textEditingController: controller.siteDateC,
                  title: "start date",
                  showBorder: true,
                  borderColor: Colors.grey.shade300,
                ),
                SizedBox(height: 2.h),

                AppText(
                  "Status",
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
                SizedBox(height: 1.h),
                AppFormField(
                  readOnly: true,
                  icon: Icons.arrow_drop_down,
                  textEditingController: controller.siteStatus,
                  title: "Active",
                  showBorder: true,
                  borderColor: Colors.grey.shade300,

                  onTap: () {
                    _showStatusDropdown(context);
                  },
                ),

                SizedBox(height: 2.h),

                AppText(
                  "Add Note",
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
                SizedBox(height: 1.h),
                Container(
                  width: 95.w,
                  height: 20.h,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: BoxBorder.all(color: Colors.grey.shade300),
                  ),
                  child: Text("Add a note"),
                ),
                SizedBox(height: 2.h),
                AppButtonWidget(
                  onPressed: (){
                    Get.toNamed(RoutesName.AssignEmployeeScreen);
                  },
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  text: "Next",
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
    final List<String> statusList = ["Active", "Completed", "Pause"];

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
                controller.siteStatus.text = value; // set selected
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

}
