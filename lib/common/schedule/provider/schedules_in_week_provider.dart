import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico/common/schedule/model/schedule_model.dart';
import 'package:pico/common/schedule/repository/schedule_repository.dart';
import 'package:pico/common/utils/extenstions.dart';

final schedulesInWeekProvider =
    StateNotifierProvider<SchedulesInWeekProvider, List<ScheduleModel>>((ref) {
  final repository = ref.watch(scheduleRepositoryProvider);
  return SchedulesInWeekProvider(repository: repository);
});

// Notifier 클래스
class SchedulesInWeekProvider extends StateNotifier<List<ScheduleModel>> {
  final ScheduleRepository repository;

  SchedulesInWeekProvider({
    required this.repository,
  }) : super([]) {
    refreshSchedulesInWeek();
  }

  void refreshSchedulesInWeek() async {
    try {
      final response = await repository
          .getSchedulesByToday(DateTime.now().toIso8601String());
      print("response: ${response.items}");

      state = [...response.items];
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteSchedule(int scheduleId) async {
    try {
      final response = await repository.postDeleteSchedule(
          scheduleId: scheduleId.toString());

      if (response.success) {
        refreshSchedulesInWeek();
      } else {
        throw Exception("삭제에 실패하였습니다.");
      }
    } catch (e) {
      throw Exception("삭제에 실패하였습니다.");
    }
  }

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
}
