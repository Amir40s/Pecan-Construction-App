import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pecan_construction/core/constant/app_images.dart';
import '../../../core/models/site_model.dart';

enum CalendarViewType { day, week, month }
enum SiteTab { all, active, completed }
class AdminHomeController extends GetxController {

  final selectedSiteTab = SiteTab.all.obs;

  void changeSiteTab(SiteTab tab) {
    selectedSiteTab.value = tab;
  }
  // header
  final adminName = "Admin".obs;
  final welcomeText = "Welcome".obs;
  final profileImage = AppImages.profileImage.obs;

  // calendar
  final selectedView = CalendarViewType.month.obs;
  final focusedMonth = DateTime.now().obs;       // month being shown
  final selectedDate = DateTime.now().obs;       // selected day

  // Your sites list should already exist
  final sites = <SiteModel>[].obs;

  List<SiteModel> get filteredSites {
    final tab = selectedSiteTab.value;
    if (tab == SiteTab.all) return sites;
    if (tab == SiteTab.active) {
      return sites.where((s) => s.status == SiteStatus.active).toList();
    }
    return sites.where((s) => s.status == SiteStatus.completed).toList();
  }
  @override
  void onInit() {
    super.onInit();

    // Dummy data example (replace with your real data)
    sites.assignAll([
      SiteModel(
        title: "Downtown Plaza Renovation",
        subTitle: "Site #402. • Interior Finishing",
        imagePath: AppImages.SiteImage,
        progressText: "In Progress",
        status: SiteStatus.active,
      ),
      SiteModel(
        title: "Pine Street Bridge Rehab",
        subTitle: "Site #402. • Interior Finishing",
        imagePath: AppImages.Site2Image,
        progressText: "In Progress",
        status: SiteStatus.active,
      ),
      SiteModel(
        title: "Old Mall Project",
        subTitle: "Site #112. • Finishing",
        imagePath:  AppImages.Site2Image,
        progressText: "Completed",
        status: SiteStatus.completed,
      ),
    ]);
  }


  void changeView(CalendarViewType type) {
    selectedView.value = type;
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  void prevMonth() {
    final m = focusedMonth.value;
    focusedMonth.value = DateTime(m.year, m.month - 1, 1);
  }

  void nextMonth() {
    final m = focusedMonth.value;
    focusedMonth.value = DateTime(m.year, m.month + 1, 1);
  }

  String get monthLabel => DateFormat("MMM").format(focusedMonth.value);
  String get yearLabel => DateFormat("yyyy").format(focusedMonth.value);

  // month grid helper
  List<DateTime> getMonthDaysGrid(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    // start from Sunday
    final startOffset = firstDay.weekday % 7; // Sunday=0
    final gridStart = firstDay.subtract(Duration(days: startOffset));

    // 6 rows x 7 cols = 42 days
    return List.generate(42, (i) => gridStart.add(Duration(days: i)));
  }
}
