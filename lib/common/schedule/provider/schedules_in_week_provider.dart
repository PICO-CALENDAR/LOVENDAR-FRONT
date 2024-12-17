import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico/common/schedule/model/schedule_model.dart';
import 'package:pico/common/schedule/repository/schedule_repository.dart';

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
}
