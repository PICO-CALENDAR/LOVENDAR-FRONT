import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pico/common/model/custom_calendar.dart';
import 'package:pico/common/model/event_controller.dart';
import 'package:pico/common/contants/calendar_const.dart';
import 'package:pico/common/schedule/model/schedule_model.dart';
import 'package:pico/common/theme/theme_light.dart';
import 'package:pico/common/utils/extenstions.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // 오늘 날짜
  // 현재 날짜
  late DateTime _currentDate;
  // 현재 인덱스
  late int _currentIndex;

  // 최소~최대 날짜 기준 총 달의 수
  int _totalMonths = 0;

  // 최소, 최대 날짜
  late DateTime _minDate;
  late DateTime _maxDate;

  late PageController _pageController;
  late List<ScheduleModel> schedule;
  late ScheduleController _scheduleController;

  Map<ScheduleType, bool> categoryCheckState = {
    ScheduleType.MINE: true,
    ScheduleType.YOURS: true,
    ScheduleType.OURS: true,
  };

  /// Sets the minimum and maximum dates for current view.
  void _setDateRange() {
    // Initialize minimum date.
    _minDate = CalendarConst.epochDate;

    // Initialize maximum date.
    _maxDate = CalendarConst.maxDate;

    assert(
      _minDate.isBefore(_maxDate),
      "Minimum date should be less than maximum date.\n"
      "Provided minimum date: $_minDate, maximum date: $_maxDate",
    );

    _totalMonths = _maxDate.getMonthDifference(_minDate);
  }

  void _regulateCurrentDate() {
    // make sure that _currentDate is between _minDate and _maxDate.
    if (_currentDate.isBefore(_minDate)) {
      _currentDate = _minDate;
    } else if (_currentDate.isAfter(_maxDate)) {
      _currentDate = _maxDate;
    }

    // Calculate the current index of page view.
    _currentIndex = _minDate.getMonthDifference(_currentDate) - 1;
  }

  // 페이지 전환 시 달 업데이트
  void _onPageChange(int value) {
    if (mounted) {
      setState(() {
        _currentDate = DateTime(
          _currentDate.year,
          _currentDate.month + (value - _currentIndex),
        );
        _currentIndex = value;
      });
    }
  }

  @override
  void initState() {
    _setDateRange();

    // Initialize current date.
    _currentDate = DateTime.now();
    _regulateCurrentDate();

    // Initialize page controller to control page actions.
    _pageController = PageController(initialPage: _currentIndex);

    // // initialize events
    // events = [];

    _scheduleController = ScheduleController(schedules: []);

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
                          _currentDate = selectedMonth!;
                          _currentIndex =
                              _minDate.getMonthDifference(selectedMonth!) - 1;

                          _pageController.jumpToPage(_currentIndex);
                          setState(() {});
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

  @override
  Widget build(BuildContext context) {
    final koreanWeekday = ["월", "화", "수", "목", "금", "토", "일"];

    return Column(
      children: [
        // 월 선택기 및 오늘로 이동 버튼
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 23,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  _monthYearPicker(context, _currentDate);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${_currentDate.year}년 ${_currentDate.month}월",
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
              SizedBox(
                width: 60,
                height: 35,
                child: TextButton(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // 둥근 직사각형
                      ),
                    ),
                  ),
                  onPressed: () {
                    _currentDate = DateTime.now();
                    _currentIndex =
                        _minDate.getMonthDifference(_currentDate) - 1;
                    _pageController.jumpToPage(_currentIndex);
                    setState(() {});
                  },
                  child: const Text(
                    '오늘',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 23,
            vertical: 3,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              const double seperatedGap = 10;
              final checkboxbtnWidth =
                  (constraints.maxWidth - seperatedGap * 2) / 3;
              return Row(
                children: [
                  CheckBoxChip(
                    label: "내 일정",
                    width: checkboxbtnWidth,
                    isChecked: categoryCheckState[ScheduleType.MINE]!,
                    color: AppTheme.getColorByScheduleType(ScheduleType.MINE),
                    accentColor: AppTheme.getDarkerColorByScheduleType(
                      ScheduleType.MINE,
                    ),
                    onPressed: () => setState(() {
                      categoryCheckState[ScheduleType.MINE] =
                          !categoryCheckState[ScheduleType.MINE]!;
                    }),
                  ),
                  const SizedBox(
                    width: seperatedGap,
                  ),
                  CheckBoxChip(
                    label: "상대 일정",
                    width: checkboxbtnWidth,
                    isChecked: categoryCheckState[ScheduleType.YOURS]!,
                    color: AppTheme.getColorByScheduleType(ScheduleType.YOURS),
                    accentColor: AppTheme.getDarkerColorByScheduleType(
                      ScheduleType.YOURS,
                    ),
                    onPressed: () => setState(() {
                      categoryCheckState[ScheduleType.YOURS] =
                          !categoryCheckState[ScheduleType.YOURS]!;
                    }),
                  ),
                  const SizedBox(
                    width: seperatedGap,
                  ),
                  CheckBoxChip(
                    label: "우리 일정",
                    width: checkboxbtnWidth,
                    isChecked: categoryCheckState[ScheduleType.OURS]!,
                    color: AppTheme.getColorByScheduleType(ScheduleType.OURS),
                    accentColor: AppTheme.getDarkerColorByScheduleType(
                      ScheduleType.OURS,
                    ),
                    onPressed: () => setState(() {
                      categoryCheckState[ScheduleType.OURS] =
                          !categoryCheckState[ScheduleType.OURS]!;
                    }),
                  ),
                ],
              );
            },
          ),
        ),

        // 요일 헤더
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int date = 0; date < 7; date++)
                Text(
                  koreanWeekday[date],
                  style: TextStyle(
                    color: date == 5
                        ? AppTheme.blueColor
                        : date == 6
                            ? AppTheme.redColor
                            : AppTheme.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        // 달력 페이지 뷰
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChange,
            itemCount: _totalMonths,
            itemBuilder: (context, index) {
              final date = DateTime(_minDate.year, _minDate.month + index);
              final monthDays = date.datesOfMonths();

              return MonthView(
                selectedMonth: date.month,
                monthDays: monthDays,
                scheduleController: _scheduleController,
                // eventController: eventController,
              );
            },
          ),
        ),
      ],
    );
  }
}

