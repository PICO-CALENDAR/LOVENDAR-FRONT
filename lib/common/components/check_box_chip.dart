import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lovendar/common/theme/theme_light.dart';

class CheckBoxChip extends ConsumerWidget {
  const CheckBoxChip({
    super.key,
    required this.width,
    this.height = 38.0,
    required this.label,
    required this.isChecked,
    required this.color,
    required this.onPressed,
    this.accentColor = Colors.grey,
    this.selectedColor = AppTheme.scaffoldBackgroundColor,
    this.unselectedColor = Colors.grey,
  });

  final double width;
  final double height;
  final String label;
  final bool isChecked;
  final Color color;
  final Color selectedColor;
  final Color unselectedColor;
  final Color accentColor;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          surfaceTintColor: color,
          elevation: 1,
          shadowColor: Colors.transparent,
          overlayColor: accentColor,
          // shadowColor: Colors.grey[50],
          padding: const EdgeInsets.symmetric(
            vertical: 3,
            horizontal: 8,
          ),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // 둥근 모서리 반경
          ),
        ),
        onPressed: onPressed,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(0.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: accentColor,
                  width: 1.5,
                ),
                color: isChecked ? accentColor : Colors.transparent,
              ),
              child: Icon(
                Icons.check_rounded,
                size: 16,
                color: isChecked ? selectedColor : Colors.transparent,
              ),
            ),
            const SizedBox(
              width: 7,
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
