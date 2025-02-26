import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lovendar/common/provider/global_loading_provider.dart';
import 'package:lovendar/common/utils/image_controller.dart';
import 'package:lovendar/common/utils/permission_controller.dart';

class PickPictureBtn extends ConsumerWidget {
  const PickPictureBtn({
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
        '사진 갤러리에서 선택',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      leading: Icon(Icons.image_outlined),
      onTap: () async {
        // final permissionController = PermissionController();
        // await permissionController.requestPhotosPermission();
        // 로딩 시작
        ref.read(globalLoadingProvider.notifier).startLoading();

        final croppedImg =
            await imageController.pickImageFromGallery(ratio: ratio);

        if (croppedImg != null) {
          await uploadFn(croppedImg.path);
        }

        // 로딩 끝
        ref.read(globalLoadingProvider.notifier).stopLoading();

        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
    );
  }
}
