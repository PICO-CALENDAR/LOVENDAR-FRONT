import 'package:pico/classes/custom_calendar.dart';

class CalendarConst {
  // 생성자 안되는 클래스인듯?
  CalendarConst._();

  static const int hoursADay = 24;
  static const int minutesADay = 1440;
  // static final List<PicoEvent> events = [
  //   PicoEvent(
  //     title: "Meeting",
  //     startTime: DateTime(2024, 11, 22, 10, 0),
  //     endTime: DateTime(2024, 11, 22, 11, 0),
  //     category: EventCategory.mine,
  //     isAllDay: false,
  //   ),
  //   PicoEvent(
  //     title: "Lunch",
  //     startTime: DateTime(2024, 11, 22, 12, 0),
  //     endTime: DateTime(2024, 11, 22, 13, 0),
  //     category: EventCategory.yours,
  //     isAllDay: false,
  //   ),
  //   PicoEvent(
  //     title: "Project Review",
  //     startTime: DateTime(2024, 11, 22, 14, 0),
  //     endTime: DateTime(2024, 11, 22, 15, 0),
  //     category: EventCategory.ours,
  //     isAllDay: false,
  //   ),
  // ];

  static final List<PicoEvent> events = [
    PicoEvent(
      title: "Event 1",
      startTime: DateTime(2024, 11, 22, 9, 45),
      endTime: DateTime(2024, 11, 22, 10, 32),
      category: EventCategory.yours,
      isAllDay: false,
    ),
    PicoEvent(
      title: "Event 2",
      startTime: DateTime(2024, 11, 22, 14, 15),
      endTime: DateTime(2024, 11, 22, 15, 47),
      category: EventCategory.yours,
      isAllDay: false,
    ),
    PicoEvent(
      title: "Event 3",
      startTime: DateTime(2024, 11, 22, 10, 15),
      endTime: DateTime(2024, 11, 22, 11, 26),
      category: EventCategory.yours,
      isAllDay: false,
    ),
    PicoEvent(
      title: "Event 4",
      startTime: DateTime(2024, 11, 22, 10, 45),
      endTime: DateTime(2024, 11, 22, 11, 26),
      category: EventCategory.ours,
      isAllDay: false,
    ),
    PicoEvent(
      title: "Event 5",
      startTime: DateTime(2024, 11, 22, 10, 45),
      endTime: DateTime(2024, 11, 22, 12, 10),
      category: EventCategory.mine,
      isAllDay: false,
    ),
    PicoEvent(
      title: "Event 6",
      startTime: DateTime(2024, 11, 22, 17, 15),
      endTime: DateTime(2024, 11, 22, 18, 11),
      category: EventCategory.mine,
      isAllDay: false,
    ),
    PicoEvent(
      title: "Event 7",
      startTime: DateTime(2024, 11, 22, 12, 30),
      endTime: DateTime(2024, 11, 22, 14, 27),
      category: EventCategory.mine,
      isAllDay: false,
    ),
    PicoEvent(
      title: "Event 8",
      startTime: DateTime(2024, 11, 22, 12, 45),
      endTime: DateTime(2024, 11, 22, 13, 23),
      category: EventCategory.mine,
      isAllDay: false,
    ),
    PicoEvent(
      title: "Event 9",
      startTime: DateTime(2024, 11, 22, 13, 0),
      endTime: DateTime(2024, 11, 22, 14, 0),
      category: EventCategory.mine,
      isAllDay: false,
    ),
    PicoEvent(
      title: "Event 10",
      startTime: DateTime(2024, 11, 22, 11, 45),
      endTime: DateTime(2024, 11, 22, 12, 28),
      category: EventCategory.ours,
      isAllDay: false,
    ),
    PicoEvent(
      title: "Event 11",
      startTime: DateTime(2024, 11, 22, 18, 15),
      endTime: DateTime(2024, 11, 22, 19, 37),
      category: EventCategory.yours,
      isAllDay: false,
    ),
    PicoEvent(
      title: "Event 12",
      startTime: DateTime(2024, 11, 22, 13, 45),
      endTime: DateTime(2024, 11, 22, 15, 22),
      category: EventCategory.mine,
      isAllDay: false,
    ),
    PicoEvent(
      title: "Event 13",
      startTime: DateTime(2024, 11, 22, 9, 45),
      endTime: DateTime(2024, 11, 22, 10, 47),
      category: EventCategory.ours,
      isAllDay: false,
    ),
    PicoEvent(
      title: "Event 14",
      startTime: DateTime(2024, 11, 22, 15, 0),
      endTime: DateTime(2024, 11, 22, 16, 11),
      category: EventCategory.mine,
      isAllDay: false,
    ),
    PicoEvent(
      title: "Event 15",
      startTime: DateTime(2024, 11, 22, 13, 0),
      endTime: DateTime(2024, 11, 22, 14, 22),
      category: EventCategory.mine,
      isAllDay: false,
    ),
    PicoEvent(
      title: "Event 16",
      startTime: DateTime(2024, 11, 22, 17, 30),
      endTime: DateTime(2024, 11, 22, 18, 2),
      category: EventCategory.yours,
      isAllDay: false,
    ),
    PicoEvent(
      title: "Event 17",
      startTime: DateTime(2024, 11, 22, 17, 30),
      endTime: DateTime(2024, 11, 22, 19, 14),
      category: EventCategory.yours,
      isAllDay: false,
    ),
    PicoEvent(
      title: "Event 18",
      startTime: DateTime(2024, 11, 22, 8, 30),
      endTime: DateTime(2024, 11, 22, 10, 13),
      category: EventCategory.mine,
      isAllDay: false,
    ),
    PicoEvent(
      title: "Event 19",
      startTime: DateTime(2024, 11, 22, 18, 15),
      endTime: DateTime(2024, 11, 22, 19, 4),
      category: EventCategory.mine,
      isAllDay: false,
    ),
    PicoEvent(
      title: "Event 20",
      startTime: DateTime(2024, 11, 22, 16, 15),
      endTime: DateTime(2024, 11, 22, 18, 8),
      category: EventCategory.ours,
      isAllDay: false,
    ),
  ];
}
