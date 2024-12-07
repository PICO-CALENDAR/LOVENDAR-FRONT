import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:pico/home/components/day_view_painter.dart';
import 'package:pico/home/components/indicator.dart';
import 'package:pico/common/contants/calendar_const.dart';
import 'package:pico/common/utils/event_operations.dart';
import 'package:pico/common/utils/extenstions.dart';

class DayView extends StatefulWidget {
  final DateTime date;
  const DayView({super.key, required this.date});

  @override
  State<DayView> createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {
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
                      final parentWidth = constraints.maxWidth;

                      // print(CalendarConst.events.where((e) {
                      //   print(e.startTime.day);
                      //   print(widget.date.day);
                      //   return e.startTime.isSameDate(widget.date);
                      // }));

                      return Stack(
                        children: [
                          // TODO" 여기에 전달 되는 event들은 특정 날짜에 해당하는 데이터여야 한다.
                          for (var eventGroup in groupOverlappingEvents(
                              CalendarConst.events
                                  .where((e) =>
                                      e.startTime.isSameDate(widget.date))
                                  .toList()))
                            for (var organizedEvent
                                in getOrganizedEvents(eventGroup, parentWidth))
                              EventBox(
                                organizedEvent: organizedEvent,
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
              right: 10,
              child: const Indicator(),
            ),
          ],
        ),
      ),
    );
  }
}

class EventBox extends StatelessWidget {
  final OrganizedEvent organizedEvent;
  const EventBox({super.key, required this.organizedEvent});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: organizedEvent.left,
      top: organizedEvent.top,
      width: organizedEvent.width,
      height: organizedEvent.height,
      child: GestureDetector(
        onTap: () {
          print(organizedEvent.eventData.title);
          print(organizedEvent.eventData.startTime);
          print(organizedEvent.eventData.endTime);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: max(organizedEvent.height * 0.06, 7),
            horizontal: max(organizedEvent.width * 0.07, 6),
          ),
          width: organizedEvent.width,
          height: organizedEvent.height,
          decoration: BoxDecoration(
            color: organizedEvent.eventData.color,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  organizedEvent.eventData.title,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  organizedEvent.eventData.category.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
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
