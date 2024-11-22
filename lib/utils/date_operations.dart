List<DateTime> getWeekDate(DateTime date) {
  final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
  return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
}
