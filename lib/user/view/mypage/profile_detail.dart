import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico/common/components/compact_input.dart';
import 'package:pico/common/components/fullscreen_loading_indicator.dart';
import 'package:pico/common/components/input_field.dart';
import 'package:pico/common/components/picture/pick_picture_btn.dart';
import 'package:pico/common/components/picture/remove_picture_btn.dart';
import 'package:pico/common/components/picture/take_picture_btn.dart';
import 'package:pico/common/components/toast.dart';
import 'package:pico/common/model/custom_exception.dart';
import 'package:pico/common/provider/global_loading_provider.dart';
import 'package:pico/common/theme/theme_light.dart';
import 'package:pico/common/utils/image_controller.dart';
import 'package:pico/common/utils/modals.dart';
import 'package:pico/user/components/edit_button.dart';
import 'package:pico/user/model/register_body.dart';
import 'package:pico/user/model/user_model.dart';
import 'package:pico/user/provider/profile_form_provider.dart';
import 'package:pico/user/provider/user_provider.dart';

class ProfileDetail extends ConsumerWidget {
  const ProfileDetail({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userProvider) as UserModel;
    final imageController = ImageController();
    final globalLoading = ref.watch(globalLoadingProvider);

    print(userInfo.profileImage);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(3),
                child: GestureDetector(
                  onTap: () {
                    showButtonsModal(
                      context,
                      [
                        PickPictureBtn(
                          imageController: imageController,
                          uploadFn: (imgFilePath) async {
                            ref
                                .read(globalLoadingProvider.notifier)
                                .startLoading();
                            // 파일 경로를 멀티 파일로 변경 후
                            final multipartFile = await MultipartFile.fromFile(
                              imgFilePath,
                              filename: 'file',
                            );
                            try {
                              // 이미지를 전송
                              await ref
                                  .read(userProvider.notifier)
                                  .updateUserProfile([multipartFile]);
                            } catch (e) {
                              if (context.mounted) {
                                if (e is CustomException) {
                                  Toast.showErrorToast(message: e.message)
                                      .show(context);
                                } else {
                                  Toast.showErrorToast(
                                          message: "프로필 변경에 실패했습니다")
                                      .show(context);
                                }
                              }
                            } finally {
                              ref
                                  .read(globalLoadingProvider.notifier)
                                  .stopLoading();
                            }
                          },
                        ),
                        TakePictureBtn(
                          imageController: imageController,
                          uploadFn: (imgFilePath) async {
                            ref
                                .read(globalLoadingProvider.notifier)
                                .startLoading();
                            // 파일 경로를 멀티 파일로 변경 후
                            final multipartFile = await MultipartFile.fromFile(
                              imgFilePath,
                              filename: 'file',
                            );
                            try {
                              // 이미지를 전송
                              await ref
                                  .read(userProvider.notifier)
                                  .updateUserProfile([multipartFile]);
                            } catch (e) {
                              if (context.mounted) {
                                if (e is CustomException) {
                                  Toast.showErrorToast(message: e.message)
                                      .show(context);
                                } else {
                                  Toast.showErrorToast(
                                          message: "프로필 변경에 실패했습니다")
                                      .show(context);
                                }
                              }
                            } finally {
                              ref
                                  .read(globalLoadingProvider.notifier)
                                  .stopLoading();
                            }
                          },
                        ),
                        // TODO: 사진 완전 삭제 추가 구현?
                      ],
                    );
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey,
                        backgroundImage: userInfo.profileImage != null
                            ? NetworkImage(
                                userInfo.profileImage!,
                              )
                            : AssetImage(
                                "images/basic_profile.png",
                              ),
                      ),
                      Positioned(
                        bottom: 3.5,
                        right: 3.5,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.edit_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CompactInput(
                    title: '별명',
                    hint: userInfo.nickName,
                    enabled: false,
                    suffixBtn: CircleAvatar(
                      backgroundColor: Colors.grey.shade600,
                      radius: 13,
                      child: EditButton(
                        onPressed: () {
                          // 별명 속성 클릭
                          ref
                              .read(editButtonProvider.notifier)
                              .selectButton(EditButtonType.nickname);
                          pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CompactInput(
                    title: '이름',
                    hint: userInfo.name,
                    enabled: false,
                    suffixBtn: CircleAvatar(
                      backgroundColor: Colors.grey.shade600,
                      radius: 13,
                      child: EditButton(
                        onPressed: () {
                          // 이름 속성 클릭
                          ref
                              .read(editButtonProvider.notifier)
                              .selectButton(EditButtonType.name);
                          pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CompactInput(
                    title: '생일',
                    hint: userInfo.birth,
                    enabled: false,
                    suffixBtn: CircleAvatar(
                      backgroundColor: Colors.grey.shade600,
                      radius: 13,
                      child: EditButton(
                        onPressed: () {
                          // 별명 속성 클릭
                          ref
                              .read(editButtonProvider.notifier)
                              .selectButton(EditButtonType.birth);
                          pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CompactInput(
                    title: '가입 계정',
                    hint: userInfo.email,
                    enabled: false,
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          child: FullscreenLoadingIndicator(
              screenWidth: MediaQuery.of(context).size.width,
              screenHeight: MediaQuery.of(context).size.height,
              isLoading: globalLoading),
        ),
      ],
    );
  }
}