// 월간 뷰
class MonthView extends StatelessWidget {
  const MonthView({
    super.key,
    required this.selectedMonth,
    required this.monthDays,
    required this.scheduleController,
  });

  final List<DateTime> monthDays;
  final int selectedMonth;
  final ScheduleController scheduleController;
  // final EventController<EventDetail> eventController;

  List<List<DateTime>> chunkListByWeek(List<DateTime> list) {
    // 7은 일주일이 7일임을 의미

    List<List<DateTime>> chunks = [];
    for (int i = 0; i < list.length; i += 7) {
      int end = (i + 7 < list.length) ? i + 7 : list.length;
      chunks.add(list.sublist(i, end));
    }
    return chunks;
  }

  @override
  Widget build(BuildContext context) {
    final weekInMonth = chunkListByWeek(monthDays);
    return Row(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              final totalHeight = constraints.maxHeight;
              final slotWidth = totalWidth / 7;
              final dateCellSlotHeight = (totalHeight / 6) * 0.3;
              final eventCellSlotHeight = (totalHeight / 6) * 0.7;
              print(eventCellSlotHeight);

              return Column(
                children: [
                  for (var week in weekInMonth)
                    WeekRow(
                      selectedMonth: selectedMonth,
                      weekDate: week,
                      scheduleController: scheduleController,
                      slotWidth: slotWidth,
                      dateCellSlotHeight: dateCellSlotHeight,
                      totalWidth: totalWidth,
                      eventCellSlotHeight: eventCellSlotHeight,
                      isLastWeek: week == weekInMonth.last,
                    )
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

// 일주일 Row
class WeekRow extends StatelessWidget {
  const WeekRow({
    super.key,
    required this.selectedMonth,
    required this.weekDate,
    required this.scheduleController,
    required this.slotWidth,
    required this.dateCellSlotHeight,
    required this.totalWidth,
    required this.eventCellSlotHeight,
    required this.isLastWeek,
  });

  final int selectedMonth;
  final List<DateTime> weekDate;
  final ScheduleController scheduleController;
  final double slotWidth;
  final double dateCellSlotHeight;
  final double totalWidth;
  final double eventCellSlotHeight;
  final bool isLastWeek;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            for (var date in weekDate)
              DateNumberCell(
                width: slotWidth,
                height: dateCellSlotHeight,
                selectedMonth: selectedMonth,
                date: date,
                isLast: date == weekDate.last,
              ),
          ],
        ),
        Row(
          children: [
            DateScheduleRow(
              weekDate: weekDate,
              scheduleController: scheduleController,
              width: totalWidth,
              height: eventCellSlotHeight,
              selectedMonth: selectedMonth,
              slotWidth: slotWidth,
              isLastWeek: isLastWeek,
            ),
          ],
        )
      ],
    );
  }
}

