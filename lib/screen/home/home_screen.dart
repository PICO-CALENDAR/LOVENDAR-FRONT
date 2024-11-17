import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pico/classes/custom_arranger.dart';
import 'package:pico/theme/theme_light.dart';
import 'dart:async';

class CustomEvent {
  DateTime startTime;
  DateTime endTime;
  String title;
  String repeat; // 반복 유형: daily, weekly, monthly
  String category;

  CustomEvent({
    required this.startTime,
    required this.endTime,
    required this.title,
    required this.repeat,
    required this.category,
  });

  // 특정 날짜에 이벤트가 있는지 확인하는 메서드
  bool isEventOnDate(DateTime date) {
    if (repeat == 'daily') {
      // 매일 반복: 날짜만 확인
      return startTime.day == date.day &&
          startTime.month == date.month &&
          startTime.year == date.year;
    } else if (repeat == 'weekly') {
      // 매주 반복: 요일과 날짜가 일치하는지 확인
      return startTime.weekday == date.weekday &&
          startTime.year == date.year &&
          startTime.month == date.month;
    } else if (repeat == 'monthly') {
      // 매월 반복: 날짜가 일치하는지 확인
      return startTime.day == date.day &&
          startTime.month == date.month &&
          startTime.year == date.year;
    }
    return false;
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DateTime now = DateTime.now();
  late DateTime selectedDate;
  // late Timer _timer;
  late DateTime currentTime;
  // late List<CalendarEventData> _events;
  List<CustomEvent> events = [];

  List<DateTime> getCurrentWeekDates() {
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  @override
  void initState() {
    super.initState();
    selectedDate = now;
    currentTime = DateTime.now();
    // 매 분마다 현재 시각 갱신
    // _timer = Timer.periodic(const Duration(minutes: 1), (Timer t) {
    //   setState(() {
    //     currentTime = DateTime.now();
    //   });
    // });
    events = [
      CustomEvent(
        category: "me",
        startTime: DateTime(2024, 11, 17, 10, 0),
        endTime: DateTime(2024, 11, 17, 11, 0),
        title: '매일 회의',
        repeat: 'daily', // 매일 반복
      ),
      CustomEvent(
        category: "me",
        startTime: DateTime(2024, 11, 17, 10, 0),
        endTime: DateTime(2024, 11, 17, 11, 0),
        title: '매일 회의',
        repeat: 'daily', // 매일 반복
      ),
      CustomEvent(
        category: "partner",
        startTime: DateTime(2024, 11, 17, 14, 0),
        endTime: DateTime(2024, 11, 17, 15, 0),
        title: '주간 미팅',
        repeat: 'weekly', // 매주 반복
      ),
      CustomEvent(
        category: "us",
        startTime: DateTime(2024, 11, 17, 16, 0),
        endTime: DateTime(2024, 11, 17, 17, 0),
        title: '매월 회의',
        repeat: 'monthly', // 매월 반복
      ),
    ];

    // _events = [
    //   CalendarEventData(
    //     date: now,
    //     title: "test meeting",
    //     color: Colors.amber,
    //     description: "me",
    //     startTime: DateTime(now.year, now.month, now.day, 10, 30),
    //     endTime: DateTime(now.year, now.month, now.day, 12, 30),
    //   ),
    //   CalendarEventData(
    //     date: now,
    //     title: "mee",
    //     color: Colors.amber,
    //     description: "me",
    //     startTime: DateTime(now.year, now.month, now.day, 10, 00),
    //     endTime: DateTime(now.year, now.month, now.day, 12, 30),
    //   ),
    //   CalendarEventData(
    //     date: now,
    //     title: "ㅇㅇ",
    //     color: Colors.amber,
    //     description: "me",
    //     startTime: DateTime(now.year, now.month, now.day, 10, 00),
    //     endTime: DateTime(now.year, now.month, now.day, 12, 30),
    //   ),
    //   CalendarEventData(
    //     date: now,
    //     startTime: DateTime(now.year, now.month, now.day, 14),
    //     endTime: DateTime(now.year, now.month, now.day, 17),
    //     title: "meeting",
    //     description: "partner",
    //     color: Colors.green,
    //   ),
    //   CalendarEventData(
    //     date: now,
    //     startTime: DateTime(now.year, now.month, now.day, 8),
    //     endTime: DateTime(now.year, now.month, now.day, 10),
    //     title: "tournament",
    //     description: "partner",
    //     color: Colors.green,
    //   ),
    //   CalendarEventData(
    //     date: now,
    //     startTime: DateTime(now.year, now.month, now.day, 14),
    //     endTime: DateTime(now.year, now.month, now.day, 16),
    //     title: "asdfasdfadfa",
    //     description: "partner",
    //     color: Colors.green,
    //   ),
    //   CalendarEventData(
    //     date: now,
    //     startTime: DateTime(now.year, now.month, now.day, 14),
    //     endTime: DateTime(now.year, now.month, now.day, 16),
    //     title: "dd",
    //     description: "partner",
    //     color: Colors.green,
    //   ),
    //   CalendarEventData(
    //     date: now,
    //     startTime: DateTime(now.year, now.month, now.day, 14),
    //     endTime: DateTime(now.year, now.month, now.day, 16),
    //     title: "us",
    //     description: "us",
    //     color: Colors.blue,
    //   ),
    // ];
  }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }

  double _calculateCurrentTimePosition() {
    // 시간대별 슬롯의 높이를 기준으로 현재 시각의 위치 계산
    double slotHeight = 60; // 각 시간 슬롯 높이
    int totalMinutes = currentTime.hour * 60 + currentTime.minute;
    return (totalMinutes / 60) * slotHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text(
                  DateFormat.yMMM().format(DateTime.now()),
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (var date in getCurrentWeekDates())
                Expanded(
                  child: DateWidget(
                    date: date,
                    isSelected: date.day == selectedDate.day &&
                        date.month == selectedDate.month &&
                        date.year == selectedDate.year,
                    onTap: () {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: DayView<CustomEvent>(
              onEventTap: (events, date) {},
              controller: EventController(
                eventFilter: (date, allEvents) {
                  // 주어진 날짜에 맞는 반복 이벤트 필터링
                  final filteredEvents = events.where((customEvent) {
                    if (customEvent.repeat == 'daily') {
                      return true; // 매일 반복되는 이벤트는 모든 날짜에 포함
                    } else if (customEvent.repeat == 'weekly') {
                      return customEvent.startTime.weekday ==
                          date.weekday; // 주 단위 반복
                    } else if (customEvent.repeat == 'monthly') {
                      return customEvent.startTime.day == date.day; // 월 단위 반복
                    }
                    return false;
                  }).toList();

                  // CalendarEventData로 변환하여 반환
                  return filteredEvents.map((e) {
                    return CalendarEventData<CustomEvent>(
                      date: date,
                      event: e,
                      startTime: e.startTime,
                      endTime: e.endTime,
                      title: e.title,
                      description: e.category,
                    );
                  }).toList();
                },
              ),
              // controller: EventController()..addAll(_events),
              backgroundColor: AppTheme.scaffoldBackgroundColor,
              timeLineWidth: 60,
              heightPerMinute: 1,
              showVerticalLine: false,
              dayTitleBuilder: DayHeader.hidden,
              eventArranger: const CustomArranger(),
              timeLineBuilder: (date) {
                return Text(
                  DateFormat("a h시").format(date),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DateWidget extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  const DateWidget({
    super.key,
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.5),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat.d('en_US').format(date),
                style: TextStyle(
                  fontSize: 18.5,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
              Text(
                DateFormat("E", 'ko').format(date),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
