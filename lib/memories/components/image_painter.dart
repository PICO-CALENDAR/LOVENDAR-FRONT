// 이미지를 그리는 페인터
import 'package:flutter/material.dart' hide Image;

import 'dart:ui';

class ImagePainter extends CustomPainter {
  final Image image;

  ImagePainter({
    required this.image,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final Rect rect = Offset.zero & size;

    canvas.drawImageRect(
      image,
      Rect.fromLTWH(
        0,
        0,
        // image.width.toDouble(),
        // image.height.toDouble(),
        size.width,
        size.height,
      ),
      rect,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
