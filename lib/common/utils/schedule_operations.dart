import 'package:lovendar/common/model/custom_calendar.dart';
import 'package:lovendar/common/schedule/model/schedule_model.dart';
import 'package:lovendar/common/utils/extenstions.dart';

// 시간대가 겹치는 이벤트 그룹화
// List<List<ScheduleModel>> groupOverlappingSchedules({
//   required List<ScheduleModel> schedules,
// }) {
//   // 하루 종일 이벤트 제외
//   final filteredSchedules =
//       schedules.where((schedule) => !schedule.isAllDay).toList();

//   // 이벤트 리스트가 비어있으면 빈 리스트 반환
//   if (filteredSchedules.isEmpty) return [];

//   // 시작 시간 기준으로 정렬
//   filteredSchedules.sort((a, b) => a.startTime.compareTo(b.startTime));

//   final List<List<ScheduleModel>> groupedSchedules = [];
//   List<ScheduleModel> currentGroup = [filteredSchedules.first];

//   for (int i = 1; i < filteredSchedules.length; i++) {
//     final currentSchedule = filteredSchedules[i];
//     final lastScheduleInGroup = currentGroup.last;
//     print("$i 번째");
//     print("현재 그룹 상태:  ${groupedSchedules.toString()}");
//     print("현재 값:  ${currentSchedule.toJson()}");
//     print("그룹의 마지막 값:  ${lastScheduleInGroup.toJson()}");

//     // // 현재 이벤트가 그룹의 마지막 이벤트와 겹치더라도, 시간이 포함되지 않으면 새로운 그룹 시작
//     // if (!currentSchedule.startTime.isBefore(lastScheduleInGroup.endTime) &&
//     //     !currentSchedule.startTime
//     //         .isAtSameMomentAs(lastScheduleInGroup.endTime)) {
//     //   groupedSchedules.add(currentGroup);
//     //   currentGroup = [currentSchedule];
//     // } else {
//     //   // 현재 이벤트를 그룹에 추가
//     //   currentGroup.add(currentSchedule);
//     // }

//     // 겹침 확인 로직 수정
//     if (currentSchedule.startTime.isBefore(lastScheduleInGroup.endTime) &&
//         currentSchedule.endTime.isAfter(lastScheduleInGroup.startTime)) {
//       // 겹치면 현재 그룹에 추가
//       currentGroup.add(currentSchedule);
//     } else {
//       // 겹치지 않으면 새로운 그룹 시작
//       groupedSchedules.add(currentGroup);
//       currentGroup = [currentSchedule];
//     }
//   }

//   // 마지막 그룹 추가
//   groupedSchedules.add(currentGroup);

//   // 디버그용 출력
//   for (var group in groupedSchedules) {
//     print(group.map((s) => s.title).toList());
//   }
//   return groupedSchedules;
// }

List<List<ScheduleModel>> groupOverlappingSchedules({
  required List<ScheduleModel> schedules,
}) {
  final filteredSchedules =
      schedules.where((schedule) => !schedule.isAllDay).toList();

  if (filteredSchedules.isEmpty) return [];

  filteredSchedules.sort((a, b) => a.startTime.compareTo(b.startTime));

  final List<List<ScheduleModel>> groupedSchedules = [];
  List<ScheduleModel> currentGroup = [filteredSchedules.first];

  for (int i = 1; i < filteredSchedules.length; i++) {
    final currentSchedule = filteredSchedules[i];

    // 현재 그룹에서 가장 이른 시작 시간과 가장 늦은 종료 시간 계산
    final earliestStartTime = currentGroup
        .map((s) => s.startTime)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    final latestEndTime = currentGroup
        .map((s) => s.endTime)
        .reduce((a, b) => a.isAfter(b) ? a : b);

    // print("$i 번째");
    // print("현재 그룹 상태:  ${groupedSchedules.toString()}");
    // print("현재 값:  ${currentSchedule.toJson()}");
    // print("그룹의 가장 이른 시작 시간: $earliestStartTime");
    // print("그룹의 가장 늦은 종료 시간: $latestEndTime");

    // 현재 일정이 그룹과 겹치는지 확인
    if (currentSchedule.startTime.isBefore(latestEndTime) &&
        currentSchedule.endTime.isAfter(earliestStartTime)) {
      // 겹치면 그룹에 추가
      currentGroup.add(currentSchedule);
    } else {
      // 겹치지 않으면 새 그룹 생성
      groupedSchedules.add(currentGroup);
      currentGroup = [currentSchedule];
    }
  }

  // 마지막 그룹 추가
  groupedSchedules.add(currentGroup);

  // 디버그용 출력
  for (var group in groupedSchedules) {
    print(group.map((s) => s.title).toList());
  }
  return groupedSchedules;
}

