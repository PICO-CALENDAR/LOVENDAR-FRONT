import 'package:pico/classes/custom_calendar.dart';

class CalendarConst {
  // 생성자 안되는 클래스인듯?
  CalendarConst._();

  /// minimum and maximum dates are approx. 100,000,000 days
  /// before and after epochDate
  static final DateTime epochDate = DateTime(1970);
  static final DateTime maxDate = DateTime(275759);
  static final DateTime minDate = DateTime(-271819);

  static const int hoursADay = 24;
  static const int minutesADay = 1440;
  static final List<EventData> calEvent = [
    EventData(
      title: "하루만 allday",
      startTime: DateTime(2024, 11, 23, 9, 0),
      endTime: DateTime(2024, 11, 23, 10, 0),
      category: EventCategory.mine,
      isAllDay: false,
    ),
    EventData(
      title: "Team Meeting",
      startTime: DateTime(2024, 11, 23, 0, 0),
      endTime: DateTime(2024, 11, 23, 0, 0),
      category: EventCategory.mine,
      isAllDay: true,
    ),
    EventData(
      title: "Workshop",
      startTime: DateTime(2024, 11, 24, 13, 0),
      endTime: DateTime(2024, 11, 24, 15, 0),
      category: EventCategory.yours,
      isAllDay: false,
    ),
    EventData(
      title: "Holiday",
      startTime: DateTime(2024, 11, 25, 0, 0),
      endTime: DateTime(2024, 11, 26, 0, 0),
      category: EventCategory.ours,
      isAllDay: true,
    ),
    EventData(
      title: "Doctor's Appointment",
      startTime: DateTime(2024, 11, 26, 10, 30),
      endTime: DateTime(2024, 11, 26, 11, 0),
      category: EventCategory.mine,
      isAllDay: false,
    ),
    EventData(
      title: "Conference",
      startTime: DateTime(2024, 11, 27, 0, 0),
      endTime: DateTime(2024, 11, 29, 0, 0),
      category: EventCategory.yours,
      isAllDay: true,
    ),
    EventData(
      title: "Dinner with Friends",
      startTime: DateTime(2024, 11, 27, 19, 0),
      endTime: DateTime(2024, 11, 27, 21, 0),
      category: EventCategory.ours,
      isAllDay: false,
    ),
    EventData(
      title: "Gym Session",
      startTime: DateTime(2024, 11, 28, 7, 0),
      endTime: DateTime(2024, 11, 28, 8, 0),
      category: EventCategory.mine,
      isAllDay: false,
    ),
    EventData(
      title: "Vacation",
      startTime: DateTime(2024, 11, 30, 0, 0),
      endTime: DateTime(2024, 12, 5, 0, 0),
      category: EventCategory.yours,
      isAllDay: true,
    ),
    EventData(
      title: "Family Gathering",
      startTime: DateTime(2024, 12, 1, 15, 0),
      endTime: DateTime(2024, 12, 1, 18, 0),
      category: EventCategory.ours,
      isAllDay: false,
    ),
    EventData(
      title: "Year-End Party",
      startTime: DateTime(2024, 12, 31, 0, 0),
      endTime: DateTime(2025, 1, 1, 0, 0),
      category: EventCategory.ours,
      isAllDay: true,
    ),
  ];

  // static final List<EventData> events = [
  //   EventData(
  //     title: "Meeting",
  //     startTime: DateTime(2024, 11, 22, 10, 0),
  //     endTime: DateTime(2024, 11, 22, 11, 0),
  //     category: EventCategory.mine,
  //     isAllDay: false,
  //   ),
  //   EventData(
  //     title: "Lunch",
  //     startTime: DateTime(2024, 11, 22, 12, 0),
  //     endTime: DateTime(2024, 11, 22, 13, 0),
  //     category: EventCategory.yours,
  //     isAllDay: false,
  //   ),
  //   EventData(
  //     title: "Project Review",
  //     startTime: DateTime(2024, 11, 22, 14, 0),
  //     endTime: DateTime(2024, 11, 22, 15, 0),
  //     category: EventCategory.ours,
  //     isAllDay: false,
  //   ),
  // ];

