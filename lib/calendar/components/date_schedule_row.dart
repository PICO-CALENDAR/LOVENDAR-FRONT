// 이벤트 보여지는 cell 부분
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pico/common/schedule/provider/schedules_provider.dart';
import 'package:pico/common/theme/theme_light.dart';

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
    // final schedules = ref.watch(schedulesProvider);
    final schedulesController = ref.read(schedulesProvider.notifier);
    const gap = 1;
    const maxColumn = 4;
    final eventHeight = (height - (maxColumn + 2) * gap) * 0.25;
    final orgSchedules = schedulesController.filterAndSortSchedulesForWeek(
        schedulesController.organizeSchedules(), weekDate.first, weekDate.last);
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
                      print(date);
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
                        child: Container(
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
                                              .getSchedulesForDate(schedule
                                                  .scheduleData.startTime)
                                              .length >
                                          maxColumn)
                                  ? Expanded(
                                      child: Text(
                                        "+${schedulesController.getSchedulesForDate(schedule.scheduleData.startTime).length - maxColumn}",
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
                    )
                  : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
