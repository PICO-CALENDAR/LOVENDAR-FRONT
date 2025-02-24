// 편지 작성 페이지
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico/memories/components/form_step_description.dart';
import 'package:pico/memories/components/timecapsule/timecapsule_back.dart';
import 'package:pico/memories/components/timecapsule/timecapsule_list_item.dart';
import 'package:pico/memories/model/timecapsule_mode.dart';
import 'package:pico/memories/provider/timecapsule_form_provider.dart';

class LetterForm extends ConsumerWidget {
  const LetterForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(timecapsuleFormProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: FormStepDescription(
                stepTitle: "편지를 작성해주세요.",
                stepDescription: "타임캡슐에 담을 편지를 작성해주세요",
              ),
            ),
            form.schedule != null
                ? TimecapsuleBack(
                    scheduleTitle: form.schedule!.title,
                    scheduleStartTime: form.schedule!.startTime,
                    mode: TimecapsuleMode.EDIT,
                  )
                : Center(
                    child: Text("기념일을 먼저 선택해주세요"),
                  ),
          ],
        ),
      ),
    );
  }
}
