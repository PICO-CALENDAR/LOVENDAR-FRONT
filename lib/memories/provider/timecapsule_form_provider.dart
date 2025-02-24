import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico/common/schedule/model/schedule_model.dart';
import 'package:pico/memories/model/timecapsule_form.dart';
import 'package:pico/memories/repository/memory_box_repository.dart';
import 'package:retrofit/retrofit.dart';

final timecapsuleFormProvider =
    StateNotifierProvider<TimecapsuleFormProvider, TimecapsuleForm>((ref) {
  final repository = ref.watch(memoryBoxRepositoryProvider);
  return TimecapsuleFormProvider(
    repository: repository,
  );
});

// Notifier 클래스
class TimecapsuleFormProvider extends StateNotifier<TimecapsuleForm> {
  final MemoryBoxRepository repository;

  TimecapsuleFormProvider({
    required this.repository,
  }) : super(TimecapsuleForm());

  // 타임캡슐 데이터 업데이트
  void updateForm(
      {ScheduleModel? schedule,
      String? letterTitle,
      String? letter,
      String? photo}) {
    state = TimecapsuleForm(
      schedule: schedule ?? state.schedule,
      letterTitle: letterTitle ?? state.letterTitle,
      letter: letter ?? state.letter,
      photo: photo ?? state.photo,
    );
  }

  void resetPhoto() {
    state = TimecapsuleForm(
      schedule: state.schedule,
      letter: state.letter,
      photo: null,
    );
  }

  void resetAll() {
    state = TimecapsuleForm();
  }
}
