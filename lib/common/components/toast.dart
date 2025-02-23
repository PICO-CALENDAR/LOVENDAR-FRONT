import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:pico/common/theme/theme_light.dart';
// import 'package:flutter/material.dart';

class Toast {
  static DelightToastBar showCustomToast({
    Icon? icon = const Icon(
      Icons.check_circle_outline_rounded,
      size: 28,
    ),
    required String message,
    TextStyle? textStyle = const TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 14,
    ),
    DelightSnackbarPosition position = DelightSnackbarPosition.top,
  }) {
    return DelightToastBar(
      position: position,
      animationDuration: Duration(milliseconds: 300),
      animationCurve: Curves.fastEaseInToSlowEaseOut,
      autoDismiss: true,
      builder: (context) => ToastCard(
        color: Colors.white,
        leading: icon,
        title: Text(
          message,
          style: textStyle,
        ),
      ),
    );
  }

  static DelightToastBar showSuccessToast({
    required String message,
    DelightSnackbarPosition position = DelightSnackbarPosition.top,
  }) {
    return showCustomToast(
      icon: Icon(
        Icons.check_circle_outline_rounded,
        size: 28,
        color: Colors.lightGreen[800],
      ),
      message: message,
      textStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14,
        color: Colors.lightGreen[800],
      ),
    );
  }

  static DelightToastBar showErrorToast({
    required String message,
    DelightSnackbarPosition position = DelightSnackbarPosition.top,
  }) {
    return showCustomToast(
      icon: Icon(
        Icons.error_outline_rounded,
        size: 28,
        color: Colors.red[800],
      ),
      message: message,
      textStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14,
        color: Colors.red[800],
      ),
    );
  }
}
