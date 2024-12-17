import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pico/common/contants/layout_const.dart';
import 'package:pico/common/schedule/model/schedule_model.dart';
import 'package:pico/common/schedule/model/schedules_response.dart';
import 'package:pico/common/schedule/provider/schedules_in_week_provider.dart';
import 'package:pico/home/components/day_view_painter.dart';
import 'package:pico/home/components/indicator.dart';
import 'package:pico/common/utils/event_operations.dart';
import 'package:pico/common/utils/extenstions.dart';

class DayView extends ConsumerStatefulWidget {
  final DateTime date;
  const DayView({super.key, required this.date});

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
    final schedules = ref.watch(schedulesInWeekProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 65,
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
                  const SizedBox(
                    width: 80, // 시간 선 시작하는 부분 좌표
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
                          for (var scheduleGroup in groupOverlappingSchedules(
                              schedules
                                  .where((s) =>
                                      s.startTime.isSameDate(widget.date))
                                  .toList()))
                            for (var organizedSchedule in getOrganizedSchedules(
                                scheduleGroup, parentWidth))
                              ScheduleBox(
                                organizedSchedule: organizedSchedule,
                              )
                        ],
                      );
                    }),
                  )
                ],
              ),
            ),

            // 현재 시간 Indicator
            Positioned(
              top: (_currentTime.hour + _currentTime.minute / 60) * hourHeight,
              left: 70, // 시간 Text 피하고 선부터 시작하기 위해서
              right: 7,
              child: const Indicator(),
            ),
          ],
        ),
      ),
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
      child: GestureDetector(
        onTap: () {
          print(organizedSchedule.scheduleData.title);
          print(organizedSchedule.scheduleData.startTime);
          print(organizedSchedule.scheduleData.endTime);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: max(organizedSchedule.height * 0.06, 7),
            horizontal: max(organizedSchedule.width * 0.05, 5),
          ),
          width: organizedSchedule.width,
          height: organizedSchedule.height,
          decoration: BoxDecoration(
            color: organizedSchedule.scheduleData.color,
            borderRadius: const BorderRadius.all(
              Radius.circular(6),
            ),
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
                Text(
                  "${DateFormat.jm().format(organizedSchedule.scheduleData.startTime)} · ${organizedSchedule.scheduleData.duration.inHours}h",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700]!,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
