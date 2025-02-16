import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  final void Function()? onPressed;

  const EditButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      icon: const Icon(
        Icons.edit_rounded,
        size: 13,
        color: Colors.white,
      ),
    );
  }
}
