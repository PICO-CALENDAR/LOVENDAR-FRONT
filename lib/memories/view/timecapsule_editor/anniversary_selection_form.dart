// 기념일 선택 페이지
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lovendar/common/schedule/model/schedules_response.dart';
import 'package:lovendar/common/theme/theme_light.dart';
import 'package:lovendar/common/utils/date_operations.dart';
import 'package:lovendar/memories/components/form_step_description.dart';
import 'package:lovendar/memories/provider/timecapsule_form_provider.dart';
import 'package:lovendar/memories/repository/memory_box_repository.dart';

class AnniversarySelectionForm extends ConsumerStatefulWidget {
  const AnniversarySelectionForm({super.key});

  @override
  ConsumerState<AnniversarySelectionForm> createState() =>
      _AnniversarySelectionFormState();
}

class _AnniversarySelectionFormState
    extends ConsumerState<AnniversarySelectionForm> {
  late Future<SchedulesResponse> _futureAnniversaries;
  DateTime today = DateTime.now(); // 오늘 날짜

  @override
  void initState() {
    super.initState();
    _futureAnniversaries = _fetchAnniversaries();
  }

  Future<SchedulesResponse> _fetchAnniversaries() async {
    final repository = ref.read(memoryBoxRepositoryProvider);
    final response = await repository.getUpcomingAnniversaries();
    return response;
  }

  Future<void> _refreshData() async {
    setState(() {
      _futureAnniversaries = _fetchAnniversaries(); // 새 Future 할당하여 데이터 새로고침
    });
  }

  @override
  Widget build(BuildContext context) {
    final timecapsuleForm = ref.watch(timecapsuleFormProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormStepDescription(
            stepTitle: "다가오는 기념일을 선택해주세요",
            stepDescription: "선택한 기념일에 맞춰 타임캡슐이 열립니다.",
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: FutureBuilder<SchedulesResponse>(
                future: _futureAnniversaries,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.scaffoldBackgroundColor,
                      ),
                    ); // 로딩 표시
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "오류 발생: ${snapshot.error}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ); // 오류 메시지
                  } else if (!snapshot.hasData ||
                      snapshot.data!.items.isEmpty) {
                    return const Center(
                      child: Text(
                        "3개월 안에 다가올\n기념일이 없습니다.",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ); // 데이터 없음 처리
                  }

                  final anniversaries = snapshot.data!.items;

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    itemCount: anniversaries.length,
                    itemBuilder: (context, index) {
                      final currentAnniversary = anniversaries[index];
                      bool isSelected = timecapsuleForm.schedule?.scheduleId ==
                          currentAnniversary.scheduleId;
                      return GestureDetector(
                        onTap: () {
                          ref
                              .read(timecapsuleFormProvider.notifier)
                              .updateForm(schedule: currentAnniversary);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color.fromARGB(255, 219, 214, 206)
                                : Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(0.95),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).primaryColorDark
                                  : Theme.of(context)
                                      .scaffoldBackgroundColor
                                      .withOpacity(0.95),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat.yMd()
                                        .format(currentAnniversary.startTime),
                                    style: TextStyle(
                                      fontFamily: "Kyobo",
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "D-${parseDateTimeToInDays(
                                      datetime: currentAnniversary.startTime,
                                    )}",
                                    style: TextStyle(
                                      fontFamily: "Kyobo",
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                anniversaries[index].title,
                                style: TextStyle(
                                  fontFamily: "Kyobo",
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 10), // ✅ 간격 추가
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
