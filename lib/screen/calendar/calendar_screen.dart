import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kalender/kalender.dart';
import 'package:pico/classes/custom_calendar.dart';
import 'package:pico/components/common/round_checkbox.dart';
import 'package:pico/contants/calendar_const.dart';
import 'package:pico/theme/theme_light.dart';
import 'package:pico/utils/extenstions.dart';
import 'package:pico/utils/colors.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final eventsController = CalendarEventsController<EventData>();
  late CalendarController<EventData> _calendarController;
  // Widget _tileBuilder(event, tileConfiguration) => const Widget();
  // Widget _multiDayTileBuilder(event, tileConfiguration) => const Widget();
  // Widget _scheduleTileBuilder(event, date) => const Widget();

  @override
  void initState() {
    final eventsObj = [
      for (var event in CalendarConst.calEvent)
        CalendarEvent<EventData>(
          dateTimeRange: DateTimeRange(
            start: event.startTime,
            end: event.endTime,
          ), // The DateTimeRange of the event.
          modifiable:
              true, // Change this to false if you do not want the user to modify the event.
          eventData: event,
        )
    ];

    eventsController.addEvents(eventsObj);

    // _currentDate = DateTime.now();
    _calendarController = CalendarController<EventData>();
    super.initState();
  }

  final koreanWeekday = ["월", "화", "수", "목", "금", "토", "일"];

  Map<EventCategory, bool> categoryCheckState = {
    EventCategory.mine: false,
    EventCategory.yours: false,
    EventCategory.ours: false,
  };

  @override
  Widget build(BuildContext context) {
    // 캘린더 스타일
    var calendarStyle = CalendarStyle(
      monthGridStyle: MonthGridStyle(
        color: Colors.grey[200],
        thickness: 1.2,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      calendarHeaderBackgroundStyle: CalendarHeaderBackgroundStyle(
        headerBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // headerSurfaceTintColor:
        //     Theme.of(context).scaffoldBackgroundColor,
        headerElevation: 0,
      ),
    );

    return Column(
      children: [
        Expanded(
          child: CalendarView<EventData>.month(
            style: calendarStyle,
            components: CalendarComponents(
              // 캘린더 헤더 빌더 (월 picker와 오늘 버튼)
              calendarHeaderBuilder: (visibleDateTimeRange) =>
                  _calendarHeaderBuilder(context),
              // 요일 헤더 빌더
              monthHeaderBuilder: (date) => _monthHeaderBuilder(date),
              // 날짜 숫자 빌더
              monthCellHeaderBuilder: (date, onTapped) {
                final isToday = date.isSameDate(DateTime.now());
                return _monthCellHeaderBuilder(isToday, context, date);
              },
            ),
            controller: _calendarController,
            eventHandlers: const CalendarEventHandlers(),
            eventsController: eventsController,
            viewConfiguration: MonthConfiguration(
              firstDayOfWeek: 1,
              multiDayTileHeight: 20,
              createMultiDayEvents: true,
            ),
            multiDayTileBuilder: (event, configuration) =>
                _multiDayTileBuilder(event),
          ),
        ),
      ],
    );
  }

  Padding _multiDayTileBuilder(CalendarEvent<EventData> event) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(3.5)),
          color: event.eventData!.color,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            event.eventData!.title,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Padding _monthCellHeaderBuilder(
      bool isToday, BuildContext context, DateTime date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        width: 22,
        height: 22,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isToday ? Theme.of(context).primaryColor : Colors.transparent,
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
  }

  SizedBox _monthHeaderBuilder(DateTime date) {
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
  }

  Padding _calendarHeaderBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 월 선택 버튼
              GestureDetector(
                onTap: () {
                  _monthYearPicker(
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
          const SizedBox(
            height: 5,
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              const seperatedGap = 5.0;
              final checkboxbtnWidth =
                  (constraints.maxWidth - seperatedGap * 2) / 3;
              return Row(
                children: [
                  CheckBoxChip(
                    label: "내 일정",
                    width: checkboxbtnWidth,
                    isChecked: categoryCheckState[EventCategory.mine]!,
                    color: AppTheme.getEventCategoryColor(EventCategory.mine),
                    accentColor: AppTheme.getEventCategoryDarkerColor(
                      EventCategory.mine,
                    ),
                    onPressed: () => setState(() {
                      categoryCheckState[EventCategory.mine] =
                          !categoryCheckState[EventCategory.mine]!;
                    }),
                  ),
                  const SizedBox(
                    width: seperatedGap,
                  ),
                  CheckBoxChip(
                    label: "상대 일정",
                    width: checkboxbtnWidth,
                    isChecked: categoryCheckState[EventCategory.yours]!,
                    color: AppTheme.getEventCategoryColor(EventCategory.yours),
                    accentColor: AppTheme.getEventCategoryDarkerColor(
                      EventCategory.yours,
                    ),
                    onPressed: () => setState(() {
                      categoryCheckState[EventCategory.yours] =
                          !categoryCheckState[EventCategory.yours]!;
                    }),
                  ),
                  const SizedBox(
                    width: seperatedGap,
                  ),
                  CheckBoxChip(
                    label: "우리 일정",
                    width: checkboxbtnWidth,
                    isChecked: categoryCheckState[EventCategory.ours]!,
                    color: AppTheme.getEventCategoryColor(EventCategory.ours),
                    accentColor: AppTheme.getEventCategoryDarkerColor(
                      EventCategory.ours,
                    ),
                    onPressed: () => setState(() {
                      categoryCheckState[EventCategory.ours] =
                          !categoryCheckState[EventCategory.ours]!;
                    }),
                  ),
                ],
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Future<dynamic> _monthYearPicker(BuildContext context, DateTime date) {
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

class CheckBoxChip extends StatelessWidget {
  const CheckBoxChip({
    super.key,
    required this.width,
    this.height = 38.0,
    required this.label,
    required this.isChecked,
    required this.color,
    required this.onPressed,
    this.accentColor = Colors.grey,
    this.selectedColor = AppTheme.scaffoldBackgroundColor,
    this.unselectedColor = Colors.grey,
  });

  final double width;
  final double height;
  final String label;
  final bool isChecked;
  final Color color;
  final Color selectedColor;
  final Color unselectedColor;
  final Color accentColor;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          surfaceTintColor: color,
          elevation: 1,
          shadowColor: Colors.transparent,
          overlayColor: accentColor,
          // shadowColor: Colors.grey[50],
          padding: const EdgeInsets.symmetric(
            vertical: 3,
            horizontal: 12,
          ),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // 둥근 모서리 반경
          ),
        ),
        onPressed: onPressed,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(0.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: accentColor,
                  width: 1.5,
                ),
                color: isChecked ? accentColor : Colors.transparent,
              ),
              child: Icon(
                Icons.check_rounded,
                size: 16,
                color: isChecked ? selectedColor : Colors.transparent,
              ),
            ),
            const SizedBox(
              width: 7,
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
