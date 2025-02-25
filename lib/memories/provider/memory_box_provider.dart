import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lovendar/common/components/toast.dart';
import 'package:lovendar/common/model/custom_exception.dart';
import 'package:lovendar/common/schedule/model/schedule_model.dart';
import 'package:lovendar/memories/model/timecapsule_form.dart';
import 'package:lovendar/memories/provider/timecapsule_form_provider.dart';
import 'package:lovendar/memories/repository/memory_box_repository.dart';

final memoryBoxProvider =
    StateNotifierProvider<MemoryBoxProvider, List<ScheduleModel>>((ref) {
  final repository = ref.watch(memoryBoxRepositoryProvider);
  final timecapsuleForm = ref.watch(timecapsuleFormProvider);
  return MemoryBoxProvider(
      repository: repository, timecapsuleForm: timecapsuleForm);
});

// Notifier 클래스
class MemoryBoxProvider extends StateNotifier<List<ScheduleModel>> {
  final MemoryBoxRepository repository;
  final TimecapsuleForm timecapsuleForm;

  MemoryBoxProvider({required this.repository, required this.timecapsuleForm})
      : super([]);

  // 전체 스케줄 가져오기
  // void refreshSchedules({int? year}) async {
  //   try {
  //     year ??= DateTime.now().year;

  //     final response = await repository.getSchedulesByYear(year.to());
  //     // TODO: 일주일만 가져올때, 연도 바뀔때 처리해야 함
  //     state = [...response.items];
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // 타임캡슐 생성
  Future<void> createTimecapsule() async {
    try {
      if (timecapsuleForm.schedule == null ||
          timecapsuleForm.letter == null ||
          timecapsuleForm.letterTitle == null ||
          timecapsuleForm.photo == null) {
        throw CustomException("타임캡슐에 적절한 데이터가 들어가지 않았습니다.");
      }

      final multipartFile = await MultipartFile.fromFile(timecapsuleForm.photo!,
          filename: 'file');

      final response = await repository.postTimeCapsule(
        scheduleId: timecapsuleForm.schedule!.scheduleId,
        scheduleStartTime:
            timecapsuleForm.schedule!.startTime.toIso8601String(),
        scheduleEndTime: timecapsuleForm.schedule!.endTime.toIso8601String(),
        letterTitle: timecapsuleForm.letterTitle!,
        letter: timecapsuleForm.letter!,
        photo: [multipartFile],
      );

      print(response.toJson());
    } on DioException catch (e) {
      // API 응답에서 에러 메시지 추출
      final errorMessage = e.response?.data['message'] ?? "알 수 없는 오류가 발생했습니다.";
      throw CustomException(errorMessage);
    } catch (e) {
      print(e);
      throw CustomException("타임캡슐 생성에 실패하였습니다.");
    }
  }
}
