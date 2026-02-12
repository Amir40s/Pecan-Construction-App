import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:pecan_construction/core/constant/app_icons.dart';
import 'package:pecan_construction/core/widgets/app_buttons.dart';
import 'package:pecan_construction/core/widgets/header_widget.dart';
import 'package:sizer/sizer.dart';
import '../../core/widgets/app_text.dart'; // <-- your AppText

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF6F7FB);
    final card = Colors.white;
    final border = const Color(0xFFE5E7EB);
    final textPrimary = const Color(0xFF111827);
    final textSecondary = const Color(0xFF6B7280);
    final red = const Color(0xFFB91C1C);
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
           CustomHeader(title: "Setting", showBack: true,),

              const Gap(18),

              // App Setting title
              AppText(
                "App Setting",
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
                    AppText("Notifications",color: Colors.black87,fontWeight: FontWeight.bold,),
                    Spacer(),
                    Switch(
                      value: isNotification,
                      onChanged: (value) {
                        isNotification = value;
                      },
                      thumbColor: MaterialStateProperty.all(Colors.white), // thumb white
                      activeTrackColor: Colors.red, // active track red
                      inactiveTrackColor: Colors.red.withOpacity(0.35), // inactive slightly red
                      trackOutlineColor: MaterialStateProperty.all(Colors.transparent), // remove border (Flutter 3.13+)
                    ),

                  ],
                ),
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
                    SvgPicture.asset(AppIcons.languageIcon),
                    Gap(3.w),
                    AppText("Language",  color: Colors.black87,fontWeight: FontWeight.bold,),
                    Spacer(),
                    Row(
                      children: [
                        AppText("English", color: Colors.grey.shade600,),
                        Icon(Icons.arrow_forward_ios_rounded)
                      ],
                    )

                  ],
                ),
              ),

              const Gap(16),

              // Support title
              AppText(
                "Support",
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
                    SvgPicture.asset(AppIcons.messageIcon),
                    Gap(3.w),
                    AppText("Contact Admin",  color: Colors.black87,fontWeight: FontWeight.bold,),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios_rounded)
                  ],
                ),
              ),

              const Gap(16),

              // Legal title
              AppText(
                "Legal",
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
                    SvgPicture.asset(AppIcons.privacyIcon),
                    Gap(3.w),
                    AppText("Privacy Policy",  color: Colors.black87,fontWeight: FontWeight.bold,),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios_rounded)
                  ],
                ),
              ),
              Gap(12),
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
                    SvgPicture.asset(AppIcons.termCondtionIcon),
                    Gap(3.w),
                    AppText("Terms and Condition",  color: Colors.black87,fontWeight: FontWeight.bold,),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios_rounded)
                  ],
                ),
              ),

              const Gap(22),

              // Logout button
              AppButtonWidget(
                prefixIcon: Icon(Icons.logout,color: Colors.white,),
                  onPressed: (){
                  },
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  width: 95.w,
                  height: 6.h,
                  buttonColor: Color(0xffC22522),
                  text: "Log Out"),
            ],
          ),
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
