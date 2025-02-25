import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lovendar/common/schedule/model/schedule_model.dart';

final selectedDayProvider =
    StateNotifierProvider<SelectedDayProvider, DateTime>((ref) {
  return SelectedDayProvider();
});

// StateNotifier 정의
class SelectedDayProvider extends StateNotifier<DateTime> {
  SelectedDayProvider() : super(DateTime.now());

  void setSelectedDay(DateTime selected) {
    state = selected;
  }

  void resetSelectedDay() {
    state = DateTime.now();
  }
}
