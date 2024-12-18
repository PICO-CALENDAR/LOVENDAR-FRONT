// 이벤트 보여지는 cell 부분
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pico/calendar/provider/checked_category_provider.dart';

import 'package:pico/common/schedule/provider/schedules_provider.dart';
import 'package:pico/common/theme/theme_light.dart';
import 'package:pico/home/components/day_view.dart';

class DateScheduleRow extends ConsumerWidget {
  const DateScheduleRow({
    super.key,
    required this.weekDate,
    // required this.scheduleController,
    required this.width,
    required this.height,
    required this.selectedMonth,
    required this.slotWidth,
    required this.isLastWeek,
  });

  final List<DateTime> weekDate;
  // final ScheduleController scheduleController;
  final double width;
  final double height;
  final int selectedMonth;
  final double slotWidth;
  final bool isLastWeek;

  //  late ScheduleController _scheduleController = ScheduleController(schedules: []);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final selectedMonth = ref.watch(selectedCalendarMonthProvider).month;
    final schedules = ref.watch(schedulesProvider);

    final checkedCategoryState = ref.watch(checkedCategoryProvider);
    final schedulesController = ref.read(schedulesProvider.notifier);
    const gap = 1;
    const maxColumn = 4;
    final eventHeight = (height - (maxColumn + 2) * gap) * 0.25;

    final filteredKeys = checkedCategoryState.entries
        .where((entry) => entry.value) // value가 true인 항목만 선택
        .map((entry) => entry.key) // key만 추출
        .toList();

    final checkedSchedules = schedules
        .where((schedule) => filteredKeys.contains(schedule.category))
        .toList();

    final orgSchedules = schedulesController.filterAndSortSchedulesForWeek(
        schedulesController.organizeSchedules(
          checkedSchedules,
        ),
        weekDate.first,
        weekDate.last);
    // for (var event in organizeEvents(events)) {
    //   print("${event.eventData.title} : ${event.column}");
    //   print(event.eventData.startTime.isBefore(weekDate.first));
    //   print((event.eventData.startTime.weekday - 1) * slotWidth + 2);
    //   print(event.eventData.endTime.isAfter(weekDate.last));
    // }

    return SingleChildScrollView(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border(
            // left: const AppTheme.borderSide,
            // right: const AppTheme.borderSide,
            bottom: isLastWeek ? AppTheme.borderSide : BorderSide.none,
          ),
        ),
        child: Stack(
          children: [
            // 경계를 나타내는 부분
            Row(
              children: [
                for (var date in weekDate)
                  GestureDetector(
                    onTap: () {
                      showBarModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Scaffold(
                            appBar: AppBar(
                              title: Text(
                                "${DateFormat.yMMMMd().format(date)} 일정",
                              ),
                            ),
                            body: SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "${DateFormat.yMMMMEEEEd().format(date)} 세부 일정",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.6,
                                      child: DayView(
                                        date: date,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      width: slotWidth,
                      decoration: BoxDecoration(
                        border: Border(
                          left: AppTheme.borderSide,
                        ),
                        color: date.month == selectedMonth
                            ? Colors.transparent
                            : AppTheme.scaffoldBackgroundColorDark,
                      ),
                    ),
                  ),
              ],
            ),
            for (var schedule in orgSchedules)
              schedule.column <= maxColumn
                  ? Positioned(
                      top: (schedule.column - 1) * eventHeight +
                          (gap * (schedule.column - 1)),
                      left: schedule.scheduleData.startTime
                              .isBefore(weekDate.first)
                          ? 2
                          : (schedule.scheduleData.startTime.weekday - 1) *
                                  slotWidth +
                              2,
                      right:
                          schedule.scheduleData.endTime.isAfter(weekDate.last)
                              ? 2
                              : (7 - (schedule.scheduleData.endTime.weekday)) *
                                      slotWidth +
                                  2,
                      child: IgnorePointer(
                        ignoring: true,
                        child: AnimatedSwitcher(
                          key: Key(schedule.scheduleData.scheduleId.toString()),
                          duration: const Duration(milliseconds: 300),
                          switchInCurve: Curves.easeIn,
                          switchOutCurve: Curves.easeOut,
                          child: Container(
                            height: eventHeight,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 2,
                            ),
                            decoration: BoxDecoration(
                              color: schedule.scheduleData.color,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      schedule.scheduleData.title,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                (schedule.column == maxColumn &&
                                        schedulesController
                                                .getSchedulesForDate(
                                                    schedules: schedules,
                                                    date: schedule
                                                        .scheduleData.startTime)
                                                .length >
                                            maxColumn)
                                    ? Expanded(
                                        child: Text(
                                          "+${schedulesController.getSchedulesForDate(schedules: schedules, date: schedule.scheduleData.startTime).length - maxColumn}",
                                          style: const TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
