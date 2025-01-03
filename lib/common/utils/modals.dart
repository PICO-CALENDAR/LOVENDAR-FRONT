import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pico/common/view/edit_schedule_screen.dart';
import 'package:pico/common/view/invite_screen.dart';
import 'package:pico/home/components/day_view.dart';

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

void showInviteModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 1,
        minChildSize: 1,
        maxChildSize: 1,
        builder: (context, scrollController) {
          final topContainerHeight = MediaQuery.of(context).size.height * 0.2;
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                // 투명한 상단 영역
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: topContainerHeight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 30,
                        ),
                        color: Colors.grey.withOpacity(0.2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "커플 연결을 진행해주세요",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // 불투명한 하단 영역
                Positioned(
                  top: topContainerHeight,
                  left: 0,
                  right: 0,
                  height:
                      MediaQuery.of(context).size.height - topContainerHeight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 20,
                          ),
                          height: 4,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Expanded(
                          child: InviteScreen(),
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: topContainerHeight - 45,
                  left: 20,
                  child: Image.asset(
                    height: 50,
                    "images/sparrow_couple.png",
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
