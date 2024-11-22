import 'package:pico/classes/custom_calendar.dart';

final now = DateTime.now();

List<PicoEvent> events = [
  PicoEvent(
    title: "Event A",
    startTime: DateTime(2024, 11, 23, 10, 0),
    endTime: DateTime(2024, 11, 23, 11, 0),
    category: EventCategory.mine,
    isAllDay: false,
  ),
  PicoEvent(
    title: "Event B",
    startTime: DateTime(2024, 11, 23, 10, 30),
    endTime: DateTime(2024, 11, 23, 12, 0),
    category: EventCategory.ours,
    isAllDay: false,
  ),
  PicoEvent(
    title: "Event C",
    startTime: DateTime(2024, 11, 23, 13, 0),
    endTime: DateTime(2024, 11, 23, 14, 0),
    category: EventCategory.yours,
    isAllDay: false,
  ),
];
