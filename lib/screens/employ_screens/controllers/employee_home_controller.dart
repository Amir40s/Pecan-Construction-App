import 'dart:ui';

import 'package:get/get.dart';
import 'package:pecan_construction/config/routes/routes_name.dart';
import 'package:pecan_construction/core/constant/app_images.dart';

enum CalendarViewMode { day, week, month }

class EmployeeSiteItem {
  final String id;
  final String title;
  final String subtitle; // "Site #420 . Interior Finishing"
  final String buttonText; // "Check in" / "Resume"
  final String imageAsset; // thumbnail asset
  final VoidCallback onpressed;
  const EmployeeSiteItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.imageAsset,
    required this.onpressed,
  });
}

class EmployeeHomeController extends GetxController {
  // Header
  final RxString welcomeText = "Welcome".obs;
  final RxString adminName = "Mr Henry".obs; // (your UI uses adminName)
  final RxString profileImage = "assets/images/profile.png".obs; // change asset

  // Calendar
  final Rx<CalendarViewMode> viewMode = CalendarViewMode.month.obs;

  final RxInt selectedYear = 2026.obs;
  final RxInt selectedMonth = 1.obs; // 1..12
  final RxInt selectedDay = 13.obs;

  void setViewMode(CalendarViewMode mode) => viewMode.value = mode;

  void nextMonth() {
    if (selectedMonth.value == 12) {
      selectedMonth.value = 1;
      selectedYear.value += 1;
    } else {
      selectedMonth.value += 1;
    }
  }

  void prevMonth() {
    if (selectedMonth.value == 1) {
      selectedMonth.value = 12;
      selectedYear.value -= 1;
    } else {
      selectedMonth.value -= 1;
    }
  }

  void pickDay(int day) => selectedDay.value = day;

  // Sites list (your UI uses c.sites)
  final RxList<EmployeeSiteItem> sites = <EmployeeSiteItem>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Dummy data like screenshot
    sites.assignAll( [
      EmployeeSiteItem(
        id: "1",
        title: "Downtown Plaza Renovation",
        subtitle: "Site #420 . Interior Finishing",
        buttonText: "Check in",
        imageAsset: AppImages.SiteAttichmentPic2,
        onpressed: (){
          Get.toNamed(RoutesName.EmployeeSiteDetailsScreen);
        }
      ),
      EmployeeSiteItem(
        id: "2",
        title: "Oakewood Residential Complex",
        subtitle: "Site #118 . Foundation Phase",
        buttonText: "Resume",
        imageAsset: AppImages.SiteAttichmentPic,
          onpressed: (){
            Get.toNamed(RoutesName.EmployeeSiteDetailsScreen);
          }
      ),
    ]);
  }
}
