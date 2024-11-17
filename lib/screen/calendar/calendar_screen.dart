import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pico/theme/theme_light.dart';

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

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final koreanWeekdays = [
    '월',
    '화',
    '수',
    '목',
    '금',
    '토',
    '일',
  ];
  // late List<CalendarEventData> _events;
  List<CustomEvent> events = [];
  final now = DateTime.now();
  DateTime selectedDate = DateTime.now();

  Color _getDayColor(DateTime date, bool isInMonth, bool isToday) {
    String dayOfWeek = DateFormat.E("en-us").format(date); // 요일을 구합니다.

    // 요일에 따라 색상 반환
    if (isToday) {
      return Colors.white;
    } else if (dayOfWeek == "Sat") {
      return AppTheme.blueColor.withOpacity(isInMonth ? 1 : 0.5); // 토요일은 파란색
    } else if (dayOfWeek == "Sun") {
      return AppTheme.redColor.withOpacity(isInMonth ? 1 : 0.5); // 일요일은 빨간색
    } else {
      return AppTheme.textColor
          .withOpacity(isInMonth ? 1 : 0.5); // 평일은 기본 텍스트 색상
    }
  }

  @override
  void initState() {
    super.initState();
    events = [
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // const SizedBox(
        //   height: 40,
        //   child: Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 16),
        //     child: Row(
        //       children: [
        //         Text(
        //           "달력",
        //           // '${date.year}년 ${date.month}월',
        //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double availableHeight = constraints.maxHeight;
              double availableWidth = constraints.maxWidth;

              // print('Screen Height: ${MediaQuery.of(context).size.height}');
              // print("availableHeight $availableHeight");

              return MonthView<CustomEvent>(
                cellAspectRatio: availableWidth /
                    (availableHeight +
                        144 -
                        kBottomNavigationBarHeight -
                        40 -
                        50 +
                        10),
                controller: EventController<CustomEvent>(
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

                borderSize: 0.5,
                borderColor: Colors.grey[300]!,

                headerBuilder: (date) {
                  return SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              monthYearPicker(context, date);
                            },
                            child: Row(
                              children: [
                                Text(
                                  '${date.year}년 ${date.month}월',
                                  style: const TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 3),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 27,
                                  color: AppTheme.textColor,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },

                // headerBuilder: MonthHeader.hidden,
                weekDayBuilder: (date) {
                  // return const SizedBox.shrink();
                  return Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      koreanWeekdays[date],
                      style: TextStyle(
                        color: date == 5
                            ? AppTheme.blueColor
                            : date == 6
                                ? AppTheme.redColor
                                : AppTheme.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
                cellBuilder:
                    (date, event, isToday, isInMonth, hideDaysNotInMonth) {
                  return Container(
                    color: isInMonth
                        ? Colors.transparent
                        : AppTheme.scaffoldBackgroundColorDark,
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                    child: Column(
                      children: [
                        Container(
                          width: 23,
                          height: 23,
                          decoration: BoxDecoration(
                            color: isToday
                                ? Theme.of(context).primaryColor
                                : Colors.transparent, // 배경색
                            borderRadius: const BorderRadius.all(
                                Radius.circular(50)), // 원형 모양으로 만들기
                          ),
                          child: Center(
                            child: Text(
                              DateFormat.d('en_US').format(date),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _getDayColor(date, isInMonth, isToday),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                for (var e in event)
                                  Text(
                                    e.title,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }

  Future<dynamic> monthYearPicker(BuildContext context, DateTime date) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 350, // 버튼과 선택기를 위한 충분한 높이
          child: Column(
            children: [
              // 취소 및 확인 버튼이 있는 Row
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: const Text(
                        '취소',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // 모달 닫기
                      },
                    ),
                    CupertinoButton(
                      child: const Text(
                        '확인',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        // 확인 시 처리할 로직
                        Navigator.pop(context); // 모달 닫기
                      },
                    ),
                  ],
                ),
              ),
              // 연도와 월만 선택할 수 있는 CupertinoDatePicker
              Flexible(
                child: CupertinoDatePicker(
                  initialDateTime:
                      DateTime(date.year, date.month, 1), // 연도와 월만 선택하고 1일로 고정
                  mode: CupertinoDatePickerMode.monthYear,
                  maximumDate: DateTime.now(), // 최대 날짜를 오늘로 제한
                  onDateTimeChanged: (DateTime newDate) {
                    // 날짜 변경 시 연도와 월만 업데이트
                    setState(() {
                      // 예시: _selectedDate = DateTime(newDate.year, newDate.month, 1);
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
