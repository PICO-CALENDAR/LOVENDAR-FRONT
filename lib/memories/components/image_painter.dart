// 이미지를 그리는 페인터
import 'package:flutter/material.dart' hide Image;

import 'dart:ui';

class ImagePainter extends CustomPainter {
  final Image image;
  final double? width;
  final double? height;

  ImagePainter({required this.image, this.width, this.height});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final Rect rect = Offset.zero & size;
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(
        0,
        0,
        width ?? image.width.toDouble(),
        height ?? image.height.toDouble(),
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
