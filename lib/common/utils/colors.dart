import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pico/common/theme/theme_light.dart';

Color getDayColor(DateTime date, bool isToday) {
  String dayOfWeek = DateFormat.E("en-us").format(date); // 요일을 구합니다.

  // 요일에 따라 색상 반환
  if (isToday) {
    return Colors.white;
  } else if (dayOfWeek == "Sat") {
    return AppTheme.blueColor.withOpacity(1); // 토요일은 파란색
  } else if (dayOfWeek == "Sun") {
    return AppTheme.redColor.withOpacity(1); // 일요일은 빨간색
  } else {
    return AppTheme.textColor.withOpacity(1); // 평일은 기본 텍스트 색상
  }
}
