import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pecan_construction/config/routes/routes_name.dart';
import 'package:pecan_construction/core/constant/app_images.dart';
import 'package:pecan_construction/core/widgets/app_text.dart';
import 'package:pecan_construction/screens/auth_screens/controllers/signup_controller.dart';
import 'package:sizer/sizer.dart';
import '../../core/constant/app_icons.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/appnetworkImage.dart';

class EmployeeProfileScreens extends GetView<SignUpController> {
  EmployeeProfileScreens({super.key});

  final _uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    //  load profile once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_uid != null) {
        controller.loadEmployeeProfile(uid: _uid);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(width: 40.w),
                    AppText(
                      "profile".tr,
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Get.toNamed(RoutesName.EmployeeSettingScreen);
                      },
                      icon: const Icon(Icons.settings,
                          color: Colors.black87, size: 35),
                    )
                  ],
                ),
                SizedBox(height: 3.h),

                // ✅ Avatar
                Obx(() {
                  return Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: controller.pickedBytes.value != null
                            ? MemoryImage(controller.pickedBytes.value!)
                            : (controller.avatarUrl.value.isNotEmpty
                            ? NetworkImage(controller.avatarUrl.value)
                            :  AssetImage(AppImages.profileImage)) as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: GestureDetector(
                          onTap: controller.pickProfileImage,
                          child: Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF0A84FF),
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),

                SizedBox(height: 1.h),

                // Name Title (live)
                Obx(() => AppText(
                  controller.employeeName.value.isNotEmpty
                      ? controller.employeeName.value
                      : controller.nameC.text,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                )),

                SizedBox(height: 3.h),
                Divider(color: Colors.grey.shade200),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3.h),

                      AppText(
                        "full_name".tr,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                      SizedBox(height: 1.h),

                      AppFormField(
                        preficIconwidth: 10,
                        prefixIconheight: 10,
                        prefic_icons: SvgPicture.asset(AppIcons.personIcon),
                        showPretixIcon: true,
                        title: "full_name_hint".tr,
                        textEditingController: controller.nameC,
                        showBorder: true,
                        borderColor: const Color(0xffDC9291),
                      ),

                      SizedBox(height: 3.h),

                      AppText(
                        "email_address".tr,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                      SizedBox(height: 1.h),

                      AppFormField(
                        readOnly: true,
                        preficIconwidth: 10,
                        prefixIconheight: 10,
                        prefic_icons: SvgPicture.asset(AppIcons.emailIcon),
                        showPretixIcon: true,
                        title: "email".tr,
                        textEditingController: controller.emailC,
                        showBorder: true,
                        borderColor: const Color(0xffDC9291),
                      ),

                      SizedBox(height: 3.h),
                    ],
                  ),
                ),

                SizedBox(height: 4.h),

                //  Save button wired with update method
                Obx(() {

                  // force rebuild when these change
                  controller.currentName.value;
                  controller.pickedBytes.value;

                  final loading =
                      controller.isLoading.value || controller.isUploading.value;

                  final canSave = controller.hasChanges && !loading;

                  return AppButtonWidget(
                    onPressed: canSave
                        ? () async {

                      if (_uid == null) {
                        Get.snackbar("error".tr, "user_not_logged_in".tr);
                        return;
                      }

                      await controller.updateEmployeeProfile(uid: _uid);
                      await controller.loadEmployeeProfile(uid: _uid);
                    }
                        : null,

                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    width: 90.w,
                    height: 8.h,
                    buttonColor:
                    canSave ? const Color(0xffC22522) : Colors.grey.shade400,

                    text: loading ? "saving".tr : "save_changes".tr,
                  );
                }),

                SizedBox(height: 1.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}