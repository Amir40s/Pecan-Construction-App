import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/models/site_model.dart';
import '../../../core/repo/site_repository.dart';
import 'package:get_storage/get_storage.dart';


enum CalendarViewMode { day, week, month }

class EmployeeHomeController extends GetxController {
  SitesRepository repository = SitesRepository();
  RxString welcomeText = "Welcome".obs;
  // final RxString adminName = "Mr Henry".obs;
  final RxString profileImage = "assets/images/profile.png".obs;
  final Rx<CalendarViewMode> viewMode = CalendarViewMode.month.obs;

  void setViewMode(CalendarViewMode mode) => viewMode.value = mode;
  final isLoading = true.obs;
  final errorText = ''.obs;
  final sites = <SitesModel>[].obs;
  StreamSubscription<List<SitesModel>>? _sub;

  final now = DateTime.now();
  final box = GetStorage();
  late final RxInt selectedYear = now.year.obs;
  late final RxInt selectedMonth = now.month.obs;
  late final RxInt selectedDay = now.day.obs;
  final RxInt refreshTrigger = 0.obs;
  void pickDay(int day) => selectedDay.value = day;


  bool isSiteViewed(String siteId) {
    return box.read("viewed_$siteId") ?? false;
  }

  void markSiteViewed(String siteId) {
    box.write("viewed_$siteId", true);
    refreshTrigger.value++; // UI rebuild trigger

  }

  String? getSiteStatusForDay(int day) {
    String? status;

    for (var site in sites) {
      final siteDate = DateTime.tryParse(site.siteStartDate ?? "");
      if (siteDate == null) continue;

      if (siteDate.year == selectedYear.value &&
          siteDate.month == selectedMonth.value &&
          siteDate.day == day) {

        final s = site.siteStatus.toLowerCase();

        // Priority logic
        if (s == "active") return "active";
        if (s == "paused") status = "paused";
        if (s == "completed") status ??= "completed";
      }
    }

    return status;
  }
  String get selectedDateString {
    final y = selectedYear.value;
    final m = selectedMonth.value.toString().padLeft(2, '0');
    final d = selectedDay.value.toString().padLeft(2, '0');

    return "$y-$m-$d";
  }

  List<String> getSiteStatusesForDay(int day) {

    List<String> statuses = [];

    for (var site in sites) {

      final siteDate = DateTime.tryParse(site.siteStartDate ?? "");
      if (siteDate == null) continue;

      if (siteDate.year == selectedYear.value &&
          siteDate.month == selectedMonth.value &&
          siteDate.day == day) {

        statuses.add(site.siteStatus.toLowerCase());
      }
    }

    return statuses;
  }

  Color getStatusColor(String status) {

    switch (status) {
      case "active":
        return Colors.redAccent;

      case "paused":
        return Colors.orange;

      case "completed":
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  void setMonth(int month) {
    selectedMonth.value = month;
  }

  List<SitesModel> get filteredSites {
    return sites.where((site) {
      final siteDate = DateTime.tryParse(site.siteStartDate ?? "");
      final selectedDate = DateTime.tryParse(selectedDateString);

      if (siteDate == null || selectedDate == null) return false;

      return siteDate.year == selectedDate.year &&
          siteDate.month == selectedDate.month &&
          siteDate.day == selectedDate.day;
    }).toList();
  }
  @override
  void onInit() {
    super.onInit();
    watchMySites();
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

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


  Future<void> watchMySites() async {
    isLoading.value = true;
    errorText.value = '';
    final res = await repository.watchMyAssignedSites();
    res.match(
          (l) {
        isLoading.value = false;
        errorText.value = l.message;
      },
          (stream) {
        _sub?.cancel();
        _sub = stream.listen(
              (list) {
            sites.assignAll(list);
            isLoading.value = false;
          },
          onError: (e) {
            isLoading.value = false;
            errorText.value = e.toString();
          },
        );
      },
    );
}


}
