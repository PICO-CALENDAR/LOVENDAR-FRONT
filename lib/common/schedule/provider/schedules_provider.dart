import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico/calendar/provider/checked_category_provider.dart';
import 'package:pico/common/model/custom_exception.dart';
import 'package:pico/common/model/event_controller.dart';
import 'package:pico/common/schedule/model/delete_repeat_schedule_body.dart';
import 'package:pico/common/schedule/model/schedule_model.dart';
import 'package:pico/common/schedule/model/update_schedule_body.dart';
import 'package:pico/common/schedule/repository/schedule_repository.dart';
import 'package:pico/common/utils/extenstions.dart';

final schedulesProvider =
    StateNotifierProvider<SchedulesProvider, List<ScheduleModel>>((ref) {
  final repository = ref.watch(scheduleRepositoryProvider);
  final checkedCategoryState = ref.watch(checkedCategoryProvider);
  return SchedulesProvider(
    repository: repository,
    checkedCategoryState: checkedCategoryState,
  );
});

// Notifier 클래스
class SchedulesProvider extends StateNotifier<List<ScheduleModel>> {
  final ScheduleRepository repository;
  final Map<ScheduleType, bool> checkedCategoryState;

  SchedulesProvider({
    required this.repository,
    required this.checkedCategoryState,
  }) : super([]) {
    // refreshSchedulesInWeek();
    refreshSchedules();
  }

