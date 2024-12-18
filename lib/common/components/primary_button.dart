import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonName;
  final void Function() onPressed;
  final double? width;
  final double? fontSize;
  final Color? fontColor;
  final Color? backgroundColor;

  const PrimaryButton({
    super.key,
    required this.buttonName,
    required this.onPressed,
    this.width = double.infinity,
    this.fontSize = 20,
    this.fontColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8),
          foregroundColor:
              fontColor ?? Theme.of(context).colorScheme.onSecondary,
          backgroundColor:
              backgroundColor ?? Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          buttonName,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: fontColor,
          ),
        ),
      ),
    );
  }
}
