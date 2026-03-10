import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/core/models/site_model.dart';
import 'package:pecan_construction/core/repo/site_repository.dart';

import '../../../config/routes/routes_name.dart';

enum SiteStatus { active, completed }

class SiteItem {
  final String id;
  final String title;
  final String subtitle; // "Site #420 . Interior Finishing"
  final String progressLabel; // "In Progress" / "Completed"
  final SiteStatus status;
  final String actionText; // "Visit Site" / "Check in" / "View History"
  final String imageAssetOrUrl;
  final bool isNetworkImage;

  const SiteItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.progressLabel,
    required this.status,
    required this.actionText,
    required this.imageAssetOrUrl,
    this.isNetworkImage = false,
  });
}

class EmployeeSitesController extends GetxController {
  SitesRepository repository = SitesRepository();
  // Tabs: 0=All, 1=Active, 2=Completed
  final RxInt tabIndex = 0.obs;

  // Search
  final RxBool isSearching = false.obs;
  final TextEditingController searchC = TextEditingController();
  final RxString searchQuery = "".obs;

  final RxList<SitesModel> allSites = <SitesModel>[].obs;
  final isLoading = false.obs;
  StreamSubscription? _sitesSub;

  @override
  void onInit() {
    super.onInit();
    listenSites();
    searchC.addListener(() {
      searchQuery.value = searchC.text;
    });
  }

  @override
  void onClose() {
    _sitesSub?.cancel();
    searchC.dispose();
    super.onClose();
  }

  void changeTab(int index) => tabIndex.value = index;

  void listenSites() {

    isLoading.value = true;

    _sitesSub = repository.fetchAllSitesRealtime()
        .listen((event) {
      event.fold(
            (failure) {
          isLoading.value = false;
          Get.snackbar("Error", failure.message);
        },
            (sites) {
          allSites.assignAll(sites);
          isLoading.value = false;
        },
      );
    });
  }

  List<SitesModel> get filtered {

    final q = searchQuery.value.trim().toLowerCase();

    List<SitesModel> base;

    /// TAB FILTER
    if (tabIndex.value == 1) {

      /// Active sites
      base = allSites
          .where((e) => e.siteStatus.toLowerCase() == "active")
          .toList();

    } else if (tabIndex.value == 2) {

      /// Completed sites
      base = allSites
          .where((e) => e.siteStatus.toLowerCase() == "completed")
          .toList();

    } else {

      /// All sites
      base = allSites.toList();
    }

    /// SEARCH FILTER
    if (q.isEmpty) return base;

    return base.where((e) {

      return e.siteName.toLowerCase().contains(q) ||
          e.siteAddress.toLowerCase().contains(q);

    }).toList();
  }


  // Actions (wire with routes)
  void onTapSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchC.clear();
      searchQuery.value = "";
    }
  }

  void openSite(SitesModel site) {
    Get.toNamed(RoutesName.EmployeeSiteDetailsScreen, arguments: {"siteId": site.siteId});
  }

  void onTapAction(SitesModel site) {
    // if (site.actionText == "Check in") ...
  }


}