// List<List<ScheduleModel>> groupOverlappingSchedules({
//   required List<ScheduleModel> schedules,
// }) {
//   // 하루 종일 이벤트 제외
//   final filteredSchedules =
//       schedules.where((schedule) => !schedule.isAllDay).toList();

//   // 이벤트 리스트가 비어있으면 빈 리스트 반환
//   if (filteredSchedules.isEmpty) return [];

//   // 시작 시간 기준으로 정렬
//   filteredSchedules.sort((a, b) => a.startTime.compareTo(b.startTime));

//   final List<List<ScheduleModel>> groupedSchedules = [];
//   final Set<int> processedIndices = {}; // 이미 처리된 인덱스를 추적

//   for (int i = 0; i < filteredSchedules.length; i++) {
//     if (processedIndices.contains(i)) {
//       // 이미 처리된 이벤트는 건너뜀
//       continue;
//     }

//     final List<ScheduleModel> currentGroup = [];
//     for (int j = 0; j < filteredSchedules.length; j++) {
//       if (i == j || processedIndices.contains(j)) {
//         // 자기 자신이거나 이미 처리된 이벤트는 건너뜀
//         continue;
//       }

//       final eventA = filteredSchedules[i];
//       final eventB = filteredSchedules[j];

//       // 겹침 여부 확인
//       if (eventA.startTime.isBefore(eventB.endTime) &&
//           eventA.endTime.isAfter(eventB.startTime)) {
//         if (!currentGroup.contains(eventA)) {
//           currentGroup.add(eventA);
//         }
//         if (!currentGroup.contains(eventB)) {
//           currentGroup.add(eventB);
//         }
//       }
//     }

//     if (!currentGroup.contains(filteredSchedules[i])) {
//       currentGroup.add(filteredSchedules[i]);
//     }

//     // 현재 그룹에 있는 모든 이벤트를 처리된 것으로 표시
//     for (var event in currentGroup) {
//       processedIndices.add(filteredSchedules.indexOf(event));
//     }

//     groupedSchedules.add(currentGroup);
//   }

//   return groupedSchedules;
// }

// 이벤트 병합하여 시간 범위 반환
MergedSchedule mergeSchedulesAndGetTime(List<ScheduleModel> schedules) {
  if (schedules.isEmpty) {
    throw ArgumentError('Schedule list cannot be empty');
  }

  final minStart =
      schedules.map((s) => s.startTime).reduce((a, b) => a.isBefore(b) ? a : b);
  final maxEnd =
      schedules.map((s) => s.endTime).reduce((a, b) => a.isAfter(b) ? a : b);

  return MergedSchedule(
      startTime: minStart, endTime: maxEnd, mergedSchedules: schedules);
}

// 특정 시간 범위와 겹치는 이벤트 반환
List<ScheduleModel> findOverlappingSchedulesByTime(
  List<ScheduleModel> schedules,
  DateTime startTime,
  DateTime endTime,
) {
  return schedules.where((schedule) {
    return schedule.startTime.isBefore(endTime) &&
        schedule.endTime.isAfter(startTime);
  }).toList();
}

