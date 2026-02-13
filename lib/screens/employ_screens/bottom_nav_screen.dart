import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../core/constant/app_icons.dart';
import 'controllers/bottom_nav_bar_controller.dart';
import 'employ_home_screens.dart';
import 'employe_notification_screen.dart';
import 'employee_profile_screens.dart';
import 'employee_site_screen.dart';
class EmployeeBottomNavScreen extends GetView<EmployeeBottomNavController> {
  const EmployeeBottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      EmployHomeScreens(),
      EmployeeSitesScreen(),
      EmployeNotificationScreen(),
      EmployeeProfileScreens(),
    ];

    return Obx(() {
      final index = controller.currentIndex.value;

      return Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: IndexedStack(
          index: index,
          children: screens,
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Color(0xffFFFFFF),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: index,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xffC22522),
            unselectedItemColor: const Color(0xffDC9291),
            onTap: controller.changeIndex,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppIcons.homeIcon,
                  colorFilter: ColorFilter.mode(
                    index == 0 ? const Color(0xffC22522) : const Color(0xffDC9291),
                    BlendMode.srcIn,
                  ),
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppIcons.siteIcon,
                  colorFilter: ColorFilter.mode(
                    index == 1 ? const Color(0xffC22522) : const Color(0xffDC9291),
                    BlendMode.srcIn,
                  ),
                ),
                label: "Sites",
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppIcons.bellIcon,
                  colorFilter: ColorFilter.mode(
                    index == 2 ? const Color(0xffC22522) : const Color(0xffDC9291),
                    BlendMode.srcIn,
                  ),
                ),
                label: "Notification",
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppIcons.socialIcon,
                  colorFilter: ColorFilter.mode(
                    index == 3 ? const Color(0xffC22522) : const Color(0xffDC9291),
                    BlendMode.srcIn,
                  ),
                ),
                label: "Profile",
              ),
            ],
          ),
        ),
      );
    });
  }
}
