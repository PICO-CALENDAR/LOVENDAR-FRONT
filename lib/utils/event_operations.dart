import 'package:pico/classes/custom_calendar.dart';
import 'package:pico/contants/temp.dart';

// 시간대가 겹치는 이벤트 찾기
List<List<PicoEvent>> groupOverlappingEvents(List<PicoEvent> events) {
  // isAllDay가 true인 이벤트를 제외
  final filteredEvents = events.where((event) => !event.isAllDay).toList();

  // 입력 리스트가 비어 있으면 빈 리스트 반환
  if (filteredEvents.isEmpty) return [];

  // 이벤트를 시작 시간 기준으로 정렬
  filteredEvents.sort((a, b) => a.startTime.compareTo(b.startTime));

  // 결과 리스트
  final List<List<PicoEvent>> groupedEvents = [];

  // 첫 번째 이벤트 그룹을 초기화
  List<PicoEvent> currentGroup = [filteredEvents.first];

  for (int i = 1; i < filteredEvents.length; i++) {
    final currentEvent = filteredEvents[i];
    final lastEventInGroup = currentGroup.last;

    // 겹치는지 확인
    if (currentEvent.startTime.isBefore(lastEventInGroup.endTime) ||
        currentEvent.startTime.isAtSameMomentAs(lastEventInGroup.endTime)) {
      // 겹치는 경우 그룹에 추가
      currentGroup.add(currentEvent);
    } else {
      // 겹치지 않으면 현재 그룹을 결과에 추가하고 새로운 그룹 시작
      groupedEvents.add(currentGroup);
      currentGroup = [currentEvent];
    }
  }

  // 마지막 그룹 추가
  groupedEvents.add(currentGroup);

  return groupedEvents;
}

class OrganizedEvent {
  final double left;
  final double top;
  final double? right;
  final double? bottom; // 하루 분에서 빼서 구해야할듯..? 아니면 height으로?
  final double? width;
  final double? height;
  final PicoEvent eventData;

  OrganizedEvent({
    required this.left,
    required this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
    required this.eventData,
  });
}

// 1. 주어진 events 중 가장 빠른 startTime과 가장 늦은 endTime 반환 ("우리"의 이벤트 병합에 사용)
MergedEvent mergeEventsAndGetTime(List<PicoEvent> events) {
  if (events.isEmpty) {
    throw ArgumentError('Event list cannot be empty');
  }

  DateTime minStart = events.first.startTime;
  DateTime maxEnd = events.first.endTime;

  for (var event in events) {
    if (event.startTime.isBefore(minStart)) {
      minStart = event.startTime;
    }
    if (event.endTime.isAfter(maxEnd)) {
      maxEnd = event.endTime;
    }
  }

  return MergedEvent(
    startTime: minStart,
    endTime: maxEnd,
    mergedEvents: events,
  );
}

// 2. 주어진 시작 시간-종료시간과 겹치는 이벤트 리스트 반환
List<PicoEvent> findOverlappingEventsByTime(
    List<PicoEvent> events, DateTime startTime, DateTime endTime) {
  return events.where((event) {
    // 이벤트가 주어진 시간과 겹치는지 확인
    return event.startTime.isBefore(endTime) &&
        event.endTime.isAfter(startTime);
  }).toList();
}

class MergedEvent {
  final DateTime startTime;
  final DateTime endTime;
  final List<PicoEvent> mergedEvents;

  MergedEvent({
    required this.startTime,
    required this.endTime,
    required this.mergedEvents,
  });
}

