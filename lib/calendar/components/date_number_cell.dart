// 날짜 숫자 보여지는 cell 부분
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lovendar/common/theme/theme_light.dart';
import 'package:lovendar/common/utils/extenstions.dart';
import 'package:lovendar/common/view/edit_schedule_screen.dart';

class DateNumberCell extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isToday = date.isSameDate(DateTime.now());
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
