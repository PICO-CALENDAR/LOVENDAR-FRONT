import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pico/calendar/components/month_view.dart';
import 'package:pico/calendar/provider/checked_category_provider.dart';
import 'package:pico/common/components/check_box_chip.dart';
import 'package:pico/common/model/event_controller.dart';
import 'package:pico/common/contants/calendar_const.dart';
import 'package:pico/common/schedule/model/schedule_model.dart';
import 'package:pico/common/schedule/provider/schedules_provider.dart';
import 'package:pico/common/schedule/repository/schedule_repository.dart';
import 'package:pico/common/theme/theme_light.dart';
import 'package:pico/common/utils/extenstions.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  static String get routeName => 'calendar';
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
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
  // late ScheduleController _scheduleController;

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
      final updatedDate = DateTime(
        _currentDate.year,
        _currentDate.month + (value - _currentIndex),
      );
      if (_currentDate.year != updatedDate.year) {
        ref
            .read(schedulesProvider.notifier)
            .refreshSchedules(year: updatedDate.year);
      }
      setState(() {
        _currentDate = updatedDate;
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

    final schedules = ref.read(schedulesProvider);
    if (schedules.isEmpty) {
      ref.read(schedulesProvider.notifier).refreshSchedules();
    }

    // Initialize page controller to control page actions.
    _pageController = PageController(initialPage: _currentIndex);

    // // initialize events
    // events = [];

    // _scheduleController = ScheduleController(schedules: []);

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
    final categoryCheckedState = ref.watch(checkedCategoryProvider);

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
                      isChecked: categoryCheckedState[ScheduleType.MINE]!,
                      color: AppTheme.getColorByScheduleType(ScheduleType.MINE),
                      accentColor: AppTheme.getDarkerColorByScheduleType(
                        ScheduleType.MINE,
                      ),
                      onPressed: () => ref
                          .read(checkedCategoryProvider.notifier)
                          .toggleCategory(ScheduleType.MINE)),
                  const SizedBox(
                    width: seperatedGap,
                  ),
                  CheckBoxChip(
                    label: "상대 일정",
                    width: checkboxbtnWidth,
                    isChecked: categoryCheckedState[ScheduleType.YOURS]!,
                    color: AppTheme.getColorByScheduleType(ScheduleType.YOURS),
                    accentColor: AppTheme.getDarkerColorByScheduleType(
                      ScheduleType.YOURS,
                    ),
                    onPressed: () => ref
                        .read(checkedCategoryProvider.notifier)
                        .toggleCategory(ScheduleType.YOURS),
                  ),
                  const SizedBox(
                    width: seperatedGap,
                  ),
                  CheckBoxChip(
                    label: "우리 일정",
                    width: checkboxbtnWidth,
                    isChecked: categoryCheckedState[ScheduleType.OURS]!,
                    color: AppTheme.getColorByScheduleType(ScheduleType.OURS),
                    accentColor: AppTheme.getDarkerColorByScheduleType(
                      ScheduleType.OURS,
                    ),
                    onPressed: () => ref
                        .read(checkedCategoryProvider.notifier)
                        .toggleCategory(ScheduleType.OURS),
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
            allowImplicitScrolling: false,
            itemBuilder: (context, index) {
              final date = DateTime(_minDate.year, _minDate.month + index);

              return MonthView(
                selectedMonth: date.month,
                monthDays: date.datesOfMonths(),
                // scheduleController: _scheduleController,
                // eventController: eventController,
              );
            },
          ),
        ),
      ],
    );
  }
}
