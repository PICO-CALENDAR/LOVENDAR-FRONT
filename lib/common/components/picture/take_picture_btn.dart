import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico/common/utils/image_controller.dart';
import 'package:pico/user/provider/user_provider.dart';

class TakePictureBtn extends ConsumerWidget {
  const TakePictureBtn({
    super.key,
    required this.imageController,
    required this.uploadFn,
    this.ratio = 1,
  });

  final ImageController imageController;
  final Future<void> Function(dynamic imgFile) uploadFn;
  final double ratio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      title: Text(
        '사진 찍기',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      leading: Icon(Icons.camera_alt_outlined),
      onTap: () async {
        final croppedImg = await imageController.takePhoto(ratio: ratio);
        if (croppedImg != null) {
          uploadFn(croppedImg.path);
        }
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
    );
  }
}
