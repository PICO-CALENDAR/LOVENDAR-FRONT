import 'package:flutter/material.dart';
import 'package:lovendar/common/theme/theme_light.dart';

class CompactInput extends StatelessWidget {
  final String title;
  final String hint;
  final String? initialValue;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool? enabled;
  final Widget? suffixBtn;

  const CompactInput({
    super.key,
    required this.title,
    required this.hint,
    this.initialValue,
    this.controller,
    this.enabled = true,
    this.validator,
    this.suffixBtn,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: initialValue,
      validator: validator,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (state.hasError)
                    Text(
                      state.errorText!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12.0,
                      ),
                    ),
                ],
              ),
            ),
            Stack(
              children: [
                TextFormField(
                  onChanged: (value) => state.didChange(value),
                  controller: controller,
                  enabled: enabled,
                  decoration: InputDecoration(
                    hintText: hint,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), // 모서리를 둥글게
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textColor,
                  ),
                ),
                suffixBtn != null
                    ? Positioned(
                        top: 0,
                        bottom: 0,
                        right: 10,
                        child: suffixBtn!,
                      )
                    : SizedBox.shrink()
              ],
            )
          ],
        );
      },
    );
  }
}
