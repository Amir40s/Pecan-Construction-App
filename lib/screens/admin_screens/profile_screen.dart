import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/config/routes/routes_name.dart';
import 'package:pecan_construction/core/constant/app_icons.dart';
import 'package:pecan_construction/core/constant/app_images.dart';
import 'package:pecan_construction/core/widgets/app_buttons.dart';
import 'package:pecan_construction/core/widgets/app_text.dart';
import 'package:sizer/sizer.dart';
import '../../core/widgets/appnetworkImage.dart';
import '../employ_screens/controllers/adminLogincontroller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AdminLoginController controller = Get.put(AdminLoginController());


  InputDecoration customDecoration({
    required String hint,
    required Widget prefixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(14),
        child: prefixIcon,
      ),
      prefixIconConstraints: const BoxConstraints(
        minWidth: 24,
        minHeight: 24,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xffDC9291)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xffDC9291)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xffDC9291), width: 1.4),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isProfileLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final isEnabled = controller.hasProfileChanges.value &&
              !controller.isSavingProfile.value;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      AppText(
                        "profile".tr,
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Get.toNamed(RoutesName.SettingsScreen);
                        },
                        icon: const Icon(Icons.settings, color: Colors.black87, size: 35),
                      )
                    ],
                  ),
                  SizedBox(height: 3.h),

                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GestureDetector(
                        onTap: controller.pickProfileImage,
                        child: Obx(() {
                          final selectedImage = controller.selectedProfileImage.value;

                          if (selectedImage != null) {
                            return Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xffDC9291),
                                  width: 2,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.file(
                                selectedImage,
                                fit: BoxFit.cover,
                              ),
                            );
                          }

                          return AppNetworkImage(
                            url: controller.adminProfileImage.value,
                            width: 110,
                            height: 110,
                            isCircle: true,
                            fit: BoxFit.cover,
                            placeholderAsset: AppImages.profileImage,
                            borderWidth: 2,
                            borderColor: const Color(0xffDC9291),
                          );
                        }),
                      ),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: GestureDetector(
                          onTap: controller.pickProfileImage,
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemGrey6,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              CupertinoIcons.camera_fill,
                              size: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.h),

                  AppText(
                    controller.adminName.value.isEmpty
                        ? "admin".tr
                        : controller.adminName.value,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),

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

                        TextFormField(
                          controller: controller.profileNameC,
                          decoration: customDecoration(
                            hint:  "enter_full_name".tr,
                            prefixIcon: SvgPicture.asset(AppIcons.personIcon),
                          ),
                        ),

                        SizedBox(height: 3.h),

                        AppText(
                          "email_address".tr,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                        SizedBox(height: 1.h),

                        TextFormField(
                          controller: controller.profileEmailC,
                          readOnly: true,
                          decoration: customDecoration(
                            hint:  "email_hint".tr,
                            prefixIcon: SvgPicture.asset(AppIcons.emailIcon),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),
                  Obx(() {
                    final isEnabled = controller.hasProfileChanges.value &&
                        !controller.isSavingProfile.value;

                    return AppButtonWidget(
                      onPressed: () {
                        if (isEnabled) {
                          controller.saveProfileChanges();
                        }
                      },
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      width: 90.w,
                      height: 8.h,
                      buttonColor: isEnabled
                          ? const Color(0xffC22522)
                          : const Color(0xffC22522).withOpacity(0.5),
                      text: controller.isSavingProfile.value
                          ? "saving".tr
                          : "save_changes".tr,
                    );
                  }),

                  SizedBox(height: 1.h),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}