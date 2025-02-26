import 'package:lovendar/common/schedule/model/schedule_model.dart';

extension DateTimeComparisonByDate on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension DateTimeComparisonByMonth on DateTime {
  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }
}

extension DateTimeExtensions on DateTime {
  /// Gets difference of months between [date] and calling object.
  int getMonthDifference(DateTime date) {
    if (year == date.year) return ((date.month - month).abs() + 1);

    var months = ((date.year - year).abs() - 1) * 12;

    if (date.year >= year) {
      months += date.month + (13 - month);
    } else {
      months += month + (13 - date.month);
    }

    return months;
  }

  /// Returns [DateTime] without timestamp.
  DateTime get withoutTime => DateTime(year, month, day);

  /// Returns The List of date of Current Week, all of the dates will be without
  /// time.
  /// Day will start from Monday to Sunday.
  ///
  /// ex: if Current Date instance is 8th and day is wednesday then weekDates
  /// will return dates
  /// [6,7,8,9,10,11,12]
  /// Where on 6th there will be monday and on 12th there will be Sunday
  List<DateTime> datesOfWeek() {
    // Here %7 ensure that we do not subtract >6 and <0 days.
    // Initial formula is,
    //    difference = (weekday - startInt)%7
    // where weekday and startInt ranges from 1 to 7.
    // But in WeekDays enum index ranges from 0 to 6 so we are
    // adding 1 in index. So, new formula with WeekDays is,
    //    difference = (weekdays - (start.index + 1))%7
    //
    DateTime startDay = DateTime(year, month, day);
    startDay = DateTime(year, month, day - startDay.weekday + 1);

    return [
      startDay,
      DateTime(startDay.year, startDay.month, startDay.day + 1),
      DateTime(startDay.year, startDay.month, startDay.day + 2),
      DateTime(startDay.year, startDay.month, startDay.day + 3),
      DateTime(startDay.year, startDay.month, startDay.day + 4),
      DateTime(startDay.year, startDay.month, startDay.day + 5),
      DateTime(startDay.year, startDay.month, startDay.day + 6),
    ];
  }

  /// Returns list of all dates of [month].
  /// All the dates are week based that means it will return array of size 42
  /// which will contain 6 weeks that is the maximum number of weeks a month
  /// can have.
  List<DateTime> datesOfMonths() {
    final monthDays = <DateTime>[];
    for (var i = 1, start = 1; i < 7; i++, start += 7) {
      monthDays.addAll(DateTime(year, month, start).datesOfWeek());
    }
    return monthDays;
  }
}

extension ScheduleListExtensions on List<ScheduleModel> {
  // 여러 날에 걸친 이벤트 시간 수정
  List<ScheduleModel> adjustMultiDaySchedules({required DateTime targetDate}) {
    return map((schedule) {
      final scheduleStartTime = schedule.startTime;
      final scheduleEndTime = schedule.endTime;

      if (!scheduleStartTime.isSameDate(scheduleEndTime)) {
        if (targetDate.isSameDate(scheduleStartTime)) {
          return ScheduleModel.copyWith(
            original: schedule,
            endTime: DateTime(scheduleStartTime.year, scheduleStartTime.month,
                scheduleStartTime.day, 23, 59),
          );
        } else if (targetDate.isSameDate(scheduleEndTime)) {
          return ScheduleModel.copyWith(
            original: schedule,
            startTime: DateTime(scheduleEndTime.year, scheduleEndTime.month,
                scheduleEndTime.day, 0, 0),
          );
        } else {
          return ScheduleModel.copyWith(
            original: schedule,
            startTime: DateTime(
                targetDate.year, targetDate.month, targetDate.day, 0, 0),
            endTime: DateTime(
                targetDate.year, targetDate.month, targetDate.day, 23, 59),
          );
        }
      }

      return schedule;
    }).toList();
  }
}
