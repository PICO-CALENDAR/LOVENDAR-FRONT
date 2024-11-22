import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart' as intl;
import 'package:pico/components/day_view/dayview_date_picker.dart';
import 'package:pico/components/day_view/indicator.dart';
import 'package:pico/contants/calendar_const.dart';
import 'package:pico/utils/date_operations.dart';
import 'package:pico/utils/event_operations.dart';
import 'package:pico/utils/extenstions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final currentWeekDate = getWeekDate(DateTime.now());
  late final PageController _pageController;

  DateTime selectedDate = DateTime.now();

  int getIndex(DateTime tapDate) {
    return currentWeekDate.indexWhere((date) {
      return date.isSameDate(tapDate);
    });
  }

  int get currentIndex => getIndex(selectedDate);

  @override
  void initState() {
    _pageController = PageController(initialPage: currentIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 로고 및 알림 버튼
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              Image.asset('images/pico_logo.png', height: kToolbarHeight),
              const Spacer(),
              const Icon(
                Icons.notifications_rounded,
                size: 30,
              ),
            ],
          ),
        ),
        // 현재 연도 및 월
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              Text(
                intl.DateFormat.yMMM().format(DateTime.now()),
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
        // DayviewDatePicker
        DayviewDatePicker(
          selectedDate: selectedDate,
          onTap: (date) {
            _pageController.jumpToPage(getIndex(date));
            setState(() {
              selectedDate = date;
            });
          },
        ),

        // Day View
        Expanded(
          child: PageView.builder(
            itemCount: 7,
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                selectedDate = currentWeekDate[index];
              });
            },
            itemBuilder: (context, index) {
              final date = currentWeekDate[index];
              return DayView(date: date);
            },
          ),
        ),
      ],
    );
  }
}

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
            // DayView 전체 크기

            // Container(
            //   width: MediaQuery.of(context).size.width, // Text 크기
            //   height: totalHeight,
            //   decoration: BoxDecoration(
            //     border: Border.all(),
            //   ),
            //   child: Stack(
            //     children: [
            //       for (var eventGroup
            //           in groupOverlappingEvents(CalendarConst.events))
            //         for (var organizedEvent in getOrganizedEvents(eventGroup))
            //           Positioned(
            //             left: 95 + organizedEvent.left,
            //             top: organizedEvent.top,
            //             width: organizedEvent.width,
            //             height: organizedEvent.height,
            //             child: Container(
            //               width: organizedEvent.width,
            //               height: organizedEvent.height,
            //               decoration: const BoxDecoration(
            //                 color: Colors.blue,
            //               ),
            //             ),
            //           )
            //     ],
            //   ),
            // ),
            // 시간 블록 배경
            CustomPaint(
              size: Size(
                  MediaQuery.of(context).size.width,
                  totalHeight +
                      5), // hightOffset, textHightOffset <= 미세 조정 offset 더함
              painter: DayViewPainter(),
            ),

            Container(
              width: MediaQuery.of(context).size.width, // Text 크기
              height: totalHeight,
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: Row(
                children: [
                  // DayView 시간 텍스트 여백
                  Container(
                    width: 95, // 시간 선 시작하는 부분 좌표
                    height: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(builder: (context, constraints) {
                      final parentWidth = constraints.maxWidth;
                      final parentHeight = constraints.maxHeight;

                      for (var eventGroup
                          in groupOverlappingEvents(CalendarConst.events)) {
                        print("eventGroup: $eventGroup");
                        for (var organizedEvent
                            in getOrganizedEvents(eventGroup, parentWidth)) {
                          print(
                              "top: ${organizedEvent.top} left: ${organizedEvent.left} width: ${organizedEvent.width} height: ${organizedEvent.height}");
                        }
                      }

                      return Stack(
                        children: [
                          for (var eventGroup
                              in groupOverlappingEvents(CalendarConst.events))
                            for (var organizedEvent
                                in getOrganizedEvents(eventGroup, parentWidth))
                              Positioned(
                                left: organizedEvent.left,
                                top: organizedEvent.top,
                                width: organizedEvent.width == double.infinity
                                    ? constraints.maxWidth
                                    : organizedEvent.width,
                                height: organizedEvent.height,
                                child: Container(
                                  width: organizedEvent.width,
                                  height: organizedEvent.height,
                                  decoration: BoxDecoration(
                                    color: organizedEvent.eventData.color,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Text(
                                          organizedEvent.eventData.title,
                                          maxLines: 1,
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          organizedEvent.eventData.category
                                              .toString(),
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
              left: 80, // 시간 Text 피하고 선부터 시작하기 위해서
              right: 10,
              child: const Indicator(),
            ),
          ],
        ),
      ),
    );
  }
}

class DayViewPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 위치 미세 조정
    const double horizontalPadding = 10;
    const double hightOffset = 0; // 사용 안함
    const double textHeightOffset = 0; // 사용 안함

    const hourHeight = 60.0; // 1시간 = 60픽셀
    const hourCount = 24;

    final Paint gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1.0;

    final TextPainter textPainter = TextPainter(
      textAlign: TextAlign.right,
      textDirection: TextDirection.ltr,
    );

    const double textPadding = 65; // 텍스트와 선 사이의 여백

    final DateTime now = DateTime.now();
    final DateTime startOfDay = DateTime(now.year, now.month, now.day); // 오늘 0시
    final intl.DateFormat timeFormat = intl.DateFormat('a hh시'); // 오전/오후 HH시

    // 시간 블록과 레이블 그리기
    for (int i = 0; i <= hourCount; i++) {
      final DateTime time = startOfDay.add(Duration(hours: i));
      final y = i * hourHeight + hightOffset + textHeightOffset;

      // 시간 텍스트
      final timeText = timeFormat.format(time); // '오전 01시', '오후 12시'
      textPainter.text = TextSpan(
        text: timeText,
        style: TextStyle(
          color: Colors.grey.shade800,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      );
      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(horizontalPadding, y - textPainter.height / 2), // 텍스트를 왼쪽에 배치
      );

      // 시간 블록 선
      canvas.drawLine(
        Offset(textPadding + horizontalPadding + 20,
            y + hightOffset), // 선을 텍스트 뒤쪽에서 시작
        Offset(size.width - horizontalPadding, y + hightOffset),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// 텍스트 패딩 + dayview 패딩 + 20 = 65+10+20 = 95
// textPadding + horizontalPadding + 20,
