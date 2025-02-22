import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico/common/components/compact_input.dart';
import 'package:pico/common/components/input_field.dart';
import 'package:pico/common/components/picture/pick_picture_btn.dart';
import 'package:pico/common/components/picture/take_picture_btn.dart';
import 'package:pico/common/theme/theme_light.dart';
import 'package:pico/common/utils/image_controller.dart';
import 'package:pico/common/utils/modals.dart';
import 'package:pico/user/components/edit_button.dart';
import 'package:pico/user/model/user_model.dart';
import 'package:pico/user/provider/user_provider.dart';

class ProfileDetail extends ConsumerWidget {
  const ProfileDetail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userProvider) as UserModel;
    final imageController = ImageController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3),
            child: GestureDetector(
              onTap: () {
                // TODO : 이거 잘 동작하는지 확인해야 함
                showButtonsModal(
                  context,
                  [
                    PickPictureBtn(
                      imageController: imageController,
                      uploadFn:
                          ref.read(userProvider.notifier).updateUserProfile,
                    ),
                    TakePictureBtn(
                      imageController: imageController,
                      uploadFn:
                          ref.read(userProvider.notifier).updateUserProfile,
                    ),
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
                            "images/profile_placeholder.png",
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
                      ref.read(userProvider.notifier).getUserInfo();
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CompactInput(
                title: '이름',
                hint: userInfo.nickName,
                enabled: false,
                suffixBtn: CircleAvatar(
                  backgroundColor: Colors.grey.shade600,
                  radius: 13,
                  child: EditButton(
                    onPressed: () {},
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
                  child: EditButton(),
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
    );
  }
}
