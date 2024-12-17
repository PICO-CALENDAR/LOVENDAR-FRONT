import 'package:pico/common/model/custom_calendar.dart';

class CalendarConst {
  // 생성자 안되는 클래스인듯?
  CalendarConst._();

  /// minimum and maximum dates are approx. 100,000,000 days
  /// before and after epochDate
  static final DateTime epochDate = DateTime(1970);
  static final DateTime maxDate = DateTime(275759);
  static final DateTime minDate = DateTime(-271819);

  static const int hOURSADay = 24;
  static const int minutesADay = 1440;
}
