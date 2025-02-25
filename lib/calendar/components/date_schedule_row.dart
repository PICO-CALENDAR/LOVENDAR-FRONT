// 이벤트 보여지는 cell 부분
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:lovendar/calendar/provider/checked_category_provider.dart';
import 'package:lovendar/common/provider/selected_day_provider.dart';

import 'package:lovendar/common/schedule/provider/schedules_provider.dart';
import 'package:lovendar/common/theme/theme_light.dart';
import 'package:lovendar/common/utils/extenstions.dart';
import 'package:lovendar/common/view/edit_schedule_screen.dart';
import 'package:lovendar/home/components/day_view.dart';

class DateScheduleRow extends ConsumerWidget {
  const DateScheduleRow({
    super.key,
    required this.weekDate,
    required this.monthDays,
    // required this.scheduleController,
    required this.width,
    required this.height,
    required this.selectedMonth,
    required this.slotWidth,
    required this.isLastWeek,
  });

  final List<DateTime> weekDate;
  final List<DateTime> monthDays;
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

    final orgSchedules = schedulesController
        .filterAndSortSchedulesForWeek(
          schedulesController.organizeSchedules(
            checkedSchedules,
            monthDays.first,
            monthDays.last,
          ),
          weekDate.first,
          weekDate.last,
        )
        .toList();

    // print("weekdate first : ${weekDate.first}");
    // print("weekdate last : ${weekDate.first}");

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
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (BuildContext context) {
                          return DraggableScrollableSheet(
                            initialChildSize: 1,
                            minChildSize: 1,
                            maxChildSize: 1,
                            builder: (context, scrollController) {
                              final topContainerHeight =
                                  MediaQuery.of(context).size.height * 0.2;
                              return SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: Stack(
                                  children: [
                                    // Positioned.fill(
                                    //   child: BackdropFilter(
                                    //     filter: ImageFilter.blur(
                                    //         sigmaX: 5, sigmaY: 5),
                                    //     child: Container(
                                    //       color: Colors.grey.withOpacity(
                                    //           0.2), // 흐린 배경에 살짝 어두운 느낌 추가
                                    //     ),
                                    //   ),
                                    // ),
                                    // 투명한 상단 영역
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      height: topContainerHeight,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 5, sigmaY: 5),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 30,
                                            ),
                                            color: Colors.grey.withOpacity(0.2),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  DateFormat.yMMMEd()
                                                      .format(date),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Text(
                                                  "세부일정",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // 불투명한 하단 영역
                                    Positioned(
                                      top: topContainerHeight,
                                      left: 0,
                                      right: 0,
                                      height:
                                          MediaQuery.of(context).size.height -
                                              topContainerHeight,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(16),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                vertical: 20,
                                              ),
                                              height: 4,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            Expanded(
                                              child: DayView(
                                                date: date,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    Positioned(
                                      bottom: 40,
                                      right: 20,
                                      child: FloatingActionButton(
                                        heroTag: 'add-btn',
                                        elevation: 1,
                                        shape: CircleBorder(),
                                        onPressed: () {
                                          ref
                                              .read(
                                                  selectedDayProvider.notifier)
                                              .setSelectedDay(date);
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         EditScheduleScreen(),
                                          //   ),
                                          // );

                                          showModalBottomSheet<void>(
                                            context: context,
                                            isScrollControlled: true,
                                            isDismissible: false,
                                            builder: (BuildContext context) {
                                              return SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.9,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20),
                                                  ),
                                                  child: EditScheduleScreen(),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        child: const Icon(
                                          Icons.add_rounded,
                                          color: Colors.white,
                                          size: 45,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );

                      // showBarModalBottomSheet(
                      //   context: context,
                      //   builder: (context) {
                      //     return Scaffold(
                      //       appBar: AppBar(
                      //         title: Text(
                      //           "${DateFormat.yMMMMd().format(date)} 일정",
                      //         ),
                      //       ),
                      //       body: SafeArea(
                      //         child: Padding(
                      //           padding: const EdgeInsets.symmetric(
                      //             horizontal: 20,
                      //             vertical: 15,
                      //           ),
                      //           child: Column(
                      //             children: [
                      //               Text(
                      //                 "${DateFormat.yMMMMEEEEd().format(date)} 세부 일정",
                      //                 style: TextStyle(
                      //                   fontSize: 18,
                      //                   fontWeight: FontWeight.bold,
                      //                 ),
                      //               ),
                      //               SizedBox(
                      //                 height: 10,
                      //               ),
                      //               SizedBox(
                      //                 height:
                      //                     MediaQuery.of(context).size.height *
                      //                         0.6,
                      //                 child: DayView(
                      //                   date: date,
                      //                 ),
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // );
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
                                  .isSameDate(weekDate.first) ||
                              schedule.scheduleData.startTime
                                  .isBefore(weekDate.first)
                          ? 2
                          : (schedule.scheduleData.startTime.weekday - 1) *
                                  slotWidth +
                              2,
                      right: schedule.scheduleData.endTime
                                  .isSameDate(weekDate.last) ||
                              schedule.scheduleData.endTime
                                  .isAfter(weekDate.last)
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
                              borderRadius: BorderRadius.horizontal(
                                left: schedule.scheduleData.startTime
                                        .isBefore(weekDate.first)
                                    ? Radius.zero
                                    : Radius.circular(5),
                                right: schedule.scheduleData.endTime
                                        .isAfter(weekDate.last)
                                    ? Radius.zero
                                    : Radius.circular(5),
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
                  : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
