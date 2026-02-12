import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/config/routes/routes_name.dart';
import 'package:pecan_construction/core/widgets/app_text.dart';
import 'package:sizer/sizer.dart';
import '../../core/models/site_model.dart';
import 'admin_controller/admin_home_controller.dart';


class SiteScreen extends StatelessWidget {
  SiteScreen({super.key});

  final c = Get.find<AdminHomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            children: [
              SizedBox(height : 2.h),
              // Top Row: Title + Plus
              Row(
                children: [
                  const Expanded(
                    child: AppText( "Construction Sites",fontSize: 20,fontWeight: FontWeight.w600,)
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xffF6D6D6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Get.toNamed(RoutesName.CreateSiteScreen);
                      },
                      icon: const Icon(Icons.add, color: Color(0xffC22522), size: 18),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Tabs
              Obx(() => _Tabs(
                selected: c.selectedSiteTab.value,
                onChanged: c.changeSiteTab,
              )),

              const SizedBox(height: 12),

              // List
              Expanded(
                child: Obx(() {
                  final list = c.filteredSites;
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      return _SiteCard(
                        site: list[i],
                        onVisit: () {
                          // TODO: open site detail
                        },
                        onInfo: () {
                          // TODO: info dialog
                        },
                      );
                    },
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

class _Tabs extends StatelessWidget {
  final SiteTab selected;
  final Function(SiteTab) onChanged;

  const _Tabs({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _tab("All Sites", SiteTab.all),
        // const SizedBox(width: 18),
        _tab("Active", SiteTab.active),
        // const SizedBox(width: 18),
        _tab("Completed", SiteTab.completed),
      ],
    );
  }

  Widget _tab(String text, SiteTab tab) {
    final isSelected = selected == tab;
    return GestureDetector(
      onTap: () => onChanged(tab),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.black : const Color(0xff9B9B9B),
            ),
          ),
          const SizedBox(height: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2,
            width: isSelected ? 60 : 0,
            decoration: BoxDecoration(
              color: const Color(0xffC22522),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}

class _SiteCard extends StatelessWidget {
  final SiteModel site;
  final VoidCallback onVisit;
  final VoidCallback onInfo;

  const _SiteCard({
    required this.site,
    required this.onVisit,
    required this.onInfo,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = site.status == SiteStatus.completed;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: BoxBorder.all(color: Colors.grey.shade300)
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // status line
                Row(
                  children: [
                    Container(
                      height: 6,
                      width: 6,
                      decoration: BoxDecoration(
                        color: isCompleted ? Colors.green : const Color(0xffF4B400),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      site.progressText,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff7A7A7A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                Text(
                  site.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  site.subTitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff9B9B9B),
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    SizedBox(
                      height: 34,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: const Color(0xffF6D6D6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: onVisit,
                        child: const Text(
                          "Visit Site",
                          style: TextStyle(
                            color: Color(0xffC22522),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: onInfo,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.info_outline, size: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              site.imagePath,
              height: 13.h,
              width: 30.w,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
