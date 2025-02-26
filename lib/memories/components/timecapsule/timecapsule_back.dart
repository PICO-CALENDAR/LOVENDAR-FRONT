import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lovendar/common/theme/theme_light.dart';
import 'package:lovendar/memories/model/timecapsule_mode.dart';
import 'package:lovendar/memories/provider/timecapsule_form_provider.dart';

class TimecapsuleBack extends ConsumerWidget {
  const TimecapsuleBack({
    super.key,
    this.mode = TimecapsuleMode.VIEW,
    required this.scheduleTitle,
    required this.scheduleStartTime,
  });

  final TimecapsuleMode mode;
  final String scheduleTitle;
  final DateTime scheduleStartTime;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 1.2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat.yMEd().format(scheduleStartTime),
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              scheduleTitle,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            mode == TimecapsuleMode.EDIT
                ? TextField(
                    onChanged: (value) => ref
                        .read(timecapsuleFormProvider.notifier)
                        .updateForm(letterTitle: value),
                    textAlignVertical: TextAlignVertical.top, // 텍스트를 상단 정렬
                    decoration: inputDecoGen(
                      context: context,
                      hintText: "편지 제목 (16자 이하)",
                    ),
                  )
                : Text(
                    "기념일",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            SizedBox(
              height: 7,
            ),
            Expanded(
              child: mode == TimecapsuleMode.EDIT
                  ? TextField(
                      onChanged: (value) => ref
                          .read(timecapsuleFormProvider.notifier)
                          .updateForm(letter: value),
                      expands: true, // TextField가 최대 크기로 확장되도록 설정
                      maxLines: null, // 여러 줄 입력 허용
                      minLines: null,
                      textAlignVertical: TextAlignVertical.top, // 텍스트를 상단 정렬
                      decoration: inputDecoGen(
                        context: context,
                        hintText: "타임캡슐에 들어갈 편지를 작성해주세요",
                      ),
                    )
                  : Text("편지"),
            )
          ],
        ),
      ),
    );
  }

  InputDecoration inputDecoGen(
      {required BuildContext context, required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        // 테두리 추가
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 2.0,
          color: Theme.of(context).primaryColorDark,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 2.0,
          color: Theme.of(context).primaryColor,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