List<List<ScheduleModel>> calculateScheduleColumns(
    List<ScheduleModel> schedules) {
  if (schedules.isEmpty) return [];

  // 겹치는 이벤트 그룹 가져오기
  List<List<ScheduleModel>> overlappingGroups =
      groupOverlappingSchedules(schedules: schedules);

  Map<ScheduleModel, int> scheduleColumns = {};
  Map<int, List<ScheduleModel>> columnToSchedules = {}; // 각 열에 해당하는 이벤트 리스트
  int maxColumnUsed = 0; // 총 열의 최대값 추적

  for (var group in overlappingGroups) {
    if (group.isEmpty) continue;

    // 그룹의 모든 이벤트를 열에 할당
    maxColumnUsed = assignColumnsForGroup(
        group, scheduleColumns, columnToSchedules, maxColumnUsed);
  }

  // 결과 반환: 열 번호별로 정렬된 리스트 생성
  List<List<ScheduleModel>> result = [];
  for (int i = 0; i <= maxColumnUsed; i++) {
    result.add(columnToSchedules[i] ?? []);
  }
  return result;
}

// 그룹의 이벤트를 열에 할당하고 최대 열 번호 반환
int assignColumnsForGroup(
    List<ScheduleModel> group,
    Map<ScheduleModel, int> scheduleColumns,
    Map<int, List<ScheduleModel>> columnToSchedules,
    int maxColumnUsed) {
  // 이벤트를 시작 시간 기준으로 정렬
  group.sort((a, b) => a.startTime.compareTo(b.startTime));

  for (var schedule in group) {
    // 겹치는 열을 계산
    var overlappingColumns = group
        .where((s) =>
            s != schedule &&
            s.startTime.isBefore(schedule.endTime) &&
            s.endTime.isAfter(schedule.startTime))
        .map((s) => scheduleColumns[s]);

    // 사용 가능한 최소 열 번호 찾기
    int column = 0;
    while (overlappingColumns.contains(column)) {
      column++;
    }

    // 열 배정
    scheduleColumns[schedule] = column;

    // 열별 이벤트 리스트 갱신
    if (!columnToSchedules.containsKey(column)) {
      columnToSchedules[column] = [];
    }
    columnToSchedules[column]!.add(schedule);

    // 최대 열 번호 갱신
    maxColumnUsed = maxColumnUsed > column ? maxColumnUsed : column;
  }

  return maxColumnUsed;
}

// OrganizedShedule 생성 헬퍼 함수
List<OrganizedSchedule> createOrganizedSchedules({
  required List<ScheduleModel> schedules,
  required double slotWidth,
  required double leftStart,
}) {
  final columns = calculateScheduleColumns(
    schedules,
  );
  final columnCount = columns.length;
  final baseWidth = slotWidth / columnCount;

  final List<OrganizedSchedule> organizedSchedule = [];

  for (int i = 0; i < columnCount; i++) {
    for (var schedule in columns[i]) {
      // 기본 너비는 현재 열에 해당하는 너비
      double scheduleWidth = baseWidth;

      // 오른쪽 열과 겹치지 않는 경우를 확인하여 너비를 확장
      for (int j = i + 1; j < columnCount; j++) {
        // 오른쪽 열에 이벤트가 없거나 현재 이벤트와 겹치지 않으면 너비 확장
        bool hasOverlap = columns[j].any((e) =>
            e.startTime.isBefore(schedule.endTime) &&
            e.endTime.isAfter(schedule.startTime));
        if (hasOverlap) break;

        // 겹치지 않으면 너비 확장
        scheduleWidth += baseWidth;
      }

      // OrganizedShedule 생성
      organizedSchedule.add(
        OrganizedSchedule(
          left: leftStart + i * baseWidth, // 시작 위치는 열 번호에 따라 계산
          top: schedule.durationFromMidnight.inMinutes.toDouble(),
          width: scheduleWidth, // 계산된 너비 사용
          height: schedule.duration.inMinutes.toDouble(),
          scheduleData: schedule,
        ),
      );
    }
  }

  return organizedSchedule;
}