// 날짜 숫자 보여지는 cell 부분
class DateNumberCell extends StatelessWidget {
  const DateNumberCell({
    super.key,
    required this.width,
    required this.height,
    required this.selectedMonth,
    required this.date,
    required this.isLast,
  });

  final double width;
  final double height;

  final int selectedMonth;
  final DateTime date;
  final bool isLast;

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
  Widget build(BuildContext context) {
    final bool isToday = date.toString() == DateTime.now().toString();
    final bool isInMonth = date.month == selectedMonth;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isInMonth
            ? Colors.transparent
            : AppTheme.scaffoldBackgroundColorDark,
        border: Border(
          top: AppTheme.borderSide,
          left: AppTheme.borderSide,
          // right:
          //     (isLast ?? false) ? const AppTheme.borderSide : BorderSide.none,
        ),
      ),
      child: Center(
        child: Container(
          alignment: Alignment.center,
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            color:
                isToday ? Theme.of(context).primaryColor : Colors.transparent,
          ),
          child: Text(
            date.day.toString(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _getDayColor(date, isInMonth, isToday),
            ),
          ),
        ),
      ),
    );
  }
}

// 이벤트 보여지는 cell 부분
class DateScheduleRow extends StatelessWidget {
  const DateScheduleRow({
    super.key,
    required this.weekDate,
    required this.scheduleController,
    required this.width,
    required this.height,
    required this.selectedMonth,
    required this.slotWidth,
    required this.isLastWeek,
  });

  final List<DateTime> weekDate;
  final ScheduleController scheduleController;
  final double width;
  final double height;
  final int selectedMonth;
  final double slotWidth;
  final bool isLastWeek;

  @override
  Widget build(BuildContext context) {
    const gap = 1;
    const maxColumn = 4;
    final eventHeight = (height - (maxColumn + 2) * gap) * 0.25;

    final orgSchedules = scheduleController.filterAndSortSchedulesForWeek(
        scheduleController.orgSchedules, weekDate.first, weekDate.last);
    // for (var event in organizeEvents(events)) {
    //   print("${event.eventData.title} : ${event.column}");
    //   print(event.eventData.startTime.isBefore(weekDate.first));
    //   print((event.eventData.startTime.weekday - 1) * slotWidth + 2);
    //   print(event.eventData.endTime.isAfter(weekDate.last));
    // }

    return SingleChildScrollView(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border(
            // left: const AppTheme.borderSide,
            // right: const AppTheme.borderSide,
            bottom: isLastWeek ? AppTheme.borderSide : BorderSide.none,
          ),
        ),
        child: Stack(
          children: [
            // 경계를 나타내는 부분
            Row(
              children: [
                for (var date in weekDate)
                  GestureDetector(
                    onTap: () {
                      print(date);
                    },
                    child: Container(
                      width: slotWidth,
                      decoration: BoxDecoration(
                        border: Border(
                          left: AppTheme.borderSide,
                        ),
                        color: date.month == selectedMonth
                            ? Colors.transparent
                            : AppTheme.scaffoldBackgroundColorDark,
                      ),
                    ),
                  ),
              ],
            ),
            for (var schedule in orgSchedules)
              schedule.column <= maxColumn
                  ? Positioned(
                      top: (schedule.column - 1) * eventHeight +
                          (gap * (schedule.column - 1)),
                      left: schedule.scheduleData.startTime
                              .isBefore(weekDate.first)
                          ? 2
                          : (schedule.scheduleData.startTime.weekday - 1) *
                                  slotWidth +
                              2,
                      right:
                          schedule.scheduleData.endTime.isAfter(weekDate.last)
                              ? 2
                              : (7 - (schedule.scheduleData.endTime.weekday)) *
                                      slotWidth +
                                  2,
                      child: IgnorePointer(
                        ignoring: true,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                          ),
                          decoration: BoxDecoration(
                            color: schedule.scheduleData.color,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    schedule.scheduleData.title,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              (schedule.column == maxColumn &&
                                      scheduleController
                                              .getSchedulesForDate(schedule
                                                  .scheduleData.startTime)
                                              .length >
                                          maxColumn)
                                  ? Expanded(
                                      child: Text(
                                        "+${scheduleController.getSchedulesForDate(schedule.scheduleData.startTime).length - maxColumn}",
                                        style: const TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink()
          ],
        ),
      ),
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
            horizontal: 8,
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
