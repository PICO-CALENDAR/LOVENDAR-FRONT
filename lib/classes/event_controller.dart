import 'package:pico/classes/custom_calendar.dart';
import 'package:pico/utils/extenstions.dart';

class EventController {
  final List<EventData> events;

  EventController({required this.events});

  List<ColumnedEventData> organizeEvents() {
    List<ColumnedEventData> columnedEvents =
        []; // 1. 이벤트를 시작 날짜 기준으로 정렬 (같은 시작 날짜면 종료 날짜 기준으로 정렬)
    events.sort((a, b) {
      if (a.startTime.isSameDate(b.startTime)) {
        return a.endTime.withoutTime.compareTo(b.endTime.withoutTime);
      }
      return a.startTime.withoutTime.compareTo(b.startTime.withoutTime);
    });

    // 2. 열(column) 상태를 추적하는 리스트
    List<DateTime> columns = []; // 각 열의 종료 날짜 저장

    for (var event in events) {
      bool foundColumn = false;

      // 3. 사용 가능한 열 찾기
      for (int i = 0; i < columns.length; i++) {
        // print("${event.title} : ${event.startTime}");
        // print(columns);
        // print(columns[i].withoutTime.isBefore(event.startTime.withoutTime));
        // print(i + 1);
        if (columns[i].withoutTime.isBefore(event.startTime.withoutTime)) {
          // 열이 비어 있다면 해당 열에 이벤트 배치
          columns[i] = event.endTime;
          final organized = ColumnedEventData(
              eventData: event, column: i + 1); // 열 번호는 1부터 시작
          columnedEvents.add(organized);
          foundColumn = true;
          break;
        }
      }

      // 4. 사용 가능한 열이 없다면 새로운 열 생성
      if (!foundColumn) {
        columns.add(event.endTime);
        final organized = ColumnedEventData(
            eventData: event, column: columns.length); // 새 열 번호는 현재 열 개수
        columnedEvents.add(organized);
      }
    }

    return columnedEvents;
  }

  // 특정 기간에 속하는 일정 이벤트 리스트만
  List<ColumnedEventData> filterAndSortEventsForWeek(
      List<ColumnedEventData> events, DateTime weekStart, DateTime weekEnd) {
    return events
        .where((event) =>
            event.eventData.startTime.withoutTime
                .isBefore(weekEnd.withoutTime.add(const Duration(days: 1))) &&
            event.eventData.endTime.withoutTime.isAfter(
                weekStart.withoutTime.subtract(const Duration(days: 1))))
        .toList()
      ..sort((a, b) => a.column.compareTo(b.column));
  }

  List<EventData> getEventsForDate(DateTime date) {
    final filteredEvents = events.where((event) {
      // 이벤트가 해당 날짜 범위 안에 포함되는지 확인
      return event.startTime.withoutTime
              .isBefore(date.withoutTime.add(const Duration(days: 1))) &&
          event.endTime.withoutTime
              .isAfter(date.withoutTime.subtract(const Duration(days: 1)));
    }).toList();

    // 시작 시간을 기준으로 정렬
    filteredEvents.sort((a, b) => a.startTime.compareTo(b.startTime));

    return filteredEvents;
  }

  List<ColumnedEventData> get orgEvents => organizeEvents();
}

class ColumnedEventData {
  EventData eventData;
  final int column;

  ColumnedEventData({
    required this.eventData,
    required this.column,
  });
}
