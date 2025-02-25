import 'dart:ui';

import 'package:flutter/material.dart';

enum BluredContainerType {
  CIRCLE,
  RECTANGLE,
}

class BluredContainer extends StatelessWidget {
  const BluredContainer({
    super.key,
    this.width,
    this.height,
    this.child,
    this.type = BluredContainerType.RECTANGLE,
  });

  final int? width;
  final int? height;
  final Widget? child;
  final BluredContainerType type;
  // final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // 블러 강도 조절
          child: LayoutBuilder(
            builder: (context, constraints) {
              return type == BluredContainerType.CIRCLE
                  ? SizedBox(
                      width: width?.toDouble() ?? 60, // 기본 크기 제공
                      height: width?.toDouble() ?? 60, // 1:1 비율 유지
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white.withOpacity(0.3),
                          ),
                          child: child,
                        ),
                      ),
                    )
                  : Container(
                      width: width?.toDouble(),
                      height: height?.toDouble(),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: Colors.white.withOpacity(0.3),
                      ),
                      child: child,
                    );
            },
          )),
    );
  }
}