  // static final List<EventData> events = [
  //   EventData(
  //     title: "Morning Run",
  //     startTime: DateTime(2024, 11, 22, 6, 0),
  //     endTime: DateTime(2024, 11, 22, 7, 30),
  //     category: EventCategory.mine,
  //     isAllDay: false,
  //   ),
  //   EventData(
  //     title: "Team Meeting",
  //     startTime: DateTime(2024, 11, 22, 10, 0),
  //     endTime: DateTime(2024, 11, 22, 11, 0),
  //     category: EventCategory.ours,
  //     isAllDay: false,
  //   ),
  //   EventData(
  //     title: "Lunch with Client",
  //     startTime: DateTime(2024, 11, 22, 12, 0),
  //     endTime: DateTime(2024, 11, 22, 13, 30),
  //     category: EventCategory.yours,
  //     isAllDay: false,
  //   ),
  //   EventData(
  //     title: "Design Review",
  //     startTime: DateTime(2024, 11, 22, 14, 30),
  //     endTime: DateTime(2024, 11, 22, 15, 30),
  //     category: EventCategory.ours,
  //     isAllDay: false,
  //   ),
  //   EventData(
  //     title: "Yoga Session",
  //     startTime: DateTime(2024, 11, 22, 19, 30),
  //     endTime: DateTime(2024, 11, 22, 20, 30),
  //     category: EventCategory.mine,
  //     isAllDay: false,
  //   ),
  //   EventData(
  //     title: "Dinner Date",
  //     startTime: DateTime(2024, 11, 22, 21, 0),
  //     endTime: DateTime(2024, 11, 22, 22, 30),
  //     category: EventCategory.yours,
  //     isAllDay: false,
  //   ),
  //   EventData(
  //     title: "Late Night Project",
  //     startTime: DateTime(2024, 11, 22, 23, 0),
  //     endTime: DateTime(2024, 11, 23, 1, 0),
  //     category: EventCategory.mine,
  //     isAllDay: false,
  //   ),
  //   EventData(
  //     title: "Conference Call",
  //     startTime: DateTime(2024, 11, 22, 8, 0),
  //     endTime: DateTime(2024, 11, 22, 8, 45),
  //     category: EventCategory.ours,
  //     isAllDay: false,
  //   ),
  //   EventData(
  //     title: "Workshop",
  //     startTime: DateTime(2024, 11, 22, 15, 45),
  //     endTime: DateTime(2024, 11, 22, 17, 0),
  //     category: EventCategory.mine,
  //     isAllDay: false,
  //   ),
  //   EventData(
  //     title: "Evening Walk",
  //     startTime: DateTime(2024, 11, 22, 18, 30),
  //     endTime: DateTime(2024, 11, 22, 19, 15),
  //     category: EventCategory.yours,
  //     isAllDay: false,
  //   ),
  // ];

