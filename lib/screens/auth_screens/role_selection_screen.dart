import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:pecan_construction/core/constant/app_icons.dart';
import 'package:pecan_construction/core/constant/app_images.dart';
import 'package:sizer/sizer.dart';

import '../../core/widgets/app_text.dart';
import 'controllers/role_controllers.dart';

class RoleSelectionScreen extends GetView<RoleSelectionController> {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF6F7FB);
    final primary = const Color(0xFF111827);
    final secondary = const Color(0xFF6B7280);
    final border = const Color(0xFFE5E7EB);
    final accent = const Color(0xFFDC2626); // red

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
          child: Column(
            children: [
              //
              AppText(
                "Choose your role",
                color: primary,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              Gap(18.h),
              SizedBox(
                width: 80.w,
                height: 10.h,
                child: Image.asset(AppImages.logoImage, fit: BoxFit.contain,),
              ),
              Gap(10.h),
              AppText(
                "Select one option to continue",
                color: secondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              Gap(1.h),
              Obx(() {
                final selected = controller.selectedRole.value;

                return Column(
                  children: [
                    _RoleCard(
                      title: "Admin",
                      subtitle: "Manage sites, staff & approvals",
                      icon: Icons.admin_panel_settings_rounded,
                      isSelected: selected == AppRoleType.admin,
                      accent: accent,
                      border: border,
                      onTap: () => controller.selectRole(AppRoleType.admin),
                    ),
                    const Gap(12),
                    _RoleCard(
                      title: "Employee",
                      subtitle: "View tasks, updates & notifications",
                      icon: Icons.badge_rounded,
                      isSelected: selected == AppRoleType.employee,
                      accent: accent,
                      border: border,
                      onTap: () => controller.selectRole(AppRoleType.employee),
                    ),
                  ],
                );
              }),

             Gap(5.h),

              // Continue button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: Obx(() {
                  final canContinue = controller.selectedRole.value != null;
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canContinue ? accent : accent.withOpacity(0.45),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: canContinue ? controller.continueNext : null,
                    child: AppText(
                      "Continue",
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final Color accent;
  final Color border;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.accent,
    required this.border,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF111827);
    final secondary = const Color(0xFF6B7280);

    final bgColor = isSelected ? accent.withOpacity(0.08) : Colors.white;
    final brColor = isSelected ? accent : border;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: brColor, width: isSelected ? 1.4 : 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? accent : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : const Color(0xFF111827),
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title,
                    color: primary,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                  ),
                  const Gap(4),
                  AppText(
                    subtitle,
                    color: secondary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
            const Gap(10),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? accent : const Color(0xFFD1D5DB),
                  width: 2,
                ),
                color: isSelected ? accent : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
