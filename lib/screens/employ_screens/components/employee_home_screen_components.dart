import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';

import '../../../core/widgets/app_text.dart';
import '../controllers/employee_home_controller.dart';

class EmployeeCalendarViewTabs extends StatelessWidget {
  final EmployeeHomeController c;
  const EmployeeCalendarViewTabs({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    const red = Color(0xFFC22522);
    final border = Colors.grey.shade300;

    Widget tab(String title, CalendarViewMode mode) {
      return Obx(() {
        final selected = c.viewMode.value == mode;
        return Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => c.setViewMode(mode),
            child: Container(
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? red : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: selected ? red : border),
              ),
              child: AppText(
                title,
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: selected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ),
        );
      });
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          tab("Day", CalendarViewMode.day),
          const Gap(8),
          tab("Week", CalendarViewMode.week),
          const Gap(8),
          tab("Month", CalendarViewMode.month),
        ],
      ),
    );
  }
}


class EmployeeMonthHeaderRow extends StatelessWidget {
  final EmployeeHomeController c;
  const EmployeeMonthHeaderRow({super.key, required this.c});

  static const months = [
    "Jan","Feb","Mar","Apr","May","Jun",
    "Jul","Aug","Sep","Oct","Nov","Dec"
  ];

  @override
  Widget build(BuildContext context) {
    final border = Colors.grey.shade300;

    return Obx(() {
      final monthIndex = c.selectedMonth.value; // 1..12
      final year = c.selectedYear.value;

      return Row(
        children: [
          EmployeeHeaderArrow(
            icon: Icons.chevron_left_rounded,
            onTap: c.prevMonth,
            border: border,
          ),
          const Gap(10),

          // Month dropdown look
          Container(
            width: 27.w,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: border),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Row(
              children: [
                AppText(
                  months[monthIndex - 1],
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
                Spacer(),
                Icon(Icons.keyboard_arrow_down_rounded,
                    size: 18, color: Colors.grey.shade700),
              ],
            ),
          ),

SizedBox(width: 8.w,),
          // Year dropdown look
          Container(
            width: 27.w,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: border),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Row(
              children: [
                AppText(
                  "$year",
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
               Spacer(),
                Icon(Icons.keyboard_arrow_down_rounded,
                    size: 18, color: Colors.grey.shade700),
              ],
            ),
          ),
          SizedBox(width: 7.w,),
          EmployeeHeaderArrow(
            icon: Icons.chevron_right_rounded,
            onTap: c.nextMonth,
            border: border,
          ),
        ],
      );
    });
  }
}

class EmployeeHeaderArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color border;

  const EmployeeHeaderArrow({
    required this.icon,
    required this.onTap,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.grey.shade800),
      ),
    );
  }
}

class EmployeeMonthCalendarGrid extends StatelessWidget {
  final EmployeeHomeController c;
  const EmployeeMonthCalendarGrid({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    const red = Color(0xFFC22522);

    return Obx(() {
      final year = c.selectedYear.value;
      final month = c.selectedMonth.value;
      final selectedDay = c.selectedDay.value;

      final firstDay = DateTime(year, month, 1);
      final daysInMonth = DateTime(year, month + 1, 0).day;

      // DateTime.weekday: Mon=1..Sun=7
      // We want Sunday-start grid => offset: Sun=0, Mon=1, ... Sat=6
      final int leadingEmpty = firstDay.weekday % 7;

      final totalCells = leadingEmpty + daysInMonth;
      final rows = (totalCells / 7).ceil();
      final gridCount = rows * 7;

      final weekLabels = const ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"];

      return Column(
        children: [
          // Weekday labels
          Row(
            children: weekLabels
                .map(
                  (w) => Expanded(
                child: Center(
                  child: AppText(
                    w,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            )
                .toList(),
          ),
          const Gap(8),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: gridCount,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
            ),
            itemBuilder: (context, index) {
              final dayNumber = index - leadingEmpty + 1;
              final isInMonth = dayNumber >= 1 && dayNumber <= daysInMonth;

              if (!isInMonth) {
                return const SizedBox.shrink();
              }

              final isSelected = dayNumber == selectedDay;

              return InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => c.pickDay(dayNumber),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? red : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: AppText(
                    "$dayNumber",
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              );
            },
          ),
        ],
      );
    });
  }
}

class EmployeeSiteItemWidget extends StatelessWidget {
  final EmployeeSiteItem site;
  final VoidCallback onView;

  const EmployeeSiteItemWidget({
    super.key,
    required this.site,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    const red = Color(0xFFC22522);
    final border = Colors.grey.shade300;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Left text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  site.title,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
                const Gap(4),
                AppText(
                  site.subtitle,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
                const Gap(10),
                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: onView,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: AppText(
                          site.buttonText,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Gap(10),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.info_outline_rounded, size: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Gap(10),

          // Right image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              site.imageAsset,
              width: 26.w,
              height: 12.h,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
