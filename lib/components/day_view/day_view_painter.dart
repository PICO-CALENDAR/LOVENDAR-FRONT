import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class DayViewPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 위치 미세 조정
    const double horizontalPadding = 10;
    const double hightOffset = 0; // 사용 안함
    const double textHeightOffset = 0; // 사용 안함

    const hourHeight = 60.0; // 1시간 = 60픽셀
    const hourCount = 24;

    final Paint gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1.0;

    final TextPainter textPainter = TextPainter(
      textAlign: TextAlign.right,
      textDirection: TextDirection.ltr,
    );

    const double textPadding = 50; // 텍스트와 선 사이의 여백

    final DateTime now = DateTime.now();
    final DateTime startOfDay = DateTime(now.year, now.month, now.day); // 오늘 0시
    final intl.DateFormat timeFormat = intl.DateFormat('a hh시'); // 오전/오후 HH시

    // 시간 블록과 레이블 그리기
    for (int i = 0; i <= hourCount; i++) {
      final DateTime time = startOfDay.add(Duration(hours: i));
      final y = i * hourHeight + hightOffset + textHeightOffset;

      // 시간 텍스트
      final timeText = timeFormat.format(time); // '오전 01시', '오후 12시'
      textPainter.text = TextSpan(
        text: timeText,
        style: TextStyle(
          color: Colors.grey.shade800,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      );
      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(horizontalPadding, y - textPainter.height / 2), // 텍스트를 왼쪽에 배치
      );

      // 시간 블록 선
      canvas.drawLine(
        Offset(textPadding + horizontalPadding + 20,
            y + hightOffset), // 선을 텍스트 뒤쪽에서 시작
        Offset(size.width - horizontalPadding, y + hightOffset),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// 텍스트 패딩 + dayview 패딩 + 20 = 65+10+20 = 95
// 50+10+20=80
// textPadding + horizontalPadding + 20,
