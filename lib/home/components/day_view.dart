import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lovendar/common/contants/layout_const.dart';
import 'package:lovendar/common/schedule/model/schedule_model.dart';
import 'package:lovendar/common/schedule/model/schedules_response.dart';
import 'package:lovendar/home/components/schedule_container/all_day_schedule_box.dart';
import 'package:lovendar/home/components/schedule_container/schedule_box.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:lovendar/common/schedule/provider/schedules_provider.dart';
import 'package:lovendar/common/theme/theme_light.dart';
import 'package:lovendar/common/view/schedule_detail_screen.dart';
import 'package:lovendar/home/components/day_view_painter.dart';
import 'package:lovendar/home/components/indicator.dart';
import 'package:lovendar/common/utils/schedule_operations.dart';
import 'package:lovendar/common/utils/extenstions.dart';

class DayView extends ConsumerStatefulWidget {
  final DateTime date;

  final bool? isAllDayScheduleTapped;
  final void Function()? toggleIsAllDayScheduleTapped;

  const DayView({
    super.key,
    required this.date,
    this.isAllDayScheduleTapped,
    this.toggleIsAllDayScheduleTapped,
  });

  @override
  ConsumerState<DayView> createState() => _DayViewState();
}

class _DayViewState extends ConsumerState<DayView> {
  late Timer _timer;

  DateTime _currentTime = DateTime.now();
  bool isAllDayScheduleTapped = false;

  void toggleIsAllDayScheduleTapped() {
    setState(() {
      isAllDayScheduleTapped = !isAllDayScheduleTapped;
    });
  }

