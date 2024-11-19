import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pico/classes/custom_arranger.dart';
import 'package:pico/classes/custom_calendar.dart';
import 'package:pico/classes/pico_arranger.dart';
import 'package:pico/screen/calendar/calendar_screen.dart';
import 'package:pico/theme/theme_light.dart';
import 'dart:async';

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
  late List<CalendarEventData<EventDetail>> _events;
  // List<CustomEvent> events = [];

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
    // events = [
    //   CustomEvent(
    //     category: "me",
    //     startTime: DateTime(2024, 11, 17, 10, 0),
    //     endTime: DateTime(2024, 11, 17, 11, 0),
    //     title: '회의',
    //     repeat: 'daily', // 매일 반복
    //   ),
    //   CustomEvent(
    //     category: "me",
    //     startTime: DateTime(2024, 11, 17, 13, 0),
    //     endTime: DateTime(2024, 11, 17, 14, 0),
    //     title: '테스트',
    //     repeat: 'daily', // 매일 반복
    //   ),
    //   CustomEvent(
    //     category: "me",
    //     startTime: DateTime(2024, 11, 17, 14, 0),
    //     endTime: DateTime(2024, 11, 17, 16, 0),
    //     title: '약속',
    //     repeat: 'daily', // 매일 반복
    //   ),
    //   CustomEvent(
    //     category: "partner",
    //     startTime: DateTime(2024, 11, 17, 10, 0),
    //     endTime: DateTime(2024, 11, 17, 17, 0),
    //     title: '상대방',
    //     repeat: 'daily', // 매월 반복
    //   ),
    // ];

    _events = [
      CalendarEventData(
          date: now,
          title: "테스트",
          description: "나의 일정",
          color: Colors.amber,
          startTime: DateTime(now.year, now.month, now.day, 2, 0),
          endTime: DateTime(now.year, now.month, now.day, 3, 0),
          event: EventDetail(category: EventCategory.mine)),
      // CalendarEventData(
      //     date: now,
      //     title: "테스트",
      //     description: "너의 일정",
      //     color: Colors.green,
      //     startTime: DateTime(now.year, now.month, now.day, 2, 0),
      //     endTime: DateTime(now.year, now.month, now.day, 3, 0),
      //     event: EventDetail(category: EventCategory.yours)),
      CalendarEventData(
          date: now,
          title: "테스트",
          description: "나의 일정",
          color: Colors.amber,
          startTime: DateTime(now.year, now.month, now.day, 10, 0),
          endTime: DateTime(now.year, now.month, now.day, 11, 0),
          event: EventDetail(category: EventCategory.mine)),

      CalendarEventData(
        date: now,
        title: "회의",
        description: "나의 일정",
        color: Colors.amber,
        startTime: DateTime(now.year, now.month, now.day, 13, 00),
        endTime: DateTime(now.year, now.month, now.day, 14, 00),
        event: EventDetail(category: EventCategory.mine),
      ),
      CalendarEventData(
        date: now,
        title: "약속",
        description: "나의 일정",
        color: Colors.amber,
        startTime: DateTime(now.year, now.month, now.day, 14, 00),
        endTime: DateTime(now.year, now.month, now.day, 16, 00),
        event: EventDetail(category: EventCategory.mine),
      ),
      CalendarEventData(
        date: now,
        title: "약속22",
        description: "나의 일정",
        color: Colors.amber,
        startTime: DateTime(now.year, now.month, now.day, 10, 00),
        endTime: DateTime(now.year, now.month, now.day, 16, 00),
        event: EventDetail(category: EventCategory.mine),
      ),
      CalendarEventData(
        date: now,
        description: "너의 일정",
        startTime: DateTime(now.year, now.month, now.day, 10),
        endTime: DateTime(now.year, now.month, now.day, 17),
        title: "meeting",
        color: Colors.green,
        event: EventDetail(category: EventCategory.yours),
      ),

      CalendarEventData(
        date: now,
        title: "약속22",
        description: "나의 일정",
        color: Colors.amber,
        startTime: DateTime(now.year, now.month, now.day, 6, 00),
        endTime: DateTime(now.year, now.month, now.day, 7, 00),
        event: EventDetail(category: EventCategory.mine),
      ),
      CalendarEventData(
        date: now,
        title: "약속22",
        description: "나의 일정",
        color: Colors.amber,
        startTime: DateTime(now.year, now.month, now.day, 6, 00),
        endTime: DateTime(now.year, now.month, now.day, 7, 00),
        event: EventDetail(category: EventCategory.mine),
      ),
      // CalendarEventData(
      //   date: now,
      //   description: "너의 일정",
      //   startTime: DateTime(now.year, now.month, now.day, 6),
      //   endTime: DateTime(now.year, now.month, now.day, 7),
      //   title: "meeting",
      //   color: Colors.green,
      //   event: EventDetail(category: EventCategory.yours),
      // ),
      CalendarEventData(
        date: now,
        startTime: DateTime(now.year, now.month, now.day, 6),
        endTime: DateTime(now.year, now.month, now.day, 7),
        title: "meeting",
        description: "우리의 일정",
        color: Colors.grey,
        event: EventDetail(category: EventCategory.ours),
      ),

      CalendarEventData(
        title: "All Day Event",
        description: "This is an all-day event.",
        date: DateTime(2024, 11, 20), // 이벤트 날짜
        event: EventDetail(category: EventCategory.mine), // 23:59 종료
      ),
      CalendarEventData(
        title: "All Day Event",
        description: "This is an all-day event.",
        date: DateTime(2024, 11, 20), // 이벤트 날짜
        event: EventDetail(category: EventCategory.mine), // 23:59 종료
      ),

      CalendarEventData(
        date: now,
        startTime: DateTime(now.year, now.month, now.day, 2),
        endTime: DateTime(now.year, now.month, now.day, 4),
        title: "meeting",
        description: "너의 일정",
        color: Colors.green,
        event: EventDetail(category: EventCategory.yours),
      ),
    ];
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
            child: DayView<EventDetail>(
              onEventTap: (events, date) {},
              controller: EventController()..addAll(_events),
              // controller: EventController(
              //   eventFilter: (date, allEvents) {
              //     // 주어진 날짜에 맞는 반복 이벤트 필터링
              //     final filteredEvents = events.where((customEvent) {
              //       if (customEvent.repeat == 'daily') {
              //         return true; // 매일 반복되는 이벤트는 모든 날짜에 포함
              //       } else if (customEvent.repeat == 'weekly') {
              //         return customEvent.startTime.weekday ==
              //             date.weekday; // 주 단위 반복
              //       } else if (customEvent.repeat == 'monthly') {
              //         return customEvent.startTime.day == date.day; // 월 단위 반복
              //       }
              //       return false;
              //     }).toList();

              //     // CalendarEventData로 변환하여 반환
              //     return filteredEvents.map((e) {
              //       return CalendarEventData<CustomEvent>(
              //         date: date,
              //         event: e,
              //         startTime: e.startTime,
              //         endTime: e.endTime,
              //         title: e.title,
              //         description: e.category,
              //       );
              //     }).toList();
              //   },
              // ),
              // controller: EventController()..addAll(_events),
              backgroundColor: AppTheme.scaffoldBackgroundColor,
              timeLineWidth: 60,
              heightPerMinute: 1,
              showVerticalLine: false,
              dayTitleBuilder: DayHeader.hidden,

              // eventArranger: const CustomArranger(),
              eventArranger: PicoArranger(),
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
