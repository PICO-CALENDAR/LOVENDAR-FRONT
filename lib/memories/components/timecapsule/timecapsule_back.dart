import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pico/common/theme/theme_light.dart';
import 'package:pico/memories/model/timecapsule_mode.dart';

class TimecapsuleBack extends StatelessWidget {
  const TimecapsuleBack({
    super.key,
    this.mode = TimecapsuleMode.VIEW,
  });

  final TimecapsuleMode mode;

  @override
  Widget build(BuildContext context) {
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
              DateFormat.yMEd().format(DateTime.now()),
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              "기념일",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: mode == TimecapsuleMode.EDIT
                  ? TextField(
                      expands: true, // TextField가 최대 크기로 확장되도록 설정
                      maxLines: null, // 여러 줄 입력 허용
                      minLines: null,
                      textAlignVertical: TextAlignVertical.top, // 텍스트를 상단 정렬
                      decoration: InputDecoration(
                        hintText: "타임캡슐에 들어갈 편지를 작성해주세요",
                        border: OutlineInputBorder(
                          // 테두리 추가
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.0,
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.0,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    )
                  : Text("편지"),
            )
          ],
        ),
      ),
    );
  }
}
