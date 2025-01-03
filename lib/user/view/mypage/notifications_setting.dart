import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NotificationsSetting extends StatelessWidget {
  const NotificationsSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          "알림 설정",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 35,
          vertical: 5,
        ),
        child: Column(
          children: [
            NotificationRow(name: "오늘 일정"),
            SizedBox(
              height: 5,
            ),
            NotificationRow(name: "상대방 일정 시작 5분전"),
            // NotificationRow(name: "타임 캡슐 작성 완료"),
            // NotificationRow(name: "타임 캡슐 공개"),
          ],
        ),
      ),
    );
  }
}

class NotificationRow extends StatelessWidget {
  final String name;

  const NotificationRow({
    required this.name,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              MdiIcons.calendarToday,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Center(
          child: Transform.scale(
            scale: 0.9, // 스위치 크기를 확대 (1.0이 기본 크기)
            child: CupertinoSwitch(
              value: false,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (bool? value) {
                // setState(() {
                //   _isAllDay = value ?? false;
                // });
              },
            ),
          ),
        ),
      ],
    );
  }
}
