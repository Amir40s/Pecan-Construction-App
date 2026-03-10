import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/core/widgets/app_text.dart';
import 'package:pecan_construction/core/widgets/appnetworkImage.dart';
import 'package:sizer/sizer.dart';
import '../../../core/models/site_model.dart';


class ActiveSitesHeader extends StatelessWidget {
  final int count;


  const ActiveSitesHeader({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "total_site".tr + " (${count.toString()})",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class SiteCard extends StatelessWidget {
  final SitesModel site;
  final VoidCallback onView;

  const SiteCard({
    super.key,
    required this.site,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffEAEAEA)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  site.siteName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                AppText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  site.siteNote.toString(),
                  fontSize: 14,
                  color: const Color(0xff8A8A8A),
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 34,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffC22522),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    onPressed: onView,
                    child:  Text(
                      "view_site".tr,
                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
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
              width: 20.w,
              height: 20.w,
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
