import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lovendar/common/theme/theme_light.dart';

class FullscreenLoadingIndicator extends StatelessWidget {
  const FullscreenLoadingIndicator({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.isLoading,
  });

  final double screenWidth;
  final double screenHeight;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: AppTheme.scaffoldBackgroundColorDark,
              ),
            ),
          )
        : SizedBox.shrink();
  }
}
