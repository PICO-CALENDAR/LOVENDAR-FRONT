import 'package:flutter/material.dart';
import 'package:lovendar/common/theme/theme_light.dart';

class RemovePictureBtn extends StatelessWidget {
  const RemovePictureBtn({
    super.key,
    required this.onTap,
  });

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      title: Text(
        '사진 지우기',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: AppTheme.redColor,
        ),
      ),
      leading: Icon(
        Icons.delete,
        color: AppTheme.redColor,
      ),
      onTap: onTap,
    );
  }
}
