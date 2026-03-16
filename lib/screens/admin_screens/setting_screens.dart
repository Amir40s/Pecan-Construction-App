import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/config/routes/routes_name.dart';
import 'package:pecan_construction/core/constant/app_icons.dart';
import 'package:pecan_construction/core/widgets/app_buttons.dart';
import 'package:pecan_construction/core/widgets/header_widget.dart';
import 'package:sizer/sizer.dart';
import '../../core/localizations/locale_controller.dart';
import '../../core/widgets/app_text.dart';
import '../employ_screens/controllers/notification_setting_controller.dart'; // <-- your AppText

class SettingsScreen extends StatelessWidget {
   SettingsScreen({super.key});

  final notificationController = Get.put(NotificationSettingController());

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF6F7FB);

   bool isNotification = false;
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
                    ),                      Spacer(),
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
                  Get.toNamed(RoutesName.PrivacyPolicyScreen);
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
                  Get.toNamed(RoutesName.TermsConditionsScreen);
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

              const Gap(22),

              // Logout button
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
              AppButtonWidget(
                prefixIcon: Icon(Icons.logout,color: Colors.white,),
                  onPressed: (){
                  Get.offAllNamed(RoutesName.splash);
                  },
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  width: 95.w,
                  height: 6.h,
                  buttonColor: Color(0xffC22522),
                text: "logout".tr,),
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

/* -------------------- Pieces -------------------- */

class _SectionCard extends StatelessWidget {
  final Widget child;
  final Color card;
  final Color border;

  const _SectionCard({
    required this.child,
    required this.card,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: child,
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final Widget leading;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsRow({
    required this.leading,
    required this.title,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = const Color(0xFF111827);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            leading,
            const Gap(12),
            Expanded(
              child: AppText(
                title,
                color: textPrimary,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  final Color border;
  const _DividerLine({required this.border});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(left: 56), // aligns after icon
      color: border,
    );
  }
}

class _SquareIcon extends StatelessWidget {
  final Widget child;
  final Color bg;

  const _SquareIcon({required this.child, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: child),
    );
  }
}

class _IconButtonGlass extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _IconButtonGlass({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Center(child: child),
      ),
    );
  }
}
