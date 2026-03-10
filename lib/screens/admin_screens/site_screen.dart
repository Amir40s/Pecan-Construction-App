import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/config/routes/routes_name.dart';
import 'package:pecan_construction/core/widgets/app_text.dart';
import 'package:sizer/sizer.dart';
import '../../core/models/site_model.dart';
import '../../core/widgets/appnetworkImage.dart';
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
                   Expanded(
                    child: AppText(  "construction_sites".tr,fontSize: 20,fontWeight: FontWeight.w600,)
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
                  if (c.isLoadingSites.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final list = c.filteredSites;

                  if (list.isEmpty) {
                    return  Center(
                      child: Text( "no_sites_found".tr,),
                    );
                  }
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      return _SiteCard(
                        site: list[i],
                        onVisit: () {
                          Get.toNamed(RoutesName.SiteDetailsScreen_2, arguments: list[i].siteId);
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
        _tab("all_sites".tr, SiteTab.all),
        _tab("active".tr, SiteTab.active),
        _tab("completed".tr, SiteTab.completed),
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
  final SitesModel site;
  final VoidCallback onVisit;

  const _SiteCard({
    required this.site,
    required this.onVisit,

  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = site.siteStatus.trim().toLowerCase() == "completed";
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
                      site.siteStatus,
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
                  site.siteName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  site.siteNote.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
                        child:  Text(
                          "visit_site".tr,
                          style: TextStyle(
                            color: Color(0xffC22522),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
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
            child: AppNetworkImage(
              url: site.sitePhoto,
              isCircle: false,
              width: 25.w,
              height: 25.w,
              placeholderAsset: "",
              borderWidth: 3,
              borderColor: Colors.white,
            )
          ),
        ],
      ),
    );
  }
}
