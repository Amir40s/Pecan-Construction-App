import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/config/routes/routes_name.dart';
import 'package:pecan_construction/core/constant/app_icons.dart';
import 'package:pecan_construction/core/widgets/app_buttons.dart';
import 'package:pecan_construction/core/widgets/header_widget.dart';
import 'package:pecan_construction/screens/auth_screens/controllers/signup_controller.dart';
import 'package:sizer/sizer.dart';
import '../../core/localizations/locale_controller.dart';
import '../../core/widgets/app_text.dart';
import 'controllers/notification_setting_controller.dart'; // <-- your AppText

class EmployeeSettingScreen extends StatelessWidget {
   EmployeeSettingScreen({super.key});
 final c = Get.find<SignUpController>();
   final notificationController = Get.put(NotificationSettingController());
  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF6F7FB);



    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              CustomHeader(
                title: "settings".tr,
                showBack: true,
              ),
              const Gap(18),

              // App Setting title
              AppText(
                "app_settings".tr,
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              const Gap(10),
              Container(
                width: 95.w,
                height: 7.h,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: BoxBorder.all(color: Colors.grey.shade300)
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(AppIcons.bellIcon),
                    Gap(3.w),
                    AppText(
                      "notifications".tr,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),                    Spacer(),
                    Obx(() => Switch(
                      value: notificationController.isNotificationEnabled.value,
                      onChanged: notificationController.toggleNotification,
                      thumbColor: MaterialStateProperty.all(Colors.white),
                      activeTrackColor: Colors.red,
                      inactiveTrackColor: Colors.red.withOpacity(0.35),
                      trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
                    ))

                  ],
                ),
              ),
              const Gap(10),
              GestureDetector(
                onTap: () {
                  showLanguageDialog(context);
                },
                child: Container(
                  width: 95.w,
                  height: 7.h,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(AppIcons.languageIcon),
                      Gap(3.w),
                      AppText(
                        "language".tr,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          AppText(
                            Get.locale?.languageCode == "de"
                                ? "german".tr
                                : "english".tr,
                            color: Colors.grey.shade600,
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded),
                        ],
                      )
                    ],
                  ),
                ),
              ),

              const Gap(16),

              // Support title
              AppText(
                "support".tr,
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              const Gap(10),
              GestureDetector(
                onTap: (){
                  Get.toNamed(RoutesName.ContactAdminScreen);
                },
                child: Container(
                  width: 95.w,
                  height: 7.h,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: BoxBorder.all(color: Colors.grey.shade300)
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(AppIcons.messageIcon),
                      Gap(3.w),
                      AppText(
                        "contact_admin".tr,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),                      Spacer(),
                      Icon(Icons.arrow_forward_ios_rounded)
                    ],
                  ),
                ),
              ),

              const Gap(16),

              // Legal title
              AppText(
                "legal".tr,
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              const Gap(10),
              GestureDetector(
                onTap: (){
                  notificationController.openPrivacyPolicy();
                },
                child: Container(
                  width: 95.w,
                  height: 7.h,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: BoxBorder.all(color: Colors.grey.shade300)
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(AppIcons.privacyIcon),
                      Gap(3.w),
                      AppText(
                        "privacy_policy".tr,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),                      Spacer(),
                      Icon(Icons.arrow_forward_ios_rounded)
                    ],
                  ),
                ),
              ),
              Gap(12),
              GestureDetector(
                onTap: (){
                  notificationController.openTermsAndConditions();
                },
                child: Container(
                  width: 95.w,
                  height: 7.h,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: BoxBorder.all(color: Colors.grey.shade300)
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(AppIcons.termCondtionIcon),
                      Gap(3.w),
                      AppText(
                        "terms_conditions".tr,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),                      Spacer(),
                      Icon(Icons.arrow_forward_ios_rounded)
                    ],
                  ),
                ),
              ),
              Gap(12),
              GestureDetector(
                onTap: (){
                  notificationController.openeula();
                },
                child: Container(
                  width: 95.w,
                  height: 7.h,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: BoxBorder.all(color: Colors.grey.shade300)
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(AppIcons.termCondtionIcon),
                      Gap(3.w),
                      AppText(
                        "end_user_license_agreement".tr,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),                      Spacer(),
                      Icon(Icons.arrow_forward_ios_rounded)
                    ],
                  ),
                ),
              ),
              const Gap(22),

              Obx( () {
                return AppButtonWidget(
                  prefixIcon: Icon(Icons.delete,color: Colors.white,),
                  onPressed: (){
                    notificationController.deleteAccount();
                  },
                  fontSize: 18,
                  loader: notificationController.isLogging.value,

                  fontWeight: FontWeight.w600,
                  width: 95.w,
                  height: 6.h,
                  buttonColor: Color(0xffC22522),
                  text: "Delete Account".tr,);
              }
              ),
              const Gap(22),

              // Logout button
              Obx((){
                return AppButtonWidget(
                    prefixIcon: Icon(Icons.logout,color: Colors.white,),
                    onPressed: c.isLogginOut.value ? null :  (){
                      c.LogoutEmployee();
                    },
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    width: 95.w,
                    loader: c.isLogginOut.value,
                    height: 6.h,
                    buttonColor: Color(0xffC22522),
                  text: "logout".tr,
                );
              }
              ),
            ],
          ),
        ),
      ),
    );


  }
   void showLanguageDialog(BuildContext context) {
     final localeController = Get.find<LocaleController>();

     Get.bottomSheet(
       Container(
         decoration: const BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
         ),
         padding: const EdgeInsets.symmetric(vertical: 20),
         child: Column(
           mainAxisSize: MainAxisSize.min,
           children: [

             /// Title
             AppText(
               "select_language".tr,
               fontSize: 18,
               fontWeight: FontWeight.w800,
             ),

             const SizedBox(height: 16),

             /// English
             ListTile(
               leading: const Icon(Icons.language),
               title: AppText("english".tr),
               trailing: Get.locale?.languageCode == "en"
                   ? const Icon(Icons.check, color: Colors.red)
                   : null,
               onTap: () {
                 localeController.changeLanguage("en");
                 Get.back();
               },
             ),

             /// German
             ListTile(
               leading: const Icon(Icons.language),
               title: AppText("german".tr),
               trailing: Get.locale?.languageCode == "de"
                   ? const Icon(Icons.check, color: Colors.red)
                   : null,
               onTap: () {
                 localeController.changeLanguage("de");
                 Get.back();
               },
             ),

             const SizedBox(height: 10),

             /// Cancel
             TextButton(
               onPressed: () => Get.back(),
               child: AppText(
                 "cancel".tr,
                 color: Colors.red,
                 fontWeight: FontWeight.w700,
               ),
             )
           ],
         ),
       ),
     );
   }
}


