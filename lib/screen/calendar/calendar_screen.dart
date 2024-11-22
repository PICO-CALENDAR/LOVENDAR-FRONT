import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:pico/theme/theme_light.dart';
import 'package:pico/utils/extenstions.dart';
import 'package:pico/utils/colors.dart';

class Event {
  String title;
  Color color;

  Event({
    required this.title,
    required this.color,
  });
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final eventsController = CalendarEventsController<Event>();
  late CalendarController<Event> _calendarController;

  // Widget _tileBuilder(event, tileConfiguration) => const Widget();
  // Widget _multiDayTileBuilder(event, tileConfiguration) => const Widget();
  // Widget _scheduleTileBuilder(event, date) => const Widget();

  @override
  void initState() {
    eventsController.addEvent(
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now(),
        ), // The DateTimeRange of the event.
        modifiable:
            true, // Change this to false if you do not want the user to modify the event.
        eventData: Event(
          // The custom object that you want to link to the event.
          title: 'Event 1',
          color: Colors.blue,
        ),
      ),
    );
    eventsController.addEvent(
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
            start: DateTime.now(),
            end: DateTime(
              2024,
              11,
              24,
            )), // The DateTimeRange of the event.
        modifiable:
            true, // Change this to false if you do not want the user to modify the event.
        eventData: Event(
          // The custom object that you want to link to the event.
          title: 'Event 1',
          color: Colors.blue,
        ),
      ),
    );
    eventsController.addEvent(
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
          start: DateTime(
            2024,
            11,
            20,
          ),
          end: DateTime(
            2024,
            12,
            23,
          ),
        ), // The DateTimeRange of the event.
        modifiable:
            true, // Change this to false if you do not want the user to modify the event.
        eventData: Event(
          // The custom object that you want to link to the event.
          title: 'ㅁㄴㅇㄹ',
          color: Colors.blue,
        ),
      ),
    );
    eventsController.addEvent(
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
          start: DateTime(
            2024,
            11,
            24,
          ),
          end: DateTime(
            2024,
            12,
            24,
          ),
        ), // The DateTimeRange of the event.
        modifiable:
            true, // Change this to false if you do not want the user to modify the event.
        eventData: Event(
          // The custom object that you want to link to the event.
          title: 'Event 1',
          color: Colors.blue,
        ),
      ),
    );
    eventsController.addEvent(
      CalendarEvent<Event>(
        dateTimeRange: DateTimeRange(
            start: DateTime.now(),
            end: DateTime(
              2024,
              11,
              24,
            )), // The DateTimeRange of the event.
        modifiable:
            true, // Change this to false if you do not want the user to modify the event.
        eventData: Event(
          // The custom object that you want to link to the event.
          title: 'Event 1',
          color: Colors.blue,
        ),
      ),
    );

    // _currentDate = DateTime.now();
    _calendarController = CalendarController<Event>();
    super.initState();
  }

  final koreanWeekday = ["월", "화", "수", "목", "금", "토", "일"];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CalendarView<Event>.month(
            style: CalendarStyle(
              monthGridStyle: MonthGridStyle(
                color: Colors.grey[200],
                thickness: 1.2,
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              calendarHeaderBackgroundStyle: CalendarHeaderBackgroundStyle(
                headerBackgroundColor:
                    Theme.of(context).scaffoldBackgroundColor,
                // headerSurfaceTintColor:
                //     Theme.of(context).scaffoldBackgroundColor,
                headerElevation: 0,
              ),
            ),
            components: CalendarComponents(
              calendarHeaderBuilder: (visibleDateTimeRange) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 7,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 월 선택 버튼
                      GestureDetector(
                        onTap: () {
                          monthYearPicker(
                            context,
                            _calendarController.visibleMonth ?? DateTime.now(),
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${_calendarController.visibleMonth?.year ?? DateTime.now().year}년 ${_calendarController.visibleMonth?.month ?? DateTime.now().month}월",
                              style: const TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 26,
                              color: AppTheme.textColor,
                            )
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _calendarController.animateToDate(DateTime.now());
                        },
                        child: const Text(
                          '오늘',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              monthHeaderBuilder: (date) {
                return SizedBox(
                  height: 35,
                  child: Text(
                    koreanWeekday[date.weekday - 1],
                    style: TextStyle(
                      color: date.weekday == 6
                          ? AppTheme.blueColor
                          : date.weekday == 7
                              ? AppTheme.redColor
                              : AppTheme.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                );
              },
              monthCellHeaderBuilder: (date, onTapped) {
                final isToday = date.isSameDate(DateTime.now());

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Container(
                    width: 22,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isToday
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: getDayColor(date, isToday),
                      ),
                    ),
                  ),
                );
              },
            ),
            controller: _calendarController,
            eventsController: eventsController,

            viewConfiguration: MonthConfiguration(
              name: 'Month',
              firstDayOfWeek: 1,
              multiDayTileHeight: 20,
              createMultiDayEvents: true,
            ),

            // multiDayEventTileBuilder: (event,
            //     configuration,
            //     rescheduleDateRange,
            //     horizontalStep,
            //     horizontalStepDuration,
            //     verticalStepDuration,
            //     verticalStep) {
            //   return Container(
            //     decoration: BoxDecoration(
            //       borderRadius: const BorderRadius.all(Radius.circular(6)),
            //       color: event.eventData!.color,
            //     ),
            //   );
            // },

            multiDayTileBuilder: (event, configuration) {
              return Padding(
                padding: const EdgeInsets.all(1),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    color: event.eventData!.color,
                  ),
                  child: Center(
                    child: Text(
                      event.eventData!.title,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<dynamic> monthYearPicker(BuildContext context, DateTime date) {
    DateTime? selectedMonth;
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
                        if (selectedMonth != null) {
                          _calendarController.animateToDate(selectedMonth!);
                        }
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
                  onDateTimeChanged: (DateTime newDate) {
                    // 날짜 변경 시 연도와 월만 업데이트
                    selectedMonth = DateTime(newDate.year, newDate.month, 1);
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
