// 사진 첨부 페이지
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico/common/components/picture/pick_picture_btn.dart';
import 'package:pico/common/components/picture/take_picture_btn.dart';
import 'package:pico/common/theme/theme_light.dart';
import 'package:pico/common/utils/image_controller.dart';
import 'package:pico/common/utils/modals.dart';
import 'package:pico/memories/components/form_step_description.dart';
import 'package:pico/memories/provider/timecapsule_form_provider.dart';

class PhotoUploadForm extends ConsumerWidget {
  final imageController = ImageController();

  PhotoUploadForm({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagePath = ref.watch(timecapsuleFormProvider).photo;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormStepDescription(
            stepTitle: "사진을 선택해주세요",
            stepDescription: "타임캡슐에 넣을 사진 하나를 선택해주세요",
          ),
          SizedBox(
            height: 30,
          ),
          LayoutBuilder(builder: (context, constraints) {
            final width = constraints.maxWidth;
            return GestureDetector(
              onTap: () {
                if (imagePath == null) {
                  showButtonsModal(
                    context,
                    [
                      PickPictureBtn(
                        ratio: 1.2,
                        imageController: imageController,
                        uploadFn: (imgFile) async {
                          ref
                              .read(timecapsuleFormProvider.notifier)
                              .updateForm(photo: imgFile);
                        },
                      ),
                      TakePictureBtn(
                        ratio: 1.2,
                        imageController: imageController,
                        uploadFn: (imgFile) async {
                          ref
                              .read(timecapsuleFormProvider.notifier)
                              .updateForm(photo: imgFile);
                        },
                      ),
                    ],
                  );
                } else {
                  showButtonsModal(
                    context,
                    [
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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
                        onTap: () {
                          ref
                              .read(timecapsuleFormProvider.notifier)
                              .resetPhoto();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                }
              },
              child: DottedBorder(
                color: AppTheme.scaffoldBackgroundColorDark,
                borderType: BorderType.RRect,
                radius: Radius.circular(20),
                padding: EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  child: Container(
                    width: width,
                    height: width * 1.2,
                    color: Theme.of(context).cardColor.withOpacity(0.6),
                    child: imagePath != null // ✅ 이미지가 있으면 표시
                        ? Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '사진 첨부 페이지',
                                style: TextStyle(
                                  fontFamily: "Kyobo",
                                  color: AppTheme.textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Icon(
                                Icons.add_photo_alternate_rounded,
                                size: 52,
                                color: AppTheme.textColor,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
