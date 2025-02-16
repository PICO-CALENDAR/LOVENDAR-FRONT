import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico/common/schedule/model/schedule_model.dart';

final checkedCategoryProvider =
    StateNotifierProvider<CheckedCategoryNotifier, Map<ScheduleType, bool>>(
        (ref) {
  return CheckedCategoryNotifier();
});

// StateNotifier 정의
class CheckedCategoryNotifier extends StateNotifier<Map<ScheduleType, bool>> {
  CheckedCategoryNotifier()
      : super({
          ScheduleType.MINE: true,
          ScheduleType.YOURS: true,
          ScheduleType.OURS: true,
        });

  void toggleCategory(ScheduleType type) {
    print(state);
    state = {
      ...state,
      type: !state[type]!,
    };
  }
}
