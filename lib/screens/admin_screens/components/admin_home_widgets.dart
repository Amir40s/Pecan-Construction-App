import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../core/models/site_model.dart';
import '../admin_controller/admin_home_controller.dart';

class CalendarViewTabs extends StatelessWidget {
  final AdminHomeController c;
  const CalendarViewTabs({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        height: 6.h,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color:  Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: BoxBorder.all(color: Colors.grey.shade300)
        ),
        child: Row(
          children: [
            _tab("Day", CalendarViewType.day),
            _tab("Week", CalendarViewType.week),
            _tab("Month", CalendarViewType.month),
          ],
        ),
      );
    });
  }

  Widget _tab(String text, CalendarViewType type) {
    final isSelected = c.selectedView.value == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => c.changeView(type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xffC22522) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xff888888),
            ),
          ),
        ),
      ),
    );
  }
}

class MonthHeaderRow extends StatelessWidget {
  final AdminHomeController c;
  const MonthHeaderRow({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        children: [
          IconButton(
            onPressed: c.prevMonth,
            icon: const Icon(Icons.chevron_left_rounded),
          ),

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _pill("${c.monthLabel}"),
                const SizedBox(width: 10),
                _pill("${c.yearLabel}"),
              ],
            ),
          ),

          IconButton(
            onPressed: c.nextMonth,
            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      );
    });
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class MonthCalendarGrid extends StatelessWidget {
  final AdminHomeController c;
  const MonthCalendarGrid({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    final weekDays = const ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"];

    return Obx(() {
      final month = c.focusedMonth.value;
      final days = c.getMonthDaysGrid(month);

      return Column(
        children: [
          Row(
            children: weekDays
                .map((d) => Expanded(
              child: Center(
                child: Text(
                  d,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: const Color(0xff7A7A7A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ))
                .toList(),
          ),
          const SizedBox(height: 10),

          GridView.builder(
            itemCount: 42,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              final d = days[index];

              final isCurrentMonth = d.month == month.month;
              final isSelected = _isSameDay(d, c.selectedDate.value);

              return GestureDetector(
                onTap: () => c.selectDate(d),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xffC22522) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "${d.day}",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? Colors.white
                          : (isCurrentMonth ? Colors.black : const Color(0xffBDBDBD)),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class ActiveSitesHeader extends StatelessWidget {
  final int count;
  final VoidCallback onSeeAll;

  const ActiveSitesHeader({
    super.key,
    required this.count,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Active Sites ($count)",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onSeeAll,
          child: Text(
            "See All",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xffC22522),
            ),
          ),
        ),
      ],
    );
  }
}

class SiteCard extends StatelessWidget {
  final SiteModel site;
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
                  site.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  site.subTitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xff8A8A8A),
                    fontWeight: FontWeight.w400,
                  ),
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
                    child: const Text(
                      "View Site",
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
            child: Image.asset(
              site.imagePath,
              height: 98,
              width: 93,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
