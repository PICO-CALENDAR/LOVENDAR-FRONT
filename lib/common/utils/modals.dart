import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pico/common/view/edit_schedule_screen.dart';
import 'package:pico/common/view/test_screen.dart';

enum ConfirmType {
  CONFIRM,
  DANGER,
}

void showConfirmDialog({
  String cancelName = "취소",
  String confirmName = "확인",
  required String title,
  String? content,
  required BuildContext context,
  void Function()? onPressed,
  ConfirmType dialogType = ConfirmType.CONFIRM,
}) {
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: content != null ? Text(content) : SizedBox.shrink(),
      actions: <Widget>[
        CupertinoButton(
          child: Text(
            cancelName,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        CupertinoButton(
          onPressed: onPressed,
          child: Text(
            confirmName,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: dialogType == ConfirmType.DANGER
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    ),
  );
}

// Future<bool> showConfirmDialog({
//   String cancelName = "취소",
//   String confirmName = "확인",
//   required String title,
//   String? content,
//   void Function()? onPressed,
//   required BuildContext context,
//   ConfirmType dialogType = ConfirmType.CONFIRM,
// }) async {
//   bool result = false;

//   await showCupertinoDialog(
//     context: context,
//     builder: (context) => CupertinoAlertDialog(
//       title: Text(title),
//       content: content != null ? Text(content) : const SizedBox.shrink(),
//       actions: <Widget>[
//         CupertinoButton(
//           child: Text(
//             cancelName,
//             style: TextStyle(
//               fontWeight: FontWeight.w500,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           onPressed: () {
//             result = false; // 취소를 눌렀을 때
//             // Navigator.of(context).pop();
//           },
//         ),
//         CupertinoButton(
//           onPressed: () {
//             if (onPressed != null) {
//               onPressed();
//             }
//             result = true; // 확인을 눌렀을 때
//             // Navigator.of(context).pop();
//           },
//           child: Text(
//             confirmName,
//             style: TextStyle(
//               fontWeight: FontWeight.w500,
//               color: dialogType == ConfirmType.DANGER
//                   ? Theme.of(context).colorScheme.error
//                   : Theme.of(context).primaryColor,
//             ),
//           ),
//         ),
//       ],
//     ),
//   );

//   return result;
// }

// void showAddScheduleModal(BuildContext context) async {
//   await showCupertinoModalBottomSheet(
//     expand: true,
//     context: context,
//     backgroundColor: Colors.transparent,
//     builder: (context) => ComplexModal(),
//   );
// }

void showAddScheduleModal(BuildContext context) {
  showCupertinoModalBottomSheet(
    expand: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => ModalContent(),
  );
}
