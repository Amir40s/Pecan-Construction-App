import 'package:get/get.dart';
import 'package:pecan_construction/core/constant/app_images.dart';

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
  // Tabs: 0=All, 1=Active, 2=Completed
  final RxInt tabIndex = 0.obs;

  // Optional search (abhi UI icon only)
  final RxString searchQuery = "".obs;

  final RxList<SiteItem> allSites = <SiteItem>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Dummy data (screenshot-style)
    allSites.assignAll( [
      SiteItem(
        id: "1",
        title: "Downtown Plaza Renovation",
        subtitle: "Site #420 . Interior Finishing",
        progressLabel: "In Progress",
        status: SiteStatus.active,
        actionText: "Visit Site",
        imageAssetOrUrl: AppImages.SiteAttichmentPic2,
      ),
      SiteItem(
        id: "2",
        title: "Pine Street Bridge Rehab",
        subtitle: "Site #402 . Interior Finishing",
        progressLabel: "In Progress",
        status: SiteStatus.active,
        actionText: "Visit Site",
        imageAssetOrUrl: AppImages.SiteAttichmentPic,
      ),
      SiteItem(
        id: "3",
        title: "Skyline Height Parking",
        subtitle: "Site #402 . Interior Finishing",
        progressLabel: "In Progress",
        status: SiteStatus.active,
        actionText: "Check in",
        imageAssetOrUrl: AppImages.SiteAttichmentPic2,
      ),
      SiteItem(
        id: "4",
        title: "Munich Airport Fixing",
        subtitle: "Site #402 . Interior Finishing",
        progressLabel: "Completed",
        status: SiteStatus.completed,
        actionText: "View History",
        imageAssetOrUrl: AppImages.SiteAttichmentPic,
      ),
    ]);
  }

  void changeTab(int index) => tabIndex.value = index;

  List<SiteItem> get filtered {
    final q = searchQuery.value.trim().toLowerCase();

    List<SiteItem> base;
    if (tabIndex.value == 1) {
      base = allSites.where((e) => e.status == SiteStatus.active).toList();
    } else if (tabIndex.value == 2) {
      base = allSites.where((e) => e.status == SiteStatus.completed).toList();
    } else {
      base = allSites.toList();
    }

    if (q.isEmpty) return base;

    return base.where((e) => e.title.toLowerCase().contains(q) || e.subtitle.toLowerCase().contains(q)).toList();
  }

  // Actions (wire with routes)
  void onTapSearch() {
    // open search screen / show search field / dialog
  }

  void openSite(SiteItem site) {
    // Get.toNamed(RoutesName.SiteDetailsScreen, arguments: site.id);
  }

  void onTapAction(SiteItem site) {
    // if (site.actionText == "Check in") ...
  }
}
