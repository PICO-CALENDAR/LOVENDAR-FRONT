import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimecapsuleListItem extends StatelessWidget {
  const TimecapsuleListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMEd().format(DateTime.now()),
              style: const TextStyle(
                color: Colors.grey,
                fontFamily: "Kyobo",
                height: 1,
              ),
            ),
            Text(
              "기념일 제목",
              style: const TextStyle(
                fontFamily: "Kyobo",
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
