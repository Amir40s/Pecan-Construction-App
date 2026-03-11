import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/screens/admin_screens/profile_screen.dart';
import 'package:pecan_construction/screens/admin_screens/site_screen.dart';
import '../../core/constant/app_icons.dart';
import 'admin_controller/admin_home_controller.dart';
import 'admin_controller/bottom_nav_controller.dart';
import 'admin_home_screen.dart';
import 'notification_screen.dart';

class BottomNavScreen extends StatelessWidget {
  BottomNavScreen({super.key});

  final BottomNavController controller = Get.put(BottomNavController());
  final homeC = Get.put(AdminHomeController(), permanent: true);

  final List<Widget> screenList = [
    AdminHomeScreen(),
    SiteScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: screenList[controller.currentIndex.value],

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
          backgroundColor: Colors.white, // change here
          currentIndex: controller.currentIndex.value,
          showUnselectedLabels: true,
          selectedItemColor: const Color(0xffC22522),
          unselectedItemColor: const Color(0xffDC9291),
          onTap: controller.changeIndex,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppIcons.homeIcon,
                color: controller.currentIndex.value == 0
                    ? const Color(0xffC22522)
                    : const Color(0xffDC9291),
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppIcons.siteIcon,
                color: controller.currentIndex.value == 1
                    ? const Color(0xffC22522)
                    : const Color(0xffDC9291),
              ),
              label: "Sites",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppIcons.socialIcon,
                color: controller.currentIndex.value == 3
                    ? const Color(0xffC22522)
                    : const Color(0xffDC9291),
              ),
              label: "Profile",
            ),
          ],
        ),
      ),

    ));
  }
}