// 각 이벤트의 좌표 구하기
List<OrganizedEvent> getOrganizedEvents(
    List<PicoEvent> overlappingEvents, double viewWidth) {
  final double totalWidth = viewWidth; // TODO: 실제 total width 얻어와서 바꾸기
  List<OrganizedEvent> organizedEvents = [];

  // overlappingEvents에는 All Day (하루종일) 이벤트가 존재하지 않음
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
    // "우리" 이벤트가 있을 때
    final mergedOurtEvent = mergeEventsAndGetTime(ourEvents);
    final myEventsAndyourEvents = [...myEvents, ...yourEvents];

    //TODO: 우리끼리 겹치는 건 확인을 못한듯..

    //우리들의 이벤트에서 합친 것과 겹치는 나와 상대의 이벤트 찾기
    final overlappedEventsByMergedOurtEvent = findOverlappingEventsByTime(
      myEventsAndyourEvents, // 너와 상대의 이벤트들
      mergedOurtEvent.startTime,
      mergedOurtEvent.endTime,
    );
    final overlappedState =
        checkEventCategories(overlappedEventsByMergedOurtEvent);

    switch (overlappedState) {
      case OverlappedState.none:
        final ourSlotWidth = totalWidth;
        // 우리 일정 정렬
        for (int i = 0; i < ourEvents.length; i++) {
          final ourEvent = ourEvents[i];
          final width = ourSlotWidth / ourEvents.length;
          organizedEvents.add(
            OrganizedEvent(
              left: i * width,
              top: ourEvent.durationFromMidnight.inMinutes.toDouble(),
              width: width,
              height: ourEvent.duration.inMinutes.toDouble(),
              eventData: ourEvent,
            ),
          );
        }
        final slotWidth = totalWidth / 2;

        // 나의 이벤트
        for (int i = 0; i < myEvents.length; i++) {
          final myEvent = myEvents[i];
          final width = slotWidth / myEvents.length;
          organizedEvents.add(
            OrganizedEvent(
              left: i * width,
              top: myEvent.durationFromMidnight.inMinutes.toDouble(),
              width: width,
              height: myEvent.duration.inMinutes.toDouble(),
              eventData: myEvent,
            ),
          );
        }

        for (int i = 0; i < yourEvents.length; i++) {
          final yourEvent = yourEvents[i];
          final width = slotWidth / yourEvents.length;
          organizedEvents.add(
            OrganizedEvent(
              left: slotWidth + i * width,
              top: yourEvent.durationFromMidnight.inMinutes.toDouble(),
              width: width,
              height: yourEvent.duration.inMinutes.toDouble(),
              eventData: yourEvent,
            ),
          );
        }
        break;

      // 나만 겹치는 경우
      case OverlappedState.mineOnly:
        final ourLeftStart = totalWidth / 3;
        final ourSlotWidth = totalWidth * 2 / 3;

        // 우리 일정 정렬
        for (int i = 0; i < ourEvents.length; i++) {
          final ourEvent = ourEvents[i];
          final width = ourSlotWidth / ourEvents.length;
          organizedEvents.add(
            OrganizedEvent(
              left: ourLeftStart + i * width,
              top: ourEvent.durationFromMidnight.inMinutes.toDouble(),
              width: width,
              height: ourEvent.duration.inMinutes.toDouble(),
              eventData: ourEvent,
            ),
          );
        }

        final mySlotWidth = totalWidth / 3;
        // 나의 이벤트
        for (int i = 0; i < myEvents.length; i++) {
          final myEvent = myEvents[i];
          final width = mySlotWidth / myEvents.length;
          organizedEvents.add(
            OrganizedEvent(
              left: i * width,
              top: myEvent.durationFromMidnight.inMinutes.toDouble(),
              width: width,
              height: myEvent.duration.inMinutes.toDouble(),
              eventData: myEvent,
            ),
          );
        }

        final yourSlotWidth = totalWidth / 2;

        for (int i = 0; i < yourEvents.length; i++) {
          final yourEvent = yourEvents[i];
          final width = yourSlotWidth / yourEvents.length;
          organizedEvents.add(
            OrganizedEvent(
              left: yourSlotWidth + i * width,
              top: yourEvent.durationFromMidnight.inMinutes.toDouble(),
              width: width,
              height: yourEvent.duration.inMinutes.toDouble(),
              eventData: yourEvent,
            ),
          );
        }
        break;

      // 상대 일정만 겹치는 경우
      case OverlappedState.yoursOnly:
        final ourLeftStart = totalWidth * 2 / 3;
        final ourSlotWidth = totalWidth * 2 / 3;

        // 우리 일정 정렬
        for (int i = 0; i < ourEvents.length; i++) {
          final ourEvent = ourEvents[i];
          final width = ourSlotWidth / ourEvents.length;
          organizedEvents.add(
            OrganizedEvent(
              left: ourLeftStart + i * width,
              top: ourEvent.durationFromMidnight.inMinutes.toDouble(),
              width: width,
              height: ourEvent.duration.inMinutes.toDouble(),
              eventData: ourEvent,
            ),
          );
        }

        final mySlotWidth = totalWidth / 2;
        // 나의 이벤트
        for (int i = 0; i < myEvents.length; i++) {
          final myEvent = myEvents[i];
          final width = mySlotWidth / myEvents.length;
          organizedEvents.add(
            OrganizedEvent(
              left: i * width,
              top: myEvent.durationFromMidnight.inMinutes.toDouble(),
              width: width,
              height: myEvent.duration.inMinutes.toDouble(),
              eventData: myEvent,
            ),
          );
        }

        final yourSlotWidth = totalWidth / 3;

        for (int i = 0; i < yourEvents.length; i++) {
          final yourEvent = yourEvents[i];
          final width = yourSlotWidth / yourEvents.length;
          organizedEvents.add(
            OrganizedEvent(
              left: yourSlotWidth + i * width,
              top: yourEvent.durationFromMidnight.inMinutes.toDouble(),
              width: width,
              height: yourEvent.duration.inMinutes.toDouble(),
              eventData: yourEvent,
            ),
          );
        }
        break;
      case OverlappedState.both:
        final slotWidth = totalWidth / 3;

        // 우리 일정 정렬
        for (int i = 0; i < ourEvents.length; i++) {
          final ourEvent = ourEvents[i];
          final width = slotWidth / ourEvents.length;
          organizedEvents.add(
            OrganizedEvent(
              left: slotWidth + i * width,
              top: ourEvent.durationFromMidnight.inMinutes.toDouble(),
              width: width,
              height: ourEvent.duration.inMinutes.toDouble(),
              eventData: ourEvent,
            ),
          );
        }
        // 나의 이벤트
        for (int i = 0; i < myEvents.length; i++) {
          final myEvent = myEvents[i];
          final width = slotWidth / myEvents.length;
          organizedEvents.add(
            OrganizedEvent(
              left: i * width,
              top: myEvent.durationFromMidnight.inMinutes.toDouble(),
              width: width,
              height: myEvent.duration.inMinutes.toDouble(),
              eventData: myEvent,
            ),
          );
        }

        for (int i = 0; i < yourEvents.length; i++) {
          final yourEvent = yourEvents[i];
          final width = slotWidth / yourEvents.length;
          organizedEvents.add(
            OrganizedEvent(
              left: slotWidth * 2 + i * width,
              top: yourEvent.durationFromMidnight.inMinutes.toDouble(),
              width: width,
              height: yourEvent.duration.inMinutes.toDouble(),
              eventData: yourEvent,
            ),
          );
        }

        break;
      default:
        break;
    }
  } else {
    final slotWidth = totalWidth / 2;

    // 나의 이벤트
    for (int i = 0; i < myEvents.length; i++) {
      final myEvent = myEvents[i];
      final width = slotWidth / myEvents.length;
      organizedEvents.add(
        OrganizedEvent(
          left: i * width,
          top: myEvent.durationFromMidnight.inMinutes.toDouble(),
          width: width,
          height: myEvent.duration.inMinutes.toDouble(),
          eventData: myEvent,
        ),
      );
    }

    for (int i = 0; i < yourEvents.length; i++) {
      final yourEvent = yourEvents[i];
      final width = slotWidth / yourEvents.length;
      organizedEvents.add(
        OrganizedEvent(
          left: slotWidth + i * width,
          top: yourEvent.durationFromMidnight.inMinutes.toDouble(),
          width: width,
          height: yourEvent.duration.inMinutes.toDouble(),
          eventData: yourEvent,
        ),
      );
    }

    // "우리"이벤트가 없을 때
  }
  return organizedEvents;
}
