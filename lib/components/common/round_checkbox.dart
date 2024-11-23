import 'package:flutter/material.dart';
import 'package:pico/theme/theme_light.dart';

class RoundCheckboxTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;
  final Color selectedColor;
  final Color unselectedColor;

  const RoundCheckboxTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.selectedColor = AppTheme.primaryColor,
    this.unselectedColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 0,
      visualDensity: const VisualDensity(vertical: -4),
      leading: GestureDetector(
        onTap: () => onChanged(!value),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: value ? selectedColor : unselectedColor,
              width: 2.0,
            ),
            color: value ? selectedColor : Colors.transparent,
          ),
          width: 20,
          height: 20,
          child: value
              ? const Icon(Icons.check, size: 16.0, color: Colors.white)
              : null,
        ),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          letterSpacing: 0,
          color: Theme.of(context).textTheme.bodyLarge!.color,
        ),
      ),
      onTap: () => onChanged(!value),
    );
  }
}
