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
