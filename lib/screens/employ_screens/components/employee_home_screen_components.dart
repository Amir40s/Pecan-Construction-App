import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:pecan_construction/core/models/site_model.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/cupertino.dart';
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

  void openMonthPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        int tempMonth = c.selectedMonth.value;

        return Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [

              // Top bar with Done button
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xffEAEAEA)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    TextButton(onPressed: () => Navigator.pop(context), child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),),
                   TextButton(onPressed: (){}, child:  const Text(
                     "Select Month",
                     style: TextStyle(
                       fontSize: 16,
                       fontWeight: FontWeight.w600,
                     ),
                   ),),

                    TextButton(onPressed: () {
                      c.setMonth(tempMonth);
                      Navigator.pop(context);
                    }, child: Text(
        "Done",
        style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFFC22522),
        ),
        ),)
                  ],
                ),
              ),

              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40,
                  scrollController: FixedExtentScrollController(
                    initialItem: c.selectedMonth.value - 1,
                  ),
                  onSelectedItemChanged: (index) {
                    tempMonth = index + 1;
                  },
                  children: EmployeeMonthHeaderRow.months
                      .map(
                        (m) => Center(
                      child: Text(
                        m,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final border = Colors.grey.shade300;

    return Obx(() {
      final monthIndex = c.selectedMonth.value; // 1..12
      final year = c.selectedYear.value;

      return Row(
        children: [
           Gap(1.w),
          EmployeeHeaderArrow(
            icon: Icons.chevron_left_rounded,
            onTap: c.prevMonth,
            border: border,
          ),
          const Gap(10),

          // Month dropdown look
          InkWell(
            onTap: () => openMonthPicker(context),
            child: Container(
              width: 40.w,
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
          ),

          const Gap(10),
          Container(
            width: 20.w,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: border),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Row(
              children: [
                AppText(
                  year.toString(),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ],
            ),
          ),


          // Year dropdown look

          SizedBox(width: 10,),
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
      // 👇 rebuild when sites change
      final _ = c.sites.length;

      final year = c.selectedYear.value;
      final month = c.selectedMonth.value;
      final selectedDay = c.selectedDay.value;

      final firstDay = DateTime(year, month, 1);
      final daysInMonth = DateTime(year, month + 1, 0).day;

      final int leadingEmpty = firstDay.weekday % 7;

      final totalCells = leadingEmpty + daysInMonth;
      final rows = (totalCells / 7).ceil();
      final gridCount = rows * 7;

      final weekLabels = const ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"];

      return Column(
        children: [
          /// Week labels
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

          /// Calendar grid
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

              /// 👇 site status check
              final statuses = c.getSiteStatusesForDay(dayNumber);
              Color? indicatorColor;

              if (statuses == "completed") {
                indicatorColor = Colors.green;
              } else if (statuses == "active") {
                indicatorColor = Colors.red;
              } else if (statuses == "paused") {
                indicatorColor = Colors.grey;
              }

              return InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => c.pickDay(dayNumber),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? red : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// Day number
                      AppText(
                        "$dayNumber",
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),

                      /// Indicator
                      statuses.isEmpty
                          ? const SizedBox()
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: statuses.map((status) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: c.getStatusColor(status),
                              shape: BoxShape.circle,
                            ),
                          );
                        }).toList(),
                      )
                    ],
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
