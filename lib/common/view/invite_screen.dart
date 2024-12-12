import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pico/common/components/action_button.dart';
import 'package:pico/common/components/input_field.dart';
import 'package:pico/common/components/primary_button.dart';
import 'package:pico/common/components/toast.dart';
import 'package:pico/common/theme/theme_light.dart';
import 'package:pico/user/model/invite_code_model.dart';
import 'package:pico/user/model/user_model.dart';
import 'package:pico/user/provider/user_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pico/user/repository/user_repository.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_confetti/flutter_confetti.dart';

class InviteScreen extends ConsumerStatefulWidget {
  const InviteScreen({super.key});
  static String get routeName => 'invite';

  @override
  ConsumerState<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends ConsumerState<InviteScreen> {
  final TextEditingController inviteCodeInputController =
      TextEditingController();
  String? inviteCode;

  @override
  initState() {
    // inviteCodeModel = await provider.getInviteCode();
    _initializeInviteCode();
    super.initState();
  }

  Future<void> _initializeInviteCode() async {
    final provider = ref.read(userRepositoryProvider);
    try {
      final inviteCodeModel = await provider.getInviteCode();
      setState(() {
        inviteCode = inviteCodeModel.inviteCode;
      });
    } catch (e) {
      print("초대 코드 로드 실패: $e");
      print(e.toString());
      setState(() {
        inviteCode = null;
      });
    }
  }

  @override
  void dispose() {
    inviteCodeInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider) as UserModel;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text(
            "커플 연결을 진행해주세요",
          ),
          leading: SizedBox.shrink(),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                try {
                  context.pop();
                } catch (e) {
                  context.go("/");
                }
              },
            ),
          ],
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        "images/invite.png",
                        width: screenWidth * 0.7,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "초대코드를 통해\n커플 연결을 진행해주세요",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 130,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        width: screenWidth * 0.7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Theme.of(context).dialogBackgroundColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  textAlign: TextAlign.center,
                                  "초대코드",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  MdiIcons.accountHeart,
                                  color: AppTheme.redColor,
                                  size: 23,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            inviteCode != null
                                ? Text(
                                    textAlign: TextAlign.center,
                                    inviteCode!,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                : Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade200,
                                    child: Container(
                                      width: 130,
                                      height: 27,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      LayoutBuilder(builder: (context, constraints) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PrimaryButton(
                              buttonName: "복사하기",
                              onPressed: () async {
                                if (inviteCode != null) {
                                  await Clipboard.setData(
                                      ClipboardData(text: inviteCode!));
                                  if (mounted) {
                                    final copyToast = Toast.showSuccessToast(
                                      message: "복사되었습니다!",
                                    );
                                    copyToast.show(context);
                                  }
                                }
                              },
                              width: constraints.maxWidth / 2 - 5,
                              fontSize: 16,
                              fontColor: Colors.grey,
                              backgroundColor: AppTheme.greyColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            PrimaryButton(
                              buttonName: "공유하기",
                              onPressed: () async {
                                if (inviteCode != null) {
                                  final result = await Share.share(
                                      '❣️ ${user.name}님이 커플 연결을 요청했습니다!\nLovendar(러벤더)에서 추억과 일상을 함께 기록해보세요❤️\n\n[초대코드 💌]\n$inviteCode',
                                      subject: "Lovendar 함께 시작하기");

                                  if (result.status ==
                                      ShareResultStatus.success) {
                                    print('Thank you for sharing my website!');
                                  }
                                }
                              },
                              width: constraints.maxWidth / 2 - 5,
                              fontSize: 16,
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 28,
                  ),
                  Column(
                    children: [
                      Text(
                        "혹시 초대코드를 받았다면?",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "초대코드를 입력해주세요"; // 유효성 검사 실패 시 메시지
                          }
                          // if (value.length < 5) {
                          //   return 'Message must be at least 5 characters long';
                          // }
                          return null; // 유효성 검사 성공
                        },
                        controller: inviteCodeInputController,
                        decoration: InputDecoration(
                          hintText: "초대코드를 입력하세요",
                        ),
                        style: TextStyle(
                          fontSize: 15,
                          color: AppTheme.textColor,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ActionButton(
                        buttonName: "커플 연결하기",
                        onPressed: () async {
                          if (mounted) {
                            Toast.showSuccessToast(
                              message: "커플 연결에 성공했습니다!",
                            ).show(context);
                            Confetti.launch(
                              context,
                              options: const ConfettiOptions(
                                  particleCount: 100, spread: 70, y: 0.6),
                            );
                            context.go("/");
                          }
                          if (inviteCodeInputController.text.isNotEmpty) {
                            final provider = ref.read(userRepositoryProvider);
                            final body = InviteCodeModel(
                                inviteCode: inviteCodeInputController.text);
                            try {
                              await provider.postLinkingCouple(body);
                              ref.read(userProvider.notifier).getUserInfo();

                              if (mounted) {
                                Toast.showSuccessToast(
                                  message: "커플 연결에 성공했습니다!",
                                ).show(context);
                                Confetti.launch(
                                  context,
                                  options: const ConfettiOptions(
                                      particleCount: 100, spread: 70, y: 0.6),
                                );
                                context.go("/");
                              }
                            } catch (e) {
                              if (mounted) {
                                Toast.showErrorToast(
                                  message: "유효하지 않은 초대코드입니다.",
                                ).show(context);
                              }
                            }
                          }
                        },
                        fontSize: 16,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
