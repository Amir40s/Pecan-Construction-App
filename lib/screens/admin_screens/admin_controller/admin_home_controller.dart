import 'dart:async';
import 'package:get/get.dart';
import 'package:pecan_construction/core/constant/app_images.dart';
import 'package:pecan_construction/core/repo/site_repository.dart';
import '../../../core/models/site_model.dart';
import '../../../core/widgets/failure.dart';

enum SiteTab { all, active, completed }

class AdminHomeController extends GetxController {
  final SitesRepository repository = SitesRepository();

  final selectedSiteTab = SiteTab.all.obs;
  final isLoadingSites = false.obs;

  final adminName = "Admin".obs;
  final welcomeText = "Welcome".obs;
  final profileImage = AppImages.profileImage.obs;

  final sites = <SitesModel>[].obs;
  StreamSubscription? _sitesSubscription;

  void changeSiteTab(SiteTab tab) {
    selectedSiteTab.value = tab;
  }

  int get totalSitesCount => sites.length;

  int get activeSitesCount => sites
      .where((s) => s.siteStatus.trim().toLowerCase() == "active")
      .length;

  int get completedSitesCount => sites
      .where((s) => s.siteStatus.trim().toLowerCase() == "completed")
      .length;

  List<SitesModel> get activeSitesList => sites
      .where((s) => s.siteStatus.trim().toLowerCase() == "active")
      .toList();

  List<SitesModel> get filteredSites {
    final tab = selectedSiteTab.value;

    switch (tab) {
      case SiteTab.all:
        return sites;

      case SiteTab.active:
        return sites
            .where((s) => s.siteStatus.trim().toLowerCase() == "active")
            .toList();

      case SiteTab.completed:
        return sites
            .where((s) => s.siteStatus.trim().toLowerCase() == "completed")
            .toList();
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchSitesRealtime();
  }

  void fetchSitesRealtime() {
    isLoadingSites.value = true;

    _sitesSubscription?.cancel();
    _sitesSubscription = repository.fetchAllSitesRealtime().listen((result) {
      result.fold(
            (Failure failure) {
          isLoadingSites.value = false;
          Get.snackbar("Error", failure.message);
        },
            (List<SitesModel> fetchedSites) {
          sites.assignAll(fetchedSites);
          isLoadingSites.value = false;
        },
      );
    });
  }

  @override
  void onClose() {
    _sitesSubscription?.cancel();
    super.onClose();
  }
}