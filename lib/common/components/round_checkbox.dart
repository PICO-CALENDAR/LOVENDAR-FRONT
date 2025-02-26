import 'package:flutter/material.dart';
import 'package:lovendar/common/theme/theme_light.dart';

class RoundCheckboxTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;
  final Color selectedColor;
  final Color unselectedColor;
  final bool? isError;
  final String? errorMessage;

  const RoundCheckboxTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.selectedColor = AppTheme.primaryColor,
    this.unselectedColor = Colors.grey,
    this.isError,
    this.errorMessage = "",
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isError != null && isError!
                      ? AppTheme.redColor
                      : value
                          ? selectedColor
                          : unselectedColor,
                  width: 1.8,
                ),
                color: value ? selectedColor : Colors.transparent,
              ),
              width: 20,
              height: 20,
              child: value
                  ? const Icon(Icons.check, size: 16.0, color: Colors.white)
                  : null,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                SizedBox(
                  height: 1,
                ),
                isError != null && isError!
                    ? Text(
                        errorMessage!,
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
