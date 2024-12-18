import 'package:flutter/material.dart';
import 'package:pico/common/theme/theme_light.dart';

class InputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const InputField({
    super.key,
    required this.title,
    required this.hint,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: validator,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
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
            TextField(
              onChanged: (value) => state.didChange(value),
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
              ),
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textColor,
              ),
            ),
          ],
        );
      },
    );
  }
}



// class InputField extends StatelessWidget {
//   final String title;
//   final String hint;
//   final TextEditingController? controller;
//   final String? Function(String?)? validator;

//   const InputField(
//       {super.key,
//       required this.title,
//       required this.hint,
//       this.controller,
//       this.validator});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Name TextFormField
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//           child: Row(
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         TextFormField(
//           controller: controller,
//           decoration: InputDecoration(
//             hintText: hint,
//           ),
//           autovalidateMode: AutovalidateMode.onUserInteraction,
//           validator: validator,
//         ),
//       ],
//     );
//   }
// }
