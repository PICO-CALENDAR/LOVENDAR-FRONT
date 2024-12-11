import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  final String buttonName;
  final Future<void> Function() onPressed;
  const ActionButton(
      {super.key, required this.buttonName, required this.onPressed});

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8),
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          backgroundColor: Theme.of(context).colorScheme.primary,
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
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