  static final List<EventData> events = [
    EventData(
      title: "Event 1",
      startTime: DateTime(2024, 11, 22, 9, 45),
      endTime: DateTime(2024, 11, 22, 10, 32),
      category: EventCategory.yours,
      isAllDay: false,
    ),
    EventData(
      title: "Event 2",
      startTime: DateTime(2024, 11, 22, 14, 15),
      endTime: DateTime(2024, 11, 22, 15, 47),
      category: EventCategory.yours,
      isAllDay: false,
    ),
    EventData(
      title: "Event 3",
      startTime: DateTime(2024, 11, 22, 10, 15),
      endTime: DateTime(2024, 11, 22, 11, 26),
      category: EventCategory.yours,
      isAllDay: false,
    ),
    EventData(
      title: "Event 4",
      startTime: DateTime(2024, 11, 22, 10, 45),
      endTime: DateTime(2024, 11, 22, 11, 26),
      category: EventCategory.ours,
      isAllDay: false,
    ),
    EventData(
      title: "Event 5",
      startTime: DateTime(2024, 11, 22, 10, 45),
      endTime: DateTime(2024, 11, 22, 12, 10),
      category: EventCategory.mine,
      isAllDay: false,
    ),
    EventData(
      title: "Event 6",
      startTime: DateTime(2024, 11, 22, 17, 15),
      endTime: DateTime(2024, 11, 22, 18, 11),
      category: EventCategory.mine,
      isAllDay: false,
    ),
    EventData(
      title: "Event 7",
      startTime: DateTime(2024, 11, 22, 12, 30),
      endTime: DateTime(2024, 11, 22, 14, 27),
      category: EventCategory.mine,
      isAllDay: false,
    ),
    EventData(
      title: "Event 8",
      startTime: DateTime(2024, 11, 22, 12, 45),
      endTime: DateTime(2024, 11, 22, 13, 23),
      category: EventCategory.mine,
      isAllDay: false,
    ),
    EventData(
      title: "Event 9",
      startTime: DateTime(2024, 11, 22, 13, 0),
      endTime: DateTime(2024, 11, 22, 14, 0),
      category: EventCategory.mine,
      isAllDay: false,
    ),
    EventData(
      title: "Event 10",
      startTime: DateTime(2024, 11, 22, 11, 45),
      endTime: DateTime(2024, 11, 22, 12, 28),
      category: EventCategory.ours,
      isAllDay: false,
    ),
    EventData(
      title: "Event 11",
      startTime: DateTime(2024, 11, 22, 18, 15),
      endTime: DateTime(2024, 11, 22, 19, 37),
      category: EventCategory.yours,
      isAllDay: false,
    ),
    EventData(
      title: "Event 12",
      startTime: DateTime(2024, 11, 22, 13, 45),
      endTime: DateTime(2024, 11, 22, 15, 22),
      category: EventCategory.mine,
      isAllDay: false,
    ),
    EventData(
      title: "Event 13",
      startTime: DateTime(2024, 11, 22, 9, 45),
      endTime: DateTime(2024, 11, 22, 10, 47),
      category: EventCategory.ours,
      isAllDay: false,
    ),
    EventData(
      title: "Event 14",
      startTime: DateTime(2024, 11, 22, 15, 0),
      endTime: DateTime(2024, 11, 22, 16, 11),
      category: EventCategory.mine,
      isAllDay: false,
    ),
    EventData(
      title: "Event 15",
      startTime: DateTime(2024, 11, 22, 13, 0),
      endTime: DateTime(2024, 11, 22, 14, 22),
      category: EventCategory.mine,
      isAllDay: false,
    ),
    EventData(
      title: "Event 16",
      startTime: DateTime(2024, 11, 22, 17, 30),
      endTime: DateTime(2024, 11, 22, 18, 2),
      category: EventCategory.yours,
      isAllDay: false,
    ),
    EventData(
      title: "Event 17",
      startTime: DateTime(2024, 11, 22, 17, 30),
      endTime: DateTime(2024, 11, 22, 19, 14),
      category: EventCategory.yours,
      isAllDay: false,
    ),
    EventData(
      title: "Event 18",
      startTime: DateTime(2024, 11, 22, 8, 30),
      endTime: DateTime(2024, 11, 22, 10, 13),
      category: EventCategory.mine,
      isAllDay: false,
    ),
    EventData(
      title: "Event 19",
      startTime: DateTime(2024, 11, 22, 18, 15),
      endTime: DateTime(2024, 11, 22, 19, 4),
      category: EventCategory.mine,
      isAllDay: false,
    ),
    EventData(
      title: "Event 20",
      startTime: DateTime(2024, 11, 22, 16, 15),
      endTime: DateTime(2024, 11, 22, 18, 8),
      category: EventCategory.ours,
      isAllDay: false,
    ),
    EventData(
      title: "우리",
      startTime: DateTime(2024, 11, 22, 00, 15),
      endTime: DateTime(2024, 11, 22, 5, 8),
      category: EventCategory.ours,
      isAllDay: false,
    ),
  ];
}
