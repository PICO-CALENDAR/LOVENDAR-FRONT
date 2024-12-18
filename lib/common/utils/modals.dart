import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showConfirmDialog({
  String cancelName = "취소",
  String confirmName = "확인",
  required String title,
  required String content,
  required BuildContext context,
  void Function()? onPressed,
}) {
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        CupertinoButton(
          child: Text(
            cancelName,
            style: TextStyle(
              fontWeight: FontWeight.w500,
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
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      ],
    ),
  );
}
