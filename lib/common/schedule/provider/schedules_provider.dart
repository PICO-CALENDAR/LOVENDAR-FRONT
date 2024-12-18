import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico/common/model/event_controller.dart';
import 'package:pico/common/schedule/model/schedule_model.dart';
import 'package:pico/common/schedule/repository/schedule_repository.dart';
import 'package:pico/common/utils/extenstions.dart';

final schedulesProvider =
    StateNotifierProvider<SchedulesProvider, List<ScheduleModel>>((ref) {
  final repository = ref.watch(scheduleRepositoryProvider);
  return SchedulesProvider(repository: repository);
});

// Notifier 클래스
class SchedulesProvider extends StateNotifier<List<ScheduleModel>> {
  final ScheduleRepository repository;

  SchedulesProvider({
    required this.repository,
  }) : super([]) {
    // refreshSchedulesInWeek();
    refreshSchedules();
  }

  // 전체 스케줄 가져오기
  // TODO: Future로 바꿔서 로딩 표시해야함
  void refreshSchedules() async {
    try {
      final response =
          await repository.getSchedulesByYear(DateTime.now().year.toString());
      // TODO: 일주일만 가져올때, 연도 바뀔때 처리해야 함
      state = [...response.items];
    } catch (e) {
      print(e);
    }
  }

  // 이번주 스케줄 가져오기
  List<ScheduleModel> getSchedulesInWeek() {
    final today = DateTime.now();
    // 날짜가 속한 주의 월요일 0시 계산
    final firstDayOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final startOfWeek =
        DateTime(firstDayOfWeek.year, firstDayOfWeek.month, firstDayOfWeek.day);

    // 날짜가 속한 주의 일요일 23:59:59 계산
    final lastDayOfWeek = startOfWeek.add(const Duration(days: 6));
    final endOfWeek = DateTime(
        lastDayOfWeek.year, lastDayOfWeek.month, lastDayOfWeek.day, 23, 59, 59);

    // 여기를 구현
    return state.where((schedule) {
      return schedule.startTime.isBefore(endOfWeek) &&
          schedule.endTime.isAfter(startOfWeek);
    }).toList();
  }

  // 일정 삭제 (반복 아닌 일정)
  Future<void> deleteSchedule(int scheduleId) async {
    try {
      final response = await repository.postDeleteSchedule(
          scheduleId: scheduleId.toString());

      if (response.success) {
        refreshSchedules();
      } else {
        throw Exception("삭제에 실패하였습니다.");
      }
    } catch (e) {
      throw Exception("삭제에 실패하였습니다.");
    }
  }

  // 특정 날짜에 해당하는 하루종일 일정 가져오기
  List<ScheduleModel> getAllDaySchedulesByDate(DateTime date) {
    bool isScheduleInGivenDate(ScheduleModel schedule) {
      return date.isSameDate(schedule.startTime) ||
          date.isAfter(schedule.startTime) &&
              (date.isBefore(schedule.endTime) ||
                  date.isSameDate(schedule.endTime));
    }

    return state
        .where(
            (schedule) => schedule.isAllDay && isScheduleInGivenDate(schedule))
        .toList();
  }

  // 특정 날짜와 카테고리에 해당하는 하루종일 일정 가져오기
  List<ScheduleModel> getAllDaySchedulesByDateAndCat({
    required DateTime date,
    required ScheduleType category,
  }) {
    bool isScheduleInGivenDate(ScheduleModel schedule) {
      return date.isSameDate(schedule.startTime) ||
          date.isAfter(schedule.startTime) &&
              (date.isBefore(schedule.endTime) ||
                  date.isSameDate(schedule.endTime));
    }

    return state
        .where((schedule) =>
            schedule.isAllDay &&
            isScheduleInGivenDate(schedule) &&
            schedule.category == category)
        .toList();
  }

  // 월간뷰에서 스케줄 컬럼화 정리
  List<ColumnedScheduleData> organizeSchedules() {
    List<ColumnedScheduleData> columnedSchedules =
        []; // 1. 이벤트를 시작 날짜 기준으로 정렬 (같은 시작 날짜면 종료 날짜 기준으로 정렬)
    state.sort((a, b) {
      if (a.startTime.isSameDate(b.startTime)) {
        return a.endTime.withoutTime.compareTo(b.endTime.withoutTime);
      }
      return a.startTime.withoutTime.compareTo(b.startTime.withoutTime);
    });

    // 2. 열(column) 상태를 추적하는 리스트
    List<DateTime> columns = []; // 각 열의 종료 날짜 저장

    for (var schedule in state) {
      bool foundColumn = false;

      // 3. 사용 가능한 열 찾기
      for (int i = 0; i < columns.length; i++) {
        // print("${event.title} : ${event.startTime}");
        // print(columns);
        // print(columns[i].withoutTime.isBefore(event.startTime.withoutTime));
        // print(i + 1);
        if (columns[i].withoutTime.isBefore(schedule.startTime.withoutTime)) {
          // 열이 비어 있다면 해당 열에 이벤트 배치
          columns[i] = schedule.endTime;
          final organized = ColumnedScheduleData(
              scheduleData: schedule, column: i + 1); // 열 번호는 1부터 시작
          columnedSchedules.add(organized);
          foundColumn = true;
          break;
        }
      }

      // 4. 사용 가능한 열이 없다면 새로운 열 생성
      if (!foundColumn) {
        columns.add(schedule.endTime);
        final organized = ColumnedScheduleData(
            scheduleData: schedule, column: columns.length); // 새 열 번호는 현재 열 개수
        columnedSchedules.add(organized);
      }
    }

    return columnedSchedules;
  }

  // 특정 기간에 속하는 일정 스케줄 리스트만
  List<ColumnedScheduleData> filterAndSortSchedulesForWeek(
      List<ColumnedScheduleData> schedules,
      DateTime weekStart,
      DateTime weekEnd) {
    return schedules
        .where((schedule) =>
            schedule.scheduleData.startTime.withoutTime
                .isBefore(weekEnd.withoutTime.add(const Duration(days: 1))) &&
            schedule.scheduleData.endTime.withoutTime.isAfter(
                weekStart.withoutTime.subtract(const Duration(days: 1))))
        .toList()
      ..sort((a, b) => a.column.compareTo(b.column));
  }

  // 특정 날짜에 해당하는 스케줄
  List<ScheduleModel> getSchedulesForDate(DateTime date) {
    final filteredSchedules = state.where((schedule) {
      // 이벤트가 해당 날짜 범위 안에 포함되는지 확인
      return schedule.startTime.withoutTime
              .isBefore(date.withoutTime.add(const Duration(days: 1))) &&
          schedule.endTime.withoutTime
              .isAfter(date.withoutTime.subtract(const Duration(days: 1)));
    }).toList();

    // 시작 시간을 기준으로 정렬
    filteredSchedules.sort((a, b) => a.startTime.compareTo(b.startTime));

    return filteredSchedules;
  }
}

class ColumnedScheduleData {
  ScheduleModel scheduleData;
  final int column;

  ColumnedScheduleData({
    required this.scheduleData,
    required this.column,
  });
}
