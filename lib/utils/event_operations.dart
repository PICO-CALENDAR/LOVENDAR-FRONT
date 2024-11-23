import 'package:pico/classes/custom_calendar.dart';

// 시간대가 겹치는 이벤트 그룹화
List<List<EventData>> groupOverlappingEvents(List<EventData> events) {
  // 하루 종일 이벤트 제외
  final filteredEvents = events.where((event) => !event.isAllDay).toList();

  // 이벤트 리스트가 비어있으면 빈 리스트 반환
  if (filteredEvents.isEmpty) return [];

  // 시작 시간 기준으로 정렬
  filteredEvents.sort((a, b) => a.startTime.compareTo(b.startTime));

  final List<List<EventData>> groupedEvents = [];
  List<EventData> currentGroup = [filteredEvents.first];

  for (int i = 1; i < filteredEvents.length; i++) {
    final currentEvent = filteredEvents[i];
    final lastEventInGroup = currentGroup.last;

    // 현재 이벤트가 그룹의 마지막 이벤트와 겹치더라도, 시간이 포함되지 않으면 새로운 그룹 시작
    if (!currentEvent.startTime.isBefore(lastEventInGroup.endTime) &&
        !currentEvent.startTime.isAtSameMomentAs(lastEventInGroup.endTime)) {
      groupedEvents.add(currentGroup);
      currentGroup = [currentEvent];
    } else {
      // 현재 이벤트를 그룹에 추가
      currentGroup.add(currentEvent);
    }
  }

  // 마지막 그룹 추가
  groupedEvents.add(currentGroup);

  return groupedEvents;
}

// 이벤트 병합하여 시간 범위 반환
MergedEvent mergeEventsAndGetTime(List<EventData> events) {
  if (events.isEmpty) {
    throw ArgumentError('Event list cannot be empty');
  }

  final minStart =
      events.map((e) => e.startTime).reduce((a, b) => a.isBefore(b) ? a : b);
  final maxEnd =
      events.map((e) => e.endTime).reduce((a, b) => a.isAfter(b) ? a : b);

  return MergedEvent(
      startTime: minStart, endTime: maxEnd, mergedEvents: events);
}

// 특정 시간 범위와 겹치는 이벤트 반환
List<EventData> findOverlappingEventsByTime(
    List<EventData> events, DateTime startTime, DateTime endTime) {
  return events.where((event) {
    return event.startTime.isBefore(endTime) &&
        event.endTime.isAfter(startTime);
  }).toList();
}

List<List<EventData>> calculateEventColumns(List<EventData> events) {
  if (events.isEmpty) return [];

  // 겹치는 이벤트 그룹 가져오기
  List<List<EventData>> overlappingGroups = groupOverlappingEvents(events);

  Map<EventData, int> eventColumns = {};
  Map<int, List<EventData>> columnToEvents = {}; // 각 열에 해당하는 이벤트 리스트
  int maxColumnUsed = 0; // 총 열의 최대값 추적

  for (var group in overlappingGroups) {
    if (group.isEmpty) continue;

    // 그룹의 모든 이벤트를 열에 할당
    maxColumnUsed = assignColumnsForGroup(
        group, eventColumns, columnToEvents, maxColumnUsed);
  }

  // 결과 반환: 열 번호별로 정렬된 리스트 생성
  List<List<EventData>> result = [];
  for (int i = 0; i <= maxColumnUsed; i++) {
    result.add(columnToEvents[i] ?? []);
  }
  return result;
}

// 그룹의 이벤트를 열에 할당하고 최대 열 번호 반환
int assignColumnsForGroup(
    List<EventData> group,
    Map<EventData, int> eventColumns,
    Map<int, List<EventData>> columnToEvents,
    int maxColumnUsed) {
  // 이벤트를 시작 시간 기준으로 정렬
  group.sort((a, b) => a.startTime.compareTo(b.startTime));

  for (var event in group) {
    // 겹치는 열을 계산
    var overlappingColumns = group
        .where((e) =>
            e != event &&
            e.startTime.isBefore(event.endTime) &&
            e.endTime.isAfter(event.startTime))
        .map((e) => eventColumns[e]);

    // 사용 가능한 최소 열 번호 찾기
    int column = 0;
    while (overlappingColumns.contains(column)) {
      column++;
    }

    // 열 배정
    eventColumns[event] = column;

    // 열별 이벤트 리스트 갱신
    if (!columnToEvents.containsKey(column)) {
      columnToEvents[column] = [];
    }
    columnToEvents[column]!.add(event);

    // 최대 열 번호 갱신
    maxColumnUsed = maxColumnUsed > column ? maxColumnUsed : column;
  }

  return maxColumnUsed;
}

