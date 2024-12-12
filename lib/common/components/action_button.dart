import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  final String buttonName;
  final Future<void> Function() onPressed;
  final double? width;
  final double? fontSize;
  final Color? fontColor;
  final Color? backgroundColor;

  const ActionButton({
    super.key,
    required this.buttonName,
    required this.onPressed,
    this.width = double.infinity,
    this.fontSize = 20,
    this.fontColor,
    this.backgroundColor,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8),
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          backgroundColor:
              widget.backgroundColor ?? Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          await widget.onPressed();
          setState(() {
            isLoading = false;
          });
        },
        child: isLoading
            ? CircularProgressIndicator()
            : Text(
                widget.buttonName,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.bold,
                  color: widget.fontColor,
                ),
              ),
      ),
    );
  }
}
