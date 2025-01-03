// 터치 가능한 이미지 위젯
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Image;
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:pico/memories/components/image_painter.dart';

class TransparentTouchableImage extends StatefulWidget {
  final String imagePath;
  final VoidCallback onTap;
  final double? width;
  final double? height;

  const TransparentTouchableImage({
    required this.imagePath,
    required this.onTap,
    this.width,
    this.height,
    super.key,
  });

  @override
  State<TransparentTouchableImage> createState() =>
      _TransparentTouchableImageState();
}

class _TransparentTouchableImageState extends State<TransparentTouchableImage> {
  Image? _image;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  // 이미지 로드
  Future<void> _loadImage() async {
    final data = await rootBundle.load(widget.imagePath);
    final codec = await instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    setState(() {
      _image = frame.image;
      _isLoading = false;
    });
  }

  // 터치한 픽셀이 투명한지 확인
  Future<bool> _isTransparent(Offset position) async {
    if (_image == null) return false;

    final ByteData? byteData =
        await _image!.toByteData(format: ImageByteFormat.rawRgba);
    if (byteData == null) return false;

    final int x = position.dx.toInt();
    final int y = position.dy.toInt();

    // 이미지 범위를 벗어난 경우
    if (x < 0 || y < 0 || x >= _image!.width || y >= _image!.height) {
      return false;
    }

    final int pixelIndex = (y * _image!.width + x) * 4;
    final int alpha = byteData.getUint8(pixelIndex + 3); // 알파 채널 값 (0이면 투명)
    return alpha == 0;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _image == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double scaleX = constraints.maxWidth / _image!.width;
        final double scaleY = constraints.maxHeight / _image!.height;

        return GestureDetector(
          onTapDown: (details) async {
            final renderBox = context.findRenderObject() as RenderBox;
            final localPosition =
                renderBox.globalToLocal(details.globalPosition);

            // 터치 좌표를 이미지 비율로 변환
            final Offset scaledPosition = Offset(
              localPosition.dx / scaleX,
              localPosition.dy / scaleY,
            );

            final isTransparent = await _isTransparent(scaledPosition);
            // 투명하면 이벤트를 뒤로 전달
            if (!isTransparent) {
              widget.onTap();
            }
          },
          child: CustomPaint(
            size: Size(
              widget.width ?? constraints.maxWidth,
              widget.height ?? constraints.maxHeight,
            ),
            painter: ImagePainter(
              image: _image!,
              width: widget.width,
              height: widget.height,
            ),
          ),
        );
      },
    );
  }
}
