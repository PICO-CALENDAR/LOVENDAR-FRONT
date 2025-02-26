List<DateTime> getWeekDate(DateTime date) {
  final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
  return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
}

// Helper methods for DateTime conversion
DateTime dateTimeFromIsoString(String isoString) => DateTime.parse(isoString);

String dateTimeToIsoString(DateTime dateTime) => dateTime.toIso8601String();

// Helper functions for nullable DateTime
DateTime? dateTimeFromIsoStringNullable(String? isoString) {
  if (isoString == null) return null;
  return DateTime.parse(isoString);
}

String? dateTimeToIsoStringNullable(DateTime? dateTime) {
  return dateTime?.toIso8601String();
}

String parseStringDdayToInDaysString({required String dday}) {
  DateTime now = DateTime.now();
  DateTime todayMidnight = DateTime(now.year, now.month, now.day);

  return "${todayMidnight.difference(DateTime.parse(dday)).inDays + 1}일";
}

int parseDateTimeToInDays({required DateTime datetime}) {
  DateTime now = DateTime.now();
  DateTime todayMidnight = DateTime(now.year, now.month, now.day);
  return todayMidnight.difference(datetime).inDays;
}
