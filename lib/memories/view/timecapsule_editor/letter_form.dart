// 편지 작성 페이지
import 'package:flutter/material.dart';
import 'package:pico/memories/components/form_step_description.dart';
import 'package:pico/memories/components/timecapsule/timecapsule_back.dart';
import 'package:pico/memories/components/timecapsule/timecapsule_list_item.dart';
import 'package:pico/memories/model/timecapsule_mode.dart';

class LetterForm extends StatelessWidget {
  const LetterForm({super.key});

  @override
  Widget build(BuildContext context) {
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
            TimecapsuleBack(
              mode: TimecapsuleMode.EDIT,
            ),
          ],
        ),
      ),
    );
  }
}