  // 전체 스케줄 가져오기
  // TODO: Future로 바꿔서 로딩 표시해야함
  void refreshSchedules({int? year}) async {
    try {
      year ??= DateTime.now().year;

      final response = await repository.getSchedulesByYear(year.toString());
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
        scheduleId: scheduleId.toString(),
      );

      if (response.success) {
        // 해당 scheduleId를 제외한 새로운 리스트를 생성
        state = state
            .where((schedule) =>
                schedule.scheduleId != response.schedule.scheduleId)
            .toList();
      } else {
        throw CustomException("삭제에 실패하였습니다.");
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) {
        throw CustomException("상대방 일정은 삭제할 수 없습니다.");
      }
    } catch (e) {
      throw CustomException("삭제에 실패하였습니다.");
    }
  }

  // 일정 삭제 (반복 일정)
  Future<void> deleteRepeatSchedule({
    required int scheduleId,
    required DateTime repeatEndDate,
  }) async {
    try {
      final response = await repository.postDeleteRepeatSchedule(
        scheduleId: scheduleId.toString(),
        body: DeleteRepeatScheduleBody(
          repeatEndDate: repeatEndDate.toIso8601String(),
        ),
      );

      if (response.success) {
        // 해당 scheduleId를 제외한 새로운 리스트를 생성
        state = state
            .where((schedule) =>
                schedule.scheduleId != response.schedule.scheduleId)
            .toList();
      } else {
        throw CustomException("삭제에 실패하였습니다.");
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) {
        throw CustomException("상대방 일정은 삭제할 수 없습니다.");
      }
    } catch (e) {
      throw CustomException("삭제에 실패하였습니다.");
    }
  }

  // 일정 추가
  Future<void> postAddSchedule(ScheduleModelBase body) async {
    try {
      final response = await repository.postAddSchedule(body);
      if (response.success) {
        state = [...state, response.schedule];
        // refreshSchedules();
      } else {
        throw CustomException("일정 추가 실패");
      }
    } catch (e) {
      rethrow;
    }
  }

  //일정 수정
  Future<void> postEditSchedule(
      {required String scheduleId, required UpdateScheduleBody body}) async {
    try {
      final response = await repository.postUpdateSchedule(
          scheduleId: scheduleId, body: body);
      if (response.success) {
        int index = state.indexWhere(
            (schedule) => schedule.scheduleId == response.schedule.scheduleId);

        state = index != -1
            ? [
                ...state.sublist(0, index),
                response.schedule,
                ...state.sublist(index + 1),
              ]
            : [...state, response.schedule];
        // refreshSchedules();
      } else {
        throw CustomException("일정 수정 실패");
      }
    } catch (e) {
      rethrow;
    }
  }

  // 일정 캐싱 초기화
  void resetSchedules() {
    state = [];
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
      // return date.isSameDate(schedule.startTime) ||
      //     date.isAfter(schedule.startTime) &&
      //         (date.isBefore(schedule.endTime) ||
      //             date.isSameDate(schedule.endTime));

      return schedule.isEventOnDate(targetDate: date);
    }

    final allDaySchedules = state
        .where((schedule) =>
            schedule.isAllDay &&
            isScheduleInGivenDate(schedule) &&
            schedule.category == category)
        .toList();

    final allDaySchedulesObj = allDaySchedules
        .map(
          (s) => s.copyScheduleOnDate(targetDate: date),
        )
        .whereType<ScheduleModel>()
        .toList();

    return allDaySchedulesObj;
  }

  // 월간뷰에서 스케줄 컬럼화 정리
  List<ColumnedScheduleData> organizeSchedules(
    List<ScheduleModel> schedules,
    DateTime monthStart,
    DateTime monthEnd,
  ) {
    List<ScheduleModel> expandedSchedules = [];
    for (var schedule in schedules) {
      if (!schedule.isRepeat) {
        // 반복 일정이 아닌 경우 그대로 추가
        expandedSchedules.add(schedule);
      } else {
        // 반복 일정 처리
        DateTime currentOccurrence = schedule.startTime;

        DateTime repeatEnd = schedule.repeatEndDate ?? monthEnd;

        // print(schedule.toJson());

        // print(
        //     "${schedule.title}: ${schedule.startTime} ${currentOccurrence.isBefore(monthEnd)}");

        // 반복 일정이 현재 월에 포함되는 경우만 추가
        while (currentOccurrence.isBefore(monthEnd) ||
            currentOccurrence.isSameDate(monthEnd)) {
          // 현재 발생일이 월간 범위에 포함될 때만 추가
          if ((currentOccurrence.isSameDate(monthStart) ||
                  currentOccurrence.isAfter(monthStart)) &&
              currentOccurrence
                  .isBefore(repeatEnd.add(const Duration(days: 1)))) {
            final updatedEndTime = currentOccurrence.add(schedule.duration);
            expandedSchedules.add(ScheduleModel.copyWith(
              original: schedule,
              startTime: DateTime(
                  currentOccurrence.year,
                  currentOccurrence.month,
                  currentOccurrence.day,
                  schedule.startTime.hour,
                  schedule.startTime.minute),
              endTime: DateTime(
                  updatedEndTime.year,
                  updatedEndTime.month,
                  updatedEndTime.day,
                  schedule.endTime.hour,
                  schedule.endTime.minute),
            ));
          }

          // 다음 반복 주기 계산
          switch (schedule.repeatType) {
            case RepeatType.DAILY:
              currentOccurrence =
                  currentOccurrence.add(const Duration(days: 1));
              break;
            case RepeatType.WEEKLY:
              currentOccurrence =
                  currentOccurrence.add(const Duration(days: 7));
              break;
            case RepeatType.BIWEEKLY:
              currentOccurrence =
                  currentOccurrence.add(const Duration(days: 14));
              break;
            case RepeatType.MONTHLY:
              currentOccurrence = DateTime(currentOccurrence.year,
                  currentOccurrence.month + 1, currentOccurrence.day);
              break;
            case RepeatType.YEARLY:
              currentOccurrence = DateTime(currentOccurrence.year + 1,
                  currentOccurrence.month, currentOccurrence.day);
              break;
            default:
              break;
          }

          // 반복 종료 조건
          if (schedule.repeatEndDate != null &&
              currentOccurrence.isAfter(schedule.repeatEndDate!)) {
            break;
          }
        }
      }
    }

    List<ColumnedScheduleData> columnedSchedules =
        []; // 1. 이벤트를 시작 날짜 기준으로 정렬 (같은 시작 날짜면 종료 날짜 기준으로 정렬)

    expandedSchedules.sort((a, b) {
      if (a.startTime.isSameDate(b.startTime)) {
        return a.endTime.withoutTime.compareTo(b.endTime.withoutTime);
      }
      return a.startTime.withoutTime.compareTo(b.startTime.withoutTime);
    });

    // 2. 열(column) 상태를 추적하는 리스트
    List<DateTime> columns = []; // 각 열의 종료 날짜 저장

    for (var schedule in expandedSchedules) {
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
  // List<ColumnedScheduleData> filterAndSortSchedulesForWeek(
  //     List<ColumnedScheduleData> schedules,
  //     DateTime weekStart,
  //     DateTime weekEnd) {
  //   return schedules
  //       .where((schedule) =>
  //           schedule.scheduleData.startTime.withoutTime
  //               .isBefore(weekEnd.withoutTime.add(const Duration(days: 1))) &&
  //           schedule.scheduleData.endTime.withoutTime.isAfter(
  //               weekStart.withoutTime.subtract(const Duration(days: 1))))
  //       .toList()
  //     ..sort((a, b) => a.column.compareTo(b.column));
  // }

  List<ColumnedScheduleData> filterAndSortSchedulesForWeek(
      List<ColumnedScheduleData> schedules,
      DateTime weekStart,
      DateTime weekEnd) {
    final result = schedules.where((schedule) {
      final startTime = schedule.scheduleData.startTime.withoutTime;
      final endTime = schedule.scheduleData.endTime.withoutTime;

      // if (startTime.isBefore(weekStart.withoutTime) &&
      //     (endTime.isAfter(weekStart.withoutTime) ||
      //         endTime.isSameDate(weekStart.withoutTime))) {
      //   return true;
      // }

      // if (endTime.isAfter(weekEnd.withoutTime) &&
      //         startTime.isBefore(weekEnd.withoutTime) ||
      //     startTime.isSameDate(weekEnd.withoutTime)) {
      //   return true;
      // }
      return (startTime.isBefore(weekEnd.withoutTime) ||
              startTime.isSameDate(weekEnd.withoutTime)) &&
          (endTime.isAfter(weekStart.withoutTime) ||
              endTime.isSameDate(weekStart.withoutTime));
    }).toList();

    return result;
  }

  // List<ColumnedScheduleData> filterAndSortSchedulesForWeek(
  //     List<ColumnedScheduleData> schedules,
  //     DateTime weekStart,
  //     DateTime weekEnd) {
  //   return schedules.where((schedule) {
  //     print("${schedule.scheduleData.title} ${schedule.column}");
  //     // 반복 일정이 아닌 경우 기존 조건 필터링
  //     return schedule.scheduleData.startTime.withoutTime
  //             .isBefore(weekEnd.withoutTime.add(const Duration(days: 1))) &&
  //         schedule.scheduleData.endTime.withoutTime
  //             .isAfter(weekStart.withoutTime.subtract(const Duration(days: 1)));
  //   }).toList()
  //     ..sort((a, b) => a.column.compareTo(b.column));
  // }

  // 특정 날짜에 해당하는 스케줄
  List<ScheduleModel> getSchedulesForDate({
    required DateTime date,
    required List<ScheduleModel> schedules,
  }) {
    final filteredSchedules = schedules.where((schedule) {
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

// 주간 범위 내에 일정이 존재하는지 확인
// bool _isWithinWeek(
//     DateTime start, DateTime end, DateTime weekStart, DateTime weekEnd) {
//   return start.isBefore(weekEnd.add(const Duration(days: 1))) &&
//       end.isAfter(weekStart.subtract(const Duration(days: 1)));
// }
