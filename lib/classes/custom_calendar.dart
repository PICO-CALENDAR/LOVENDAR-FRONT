import 'package:flutter/material.dart';
import 'package:pico/theme/theme_light.dart';

enum EventCategory {
  mine,
  yours,
  ours,
}

class EventDetail {
  EventCategory category;
  String? repeat;

  EventDetail({
    required this.category,
    this.repeat,
  });
}

class PicoEvent {
  final String title; // 일정 제목
  final DateTime startTime; // 일정 시작 시간
  final DateTime endTime; // 일정 끝나는 시간
  final EventCategory category; // 일정 타입 (mine, yours, ours)
  final bool isAllDay; // 일정 하루종일 여부
  final String? meetingPeople; // 만나는 사람 리스트
  final Color color;
  Duration get durationFromMidnight {
    DateTime midnight =
        DateTime(startTime.year, startTime.month, startTime.day);
    return startTime.difference(midnight);
  }

  Duration get duration => endTime.difference(startTime);

  PicoEvent({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.category,
    required this.isAllDay,
    this.meetingPeople,
  }) : color = AppTheme.getEventCategoryColor(category);

  /// 간단한 toString 메서드로 객체 정보를 문자열로 변환
  @override
  String toString() {
    return 'PicoEvent(title: $title, startTime: $startTime, endTime: $endTime, '
        'category: $category, isAllDay: $isAllDay, meetingPeople: $meetingPeople)';
  }
}

// 나와 상대의 카테고리가 있는지 확인하는 함수
// 우리 카테고리가 겹치는지 확인할 수 있는 state는 포함되어 있지 않음
enum OverlappedState {
  none, // 아무 카테고리도 없음
  mineOnly, // "mine"만 있음
  yoursOnly, // "yours"만 있음
  both, // "mine"과 "yours" 둘 다 있음
}

OverlappedState checkEventCategories(List<PicoEvent> events) {
  bool hasMine = false;
  bool hasYours = false;

  for (var event in events) {
    if (event.category == EventCategory.mine) hasMine = true;
    if (event.category == EventCategory.yours) hasYours = true;

    // 두 조건이 모두 충족되면 더 이상 확인할 필요 없음
    if (hasMine && hasYours) return OverlappedState.both;
  }

  if (hasMine) return OverlappedState.mineOnly;
  if (hasYours) return OverlappedState.yoursOnly;
  return OverlappedState.none;
}


// class OrganizedEvent {}

// /// 일정 타입을 Enum으로 정의
// enum PicoEventCategory {
//   MINE, // 나의 일정
//   YOURS, // 상대방 일정
//   OURS, // 공유 일정
// }