  @override
  void initState() {
    super.initState();
    final schedules = ref.read(schedulesProvider);
    if (schedules.isEmpty) {
      ref.read(schedulesProvider.notifier).refreshSchedules();
    }
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const hourHeight = 60.0; // 1시간 = 60픽셀
    const totalHeight = 24 * hourHeight; // 24시간의 전체 높이
    final schedules = ref.watch(schedulesProvider);
    final scheduleObjs = schedules
        .map(
          (s) => s.copyScheduleOnDate(targetDate: widget.date),
        )
        .whereType<ScheduleModel>()
        .toList();

    // List<DateTime> getWeekBoundaries(DateTime targetDate) {
    //   // 특정 날짜의 월요일 계산
    //   final firstDayOfWeek =
    //       targetDate.subtract(Duration(days: targetDate.weekday - 1));
    //   final startOfWeek = DateTime(
    //       firstDayOfWeek.year, firstDayOfWeek.month, firstDayOfWeek.day);

    //   // 특정 날짜의 일요일 계산
    //   final lastDayOfWeek = startOfWeek.add(const Duration(days: 6));
    //   final endOfWeek =
    //       DateTime(lastDayOfWeek.year, lastDayOfWeek.month, lastDayOfWeek.day);

    //   return [startOfWeek, endOfWeek];
    // }

    // final orgSchedules =
    //     ref.read(schedulesProvider.notifier).filterAndSortSchedulesForWeek(
    //           ref.read(schedulesProvider.notifier).organizeSchedules(
    //                 schedules,
    //                 widget.date.datesOfMonths().first,
    //                 widget.date.datesOfMonths().last,
    //               ),
    //           getWeekBoundaries(widget.date)[0],
    //           getWeekBoundaries(widget.date)[1],
    //         );

    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 85,
              horizontal: 5,
            ),
            child: Stack(
              children: [
                // 시간 블록 배경
                CustomPaint(
                  size: Size(
                      MediaQuery.of(context).size.width,
                      totalHeight +
                          5), // hightOffset, textHightOffset <= 미세 조정 offset 더함
                  painter: DayViewPainter(),
                ),

                SizedBox(
                  width: MediaQuery.of(context).size.width, // Text 크기
                  height: totalHeight,
                  // decoration: BoxDecoration(
                  //   border: Border.all(),
                  // ),
                  child: Row(
                    children: [
                      // DayView 시간 텍스트 여백
                      SizedBox(
                        width: LayoutConst.dayViewTimeGap, // 시간 선 시작하는 부분 좌표
                        height: double.infinity,
                        // decoration: BoxDecoration(
                        //   border: Border.all(),
                        // ),
                      ),
                      Expanded(
                        child: LayoutBuilder(builder: (context, constraints) {
                          final parentWidth =
                              constraints.maxWidth - LayoutConst.dayViewPadding;

                          // print(CalendarConst.events.where((e) {
                          //   print(e.startTime.day);
                          //   print(widget.date.day);
                          //   return e.startTime.isSameDate(widget.date);
                          // }));

                          return Stack(
                            children: [
                              for (var scheduleGroup
                                  in groupOverlappingSchedules(
                                schedules: scheduleObjs.adjustMultiDaySchedules(
                                  targetDate: widget.date,
                                ),
                              ))
                                for (var organizedSchedule
                                    in getOrganizedSchedules(
                                  overlappingSchedules: scheduleGroup,
                                  viewWidth: parentWidth,
                                ))
                                  ScheduleBox(
                                    organizedSchedule: organizedSchedule,
                                    targetDate: widget.date,
                                  ),
                            ],
                          );
                        }),
                      )
                    ],
                  ),
                ),

                // 현재 시간 Indicator
                widget.date.isSameDate(_currentTime)
                    ? Positioned(
                        top: (_currentTime.hour + _currentTime.minute / 60) *
                            hourHeight,
                        left: 60, // 시간 Text 피하고 선부터 시작하기 위해서
                        right: 7,
                        child: const Indicator(),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),

        // 하루종일 이벤트 관련
        IgnorePointer(
          ignoring: widget.isAllDayScheduleTapped != null
              ? !widget.isAllDayScheduleTapped!
              : !isAllDayScheduleTapped,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 300), // 전환 시간
            curve: Curves.easeInOut,
            opacity: widget.isAllDayScheduleTapped != null
                ? widget.isAllDayScheduleTapped!
                    ? 0.6
                    : 0.0
                : isAllDayScheduleTapped
                    ? 0.6
                    : 0.0, // 조건에 따라 불투명도 조절
            child: GestureDetector(
              onTap: () {
                widget.toggleIsAllDayScheduleTapped != null
                    ? widget.toggleIsAllDayScheduleTapped!()
                    : toggleIsAllDayScheduleTapped();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.scaffoldBackgroundColorDark,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: LayoutConst.dayViewTimeGap,
            right: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AllDayScheduleBox(
                date: widget.date,
                category: ScheduleType.OURS,
                isTapped: widget.isAllDayScheduleTapped != null
                    ? widget.isAllDayScheduleTapped!
                    : isAllDayScheduleTapped,
                toggleIsTapped: widget.toggleIsAllDayScheduleTapped != null
                    ? widget.toggleIsAllDayScheduleTapped!
                    : toggleIsAllDayScheduleTapped,
              ),
              Row(
                children: [
                  Expanded(
                    child: AllDayScheduleBox(
                      date: widget.date,
                      category: ScheduleType.MINE,
                      isTapped: widget.isAllDayScheduleTapped != null
                          ? widget.isAllDayScheduleTapped!
                          : isAllDayScheduleTapped,
                      toggleIsTapped:
                          widget.toggleIsAllDayScheduleTapped != null
                              ? widget.toggleIsAllDayScheduleTapped!
                              : toggleIsAllDayScheduleTapped,
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Expanded(
                    child: AllDayScheduleBox(
                      date: widget.date,
                      category: ScheduleType.YOURS,
                      isTapped: widget.isAllDayScheduleTapped != null
                          ? widget.isAllDayScheduleTapped!
                          : isAllDayScheduleTapped,
                      toggleIsTapped:
                          widget.toggleIsAllDayScheduleTapped != null
                              ? widget.toggleIsAllDayScheduleTapped!
                              : toggleIsAllDayScheduleTapped,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
