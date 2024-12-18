import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pico/common/contants/layout_const.dart';
import 'package:pico/common/schedule/model/schedule_model.dart';
import 'package:pico/common/schedule/model/schedules_response.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pico/common/schedule/provider/schedules_provider.dart';
import 'package:pico/common/theme/theme_light.dart';
import 'package:pico/common/view/schedule_detail_screen.dart';
import 'package:pico/home/components/day_view_painter.dart';
import 'package:pico/home/components/indicator.dart';
import 'package:pico/common/utils/event_operations.dart';
import 'package:pico/common/utils/extenstions.dart';

class DayView extends ConsumerStatefulWidget {
  final DateTime date;

  final bool isAllDayScheduleTapped;
  final void Function() toggleIsAllDayScheduleTapped;

  const DayView({
    super.key,
    required this.date,
    required this.isAllDayScheduleTapped,
    required this.toggleIsAllDayScheduleTapped,
  });

  @override
  ConsumerState<DayView> createState() => _DayViewState();
}

class _DayViewState extends ConsumerState<DayView> {
  late Timer _timer;

  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
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
                              // TODO" 여기에 전달 되는 event들은 특정 날짜에 해당하는 데이터여야 한다.
                              for (var scheduleGroup
                                  in groupOverlappingSchedules(schedules
                                      .where((s) =>
                                          s.startTime.isSameDate(widget.date))
                                      .toList()))
                                for (var organizedSchedule
                                    in getOrganizedSchedules(
                                        scheduleGroup, parentWidth))
                                  ScheduleBox(
                                    organizedSchedule: organizedSchedule,
                                  ),
                            ],
                          );
                        }),
                      )
                    ],
                  ),
                ),

                // 현재 시간 Indicator
                Positioned(
                  top: (_currentTime.hour + _currentTime.minute / 60) *
                      hourHeight,
                  left: 60, // 시간 Text 피하고 선부터 시작하기 위해서
                  right: 7,
                  child: const Indicator(),
                ),
              ],
            ),
          ),
        ),
        IgnorePointer(
          ignoring: !widget.isAllDayScheduleTapped,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 500), // 전환 시간
            curve: Curves.easeInOut,
            opacity:
                widget.isAllDayScheduleTapped ? 0.5 : 0.0, // 조건에 따라 불투명도 조절
            child: GestureDetector(
              onTap: () {
                widget.toggleIsAllDayScheduleTapped();
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
                isTapped: widget.isAllDayScheduleTapped,
                toggleIsTapped: widget.toggleIsAllDayScheduleTapped,
              ),
              Row(
                children: [
                  Expanded(
                    child: AllDayScheduleBox(
                      date: widget.date,
                      category: ScheduleType.MINE,
                      isTapped: widget.isAllDayScheduleTapped,
                      toggleIsTapped: widget.toggleIsAllDayScheduleTapped,
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Expanded(
                    child: AllDayScheduleBox(
                      date: widget.date,
                      category: ScheduleType.YOURS,
                      isTapped: widget.isAllDayScheduleTapped,
                      toggleIsTapped: widget.toggleIsAllDayScheduleTapped,
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

class AllDayScheduleBox extends ConsumerWidget {
  final DateTime date;
  final ScheduleType category;
  final bool isTapped;
  final void Function() toggleIsTapped;

  const AllDayScheduleBox({
    super.key,
    required this.date,
    required this.category,
    required this.isTapped,
    required this.toggleIsTapped,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allDaySchedulesInDateByCat = ref
        .read(schedulesProvider.notifier)
        .getAllDaySchedulesByDateAndCat(date: date, category: category);

    return Column(
      children: [
        for (int idx = 0; idx < allDaySchedulesInDateByCat.length; idx++)
          // if (isTapped || idx == 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: GestureDetector(
              onTap: () {
                if (!isTapped) {
                  if (isTapped || idx == 0) {
                    toggleIsTapped();
                  }
                } else {
                  showBarModalBottomSheet(
                    context: context,
                    builder: (context) => ScheduleDetailScreen(
                      schedule: allDaySchedulesInDateByCat[idx],
                    ),
                  );
                }
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: isTapped || idx == 0 ? 27.5 : 0,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  height: 27.5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: allDaySchedulesInDateByCat[idx].color,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset.fromDirection(
                              360, 10) // changes position of shadow
                          ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        allDaySchedulesInDateByCat[idx].title,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      allDaySchedulesInDateByCat.length > 1 && !isTapped
                          ? Text(
                              "+${allDaySchedulesInDateByCat.length - 1}개 더보기",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600]!,
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class ScheduleBox extends StatelessWidget {
  final OrganizedSchedule organizedSchedule;
  const ScheduleBox({super.key, required this.organizedSchedule});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: organizedSchedule.left,
      top: organizedSchedule.top,
      width: organizedSchedule.width - LayoutConst.scheduleBoxGap,
      height: organizedSchedule.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Material(
          color: organizedSchedule.scheduleData.color,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(6),
          // ),
          child: InkWell(
            onTap: () {
              showBarModalBottomSheet(
                context: context,
                builder: (context) => ScheduleDetailScreen(
                  schedule: organizedSchedule.scheduleData,
                ),
              );
            },
            splashColor: AppTheme.getDarkerColorByScheduleType(
                    organizedSchedule.scheduleData.category)
                .withOpacity(0.2), // 리플 색상
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: max(organizedSchedule.height * 0.06, 7),
                horizontal: max(organizedSchedule.width * 0.05, 5),
              ),
              width: organizedSchedule.width,
              height: organizedSchedule.height,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: Offset.fromDirection(
                          360, 10) // changes position of shadow
                      ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      organizedSchedule.scheduleData.title,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Wrap(
                      children: [
                        Text(
                          "${DateFormat("h시 m분").format(organizedSchedule.scheduleData.startTime)} ",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600]!,
                          ),
                        ),
                        Text(
                          "· ${organizedSchedule.scheduleData.duration.inHours}h"
                              .toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600]!,
                          ),
                        ),
                      ],
                    ),
                    // Text(
                    //   "${DateFormat.jm().format(organizedSchedule.scheduleData.startTime)} · ${organizedSchedule.scheduleData.duration.inHours}h",
                    //   maxLines: 1,
                    //   overflow: TextOverflow.ellipsis,
                    //   style: TextStyle(
                    //     fontSize: 10,
                    //     fontWeight: FontWeight.w500,
                    //     color: Colors.grey[600]!,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