// 모든 이벤트를 OrganizedShedule로 변환
List<OrganizedSchedule> getOrganizedSchedules({
  required List<ScheduleModel> overlappingSchedules,
  required double viewWidth,
}) {
  final double totalWidth = viewWidth;
  final List<OrganizedSchedule> organizedSchedules = [];

  final mySchedules = overlappingSchedules
      .where((schedule) => schedule.category == ScheduleType.MINE)
      .toList();
  final yourSchedules = overlappingSchedules
      .where((schedule) => schedule.category == ScheduleType.YOURS)
      .toList();
  final ourSchedules = overlappingSchedules
      .where((schedule) => schedule.category == ScheduleType.OURS)
      .toList();

  if (ourSchedules.isNotEmpty) {
    // "우리" 이벤트 병합
    final mergedOurSchedule = mergeSchedulesAndGetTime(ourSchedules);
    final otherSchedules = [...mySchedules, ...yourSchedules];

    // 병합된 "우리" 이벤트와 겹치는 나와 상대 이벤트 확인
    final overlappedSchedules = findOverlappingSchedulesByTime(
      otherSchedules,
      mergedOurSchedule.startTime,
      mergedOurSchedule.endTime,
    );
    final overlappedState = checkScheduleCategories(overlappedSchedules);

    switch (overlappedState) {
      case OverlappedState.none:
        organizedSchedules.addAll(
          createOrganizedSchedules(
            schedules: ourSchedules,
            slotWidth: totalWidth,
            leftStart: 0,
          ),
        );
        organizedSchedules.addAll(
          createOrganizedSchedules(
            schedules: mySchedules,
            slotWidth: totalWidth / 2,
            leftStart: 0,
          ),
        );

        organizedSchedules.addAll(
          createOrganizedSchedules(
            schedules: yourSchedules,
            slotWidth: totalWidth / 2,
            leftStart: totalWidth / 2,
          ),
        );
        break;

      case OverlappedState.mineOnly:
        organizedSchedules.addAll(
          createOrganizedSchedules(
            schedules: ourSchedules,
            slotWidth: totalWidth * 2 / 3,
            leftStart: totalWidth / 3,
          ),
        );

        organizedSchedules.addAll(
          createOrganizedSchedules(
            schedules: mySchedules,
            slotWidth: totalWidth / 3,
            leftStart: 0,
          ),
        );

        organizedSchedules.addAll(
          createOrganizedSchedules(
            schedules: yourSchedules,
            slotWidth: totalWidth / 2,
            leftStart: totalWidth / 2,
          ),
        );
        break;

      case OverlappedState.yoursOnly:
        organizedSchedules.addAll(
          createOrganizedSchedules(
            schedules: ourSchedules,
            slotWidth: totalWidth * 2 / 3,
            leftStart: 0,
          ),
        );
        organizedSchedules.addAll(
          createOrganizedSchedules(
            schedules: mySchedules,
            slotWidth: totalWidth / 2,
            leftStart: 0,
          ),
        );
        organizedSchedules.addAll(
          createOrganizedSchedules(
            schedules: yourSchedules,
            slotWidth: totalWidth / 3,
            leftStart: totalWidth * 2 / 3,
          ),
        );
        break;

      case OverlappedState.both:
        organizedSchedules.addAll(
          createOrganizedSchedules(
            schedules: ourSchedules,
            slotWidth: totalWidth / 3,
            leftStart: totalWidth / 3,
          ),
        );
        organizedSchedules.addAll(
          createOrganizedSchedules(
            schedules: mySchedules,
            slotWidth: totalWidth / 3,
            leftStart: 0,
          ),
        );
        organizedSchedules.addAll(
          createOrganizedSchedules(
            schedules: yourSchedules,
            slotWidth: totalWidth / 3,
            leftStart: totalWidth * 2 / 3,
          ),
        );
        break;

      default:
        break;
    }
  } else {
    // "우리" 이벤트가 없을 때

    organizedSchedules.addAll(
      createOrganizedSchedules(
        schedules: mySchedules,
        slotWidth: totalWidth / 2,
        leftStart: 0,
      ),
    );
    organizedSchedules.addAll(
      createOrganizedSchedules(
        schedules: yourSchedules,
        slotWidth: totalWidth / 2,
        leftStart: totalWidth / 2,
      ),
    );
  }

  return organizedSchedules;
}

// 병합된 이벤트 클래스
class MergedSchedule {
  final DateTime startTime;
  final DateTime endTime;
  final List<ScheduleModel> mergedSchedules;

  MergedSchedule({
    required this.startTime,
    required this.endTime,
    required this.mergedSchedules,
  });
}

// OrganizedShedule 클래스
class OrganizedSchedule {
  final double left;
  final double top;
  final double width;
  final double height;
  final ScheduleModel scheduleData;

  OrganizedSchedule({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.scheduleData,
  });
}