// OrganizedEvent 생성 헬퍼 함수
List<OrganizedEvent> createOrganizedEvents(
  List<EventData> events,
  double slotWidth,
  double leftStart,
) {
  final columns = calculateEventColumns(events);
  final width = slotWidth / columns.length;

  final List<OrganizedEvent> organizedEvent = [];

  for (int i = 0; i < columns.length; i++) {
    // i는 이벤트가 속한 열이 된다.
    for (var event in columns[i]) {
      // 한 열에 속한 이벤트
      organizedEvent.add(
        OrganizedEvent(
          left: leftStart + i * width, // 한 열에 속한 이벤트는 같은 시작 위치를 가진다.
          top: event.durationFromMidnight.inMinutes.toDouble(),
          width: width,
          height: event.duration.inMinutes.toDouble(),
          eventData: event,
        ),
      );
    }
  }

  return organizedEvent;
}

// 모든 이벤트를 OrganizedEvent로 변환
List<OrganizedEvent> getOrganizedEvents(
    List<EventData> overlappingEvents, double viewWidth) {
  final double totalWidth = viewWidth;
  final List<OrganizedEvent> organizedEvents = [];

  final myEvents = overlappingEvents
      .where((event) => event.category == EventCategory.mine)
      .toList();
  final yourEvents = overlappingEvents
      .where((event) => event.category == EventCategory.yours)
      .toList();
  final ourEvents = overlappingEvents
      .where((event) => event.category == EventCategory.ours)
      .toList();

  if (ourEvents.isNotEmpty) {
    // "우리" 이벤트 병합
    final mergedOurEvent = mergeEventsAndGetTime(ourEvents);
    final otherEvents = [...myEvents, ...yourEvents];

    // 병합된 "우리" 이벤트와 겹치는 나와 상대 이벤트 확인
    final overlappedEvents = findOverlappingEventsByTime(
      otherEvents,
      mergedOurEvent.startTime,
      mergedOurEvent.endTime,
    );
    final overlappedState = checkEventCategories(overlappedEvents);

    switch (overlappedState) {
      case OverlappedState.none:
        organizedEvents.addAll(createOrganizedEvents(ourEvents, totalWidth, 0));
        organizedEvents
            .addAll(createOrganizedEvents(myEvents, totalWidth / 2, 0));
        organizedEvents.addAll(
            createOrganizedEvents(yourEvents, totalWidth / 2, totalWidth / 2));
        break;

      case OverlappedState.mineOnly:
        organizedEvents.addAll(createOrganizedEvents(
            ourEvents, totalWidth * 2 / 3, totalWidth / 3));
        organizedEvents
            .addAll(createOrganizedEvents(myEvents, totalWidth / 3, 0));
        organizedEvents.addAll(
            createOrganizedEvents(yourEvents, totalWidth / 2, totalWidth / 2));
        break;

      case OverlappedState.yoursOnly:
        organizedEvents.addAll(createOrganizedEvents(
            ourEvents, totalWidth * 2 / 3, totalWidth / 3));
        organizedEvents
            .addAll(createOrganizedEvents(myEvents, totalWidth / 2, 0));
        organizedEvents.addAll(createOrganizedEvents(
            yourEvents, totalWidth / 3, totalWidth * 2 / 3));
        break;

      case OverlappedState.both:
        organizedEvents.addAll(
            createOrganizedEvents(ourEvents, totalWidth / 3, totalWidth / 3));
        organizedEvents
            .addAll(createOrganizedEvents(myEvents, totalWidth / 3, 0));
        organizedEvents.addAll(createOrganizedEvents(
            yourEvents, totalWidth / 3, totalWidth * 2 / 3));
        break;

      default:
        break;
    }
  } else {
    // "우리" 이벤트가 없을 때
    organizedEvents.addAll(createOrganizedEvents(myEvents, totalWidth / 2, 0));
    organizedEvents.addAll(
        createOrganizedEvents(yourEvents, totalWidth / 2, totalWidth / 2));
  }

  return organizedEvents;
}

// 병합된 이벤트 클래스
class MergedEvent {
  final DateTime startTime;
  final DateTime endTime;
  final List<EventData> mergedEvents;

  MergedEvent({
    required this.startTime,
    required this.endTime,
    required this.mergedEvents,
  });
}

// OrganizedEvent 클래스
class OrganizedEvent {
  final double left;
  final double top;
  final double width;
  final double height;
  final EventData eventData;

  OrganizedEvent({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.eventData,
  });
}
