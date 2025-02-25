import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:lovendar/common/auth/model/auth_model.dart';
import 'package:lovendar/common/auth/provider/auth_provider.dart';
import 'package:lovendar/common/components/fullscreen_loading_indicator.dart';
import 'package:lovendar/common/components/toast.dart';
import 'package:lovendar/common/contants/urls.dart';
import 'package:lovendar/common/model/custom_exception.dart';
import 'package:lovendar/common/provider/global_loading_provider.dart';
import 'package:lovendar/common/theme/theme_light.dart';
import 'package:lovendar/common/utils/app_info.dart';
import 'package:lovendar/common/utils/modals.dart';
import 'package:lovendar/common/view/invite_screen.dart';
import 'package:lovendar/user/model/user_model.dart';
import 'package:lovendar/user/provider/user_provider.dart';
import 'package:lovendar/user/view/mypage/notifications_setting.dart';
import 'package:lovendar/user/view/mypage/terms_and_policy.dart';

class MypageScreen extends ConsumerStatefulWidget {
  static String get routeName => 'mypage';
  const MypageScreen({super.key});

  @override
  ConsumerState<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends ConsumerState<MypageScreen> {
  String? appVersion;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAppInfo();
  }

  void _fetchAppInfo() async {
    Map<String, String> appInfo = await getAppInfo();
    setState(() {
      appVersion = appInfo["version"];
    });
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(userProvider) as UserModel;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isLinked = userInfo.partnerId != null;
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "마이페이지",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),

              // user profile
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showProfileDetail(context);
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey,
                            backgroundImage: userInfo.profileImage != null
                                ? NetworkImage(
                                    userInfo.profileImage!,
                                  )
                                : AssetImage(
                                    "images/basic_profile.png",
                                  ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            userInfo.nickName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            userInfo.name,
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Lottie.asset(
                      "assets/animations/heart.json",
                      width: 90,
                      height: 75,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!isLinked) {
                          showInviteModal(context);
                        }
                      },
                      child: Column(
                        children: [
                          isLinked
                              ? CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.grey,
                                  backgroundImage: userInfo
                                              .partnerProfileImage !=
                                          null
                                      ? NetworkImage(
                                          userInfo.partnerProfileImage!)
                                      : AssetImage(
                                          "images/basic_profile.png",
                                        ), // Replace  // Replace with actual image path
                                )
                              : DottedBorder(
                                  color: AppTheme.primaryColorDark,
                                  borderType: BorderType.Circle,
                                  padding: EdgeInsets.all(2),
                                  child: SizedBox(
                                    height: 78,
                                    width: 78,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      backgroundImage: AssetImage(
                                        "images/profile_placeholder.png",
                                      ), // Replace with actual image path
                                    ),
                                  ),
                                ),
                          SizedBox(
                            height: 5,
                          ),
                          isLinked
                              ? Column(
                                  children: [
                                    Text(
                                      userInfo.partnerNickname!,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      userInfo.partnerName!,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "커플 연결",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "진행해주세요",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                )
                        ],
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(
                height: 20,
              ),
              // 고객센터
              CupertinoListSection.insetGrouped(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                header: const Text(
                  "고객센터",
                  style: TextStyle(
                    color: AppTheme.textColor,
                  ),
                ),
                children: [
                  CupertinoListTile.notched(
                    title: const Text(
                      '공지사항',
                    ),
                    leading: Icon(
                      Icons.campaign,
                      size: 24,
                      color: AppTheme.primaryColor,
                    ),
                    trailing: Icon(
                      Icons.arrow_outward_rounded,
                      size: 19,
                      color: Colors.grey.shade400,
                    ),
                    onTap: () => Urls.onGoOnSite(Urls.noticeUrl),
                  ),
                  CupertinoListTile.notched(
                    title: const Text('의견 보내기'),
                    leading: Icon(
                      Icons.send_rounded,
                      size: 20,
                      color: AppTheme.primaryColor,
                    ),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () => Urls.onGoOnSite(Urls.contactUrl),
                  ),
                  CupertinoListTile.notched(
                    title: const Text('자주 묻는 질문'),
                    leading: Icon(
                      Icons.help_rounded,
                      color: AppTheme.primaryColor,
                      size: 19,
                    ),
                    trailing: Icon(
                      Icons.arrow_outward_rounded,
                      size: 19,
                      color: Colors.grey.shade400,
                    ),
                    onTap: () => Urls.onGoOnSite(Urls.faqUrl),
                  ),
                ],
              ),

              // 설정
              CupertinoListSection.insetGrouped(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                header: const Text(
                  "설정",
                  style: TextStyle(
                    color: AppTheme.textColor,
                  ),
                ),
                children: [
                  CupertinoListTile.notched(
                    title: const Text('앱 버전'),
                    leading: Icon(
                      Icons.verified_user_rounded,
                      size: 20,
                      color: AppTheme.primaryColor,
                    ),
                    trailing: appVersion != null
                        ? Text(
                            appVersion!,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : SizedBox.shrink(),
                  ),
                  CupertinoListTile.notched(
                    title: const Text('알림 설정'),
                    leading: Icon(
                      Icons.notifications_rounded,
                      size: 20,
                      color: AppTheme.primaryColor,
                    ),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsSetting(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              CupertinoListSection.insetGrouped(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                header: const Text(
                  "계정",
                  style: TextStyle(
                    color: AppTheme.textColor,
                  ),
                ),
                children: [
                  CupertinoListTile.notched(
                    title: const Text('약관 및 정책'),
                    leading: Icon(
                      Icons.policy_rounded,
                      size: 20,
                      color: AppTheme.primaryColor,
                    ),
                    trailing: Icon(
                      Icons.arrow_outward_rounded,
                      size: 19,
                      color: Colors.grey.shade400,
                    ),
                    onTap: () => Urls.onGoOnSite(Urls.termsOfserviceUrl),
                  ),
                  CupertinoListTile.notched(
                    title: Text(
                      '로그아웃',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    leading: Icon(
                      MdiIcons.logoutVariant,
                      size: 20,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      showConfirmDialog(
                        title: "로그아웃 하시겠습니까?",
                        context: context,
                        onPressed: () async {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            await ref.read(userProvider.notifier).logout();
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                            if (context.mounted) {
                              Toast.showErrorToast(message: "로그아웃에 실패했습니다")
                                  .show(context);
                            }
                          }
                        },
                      );
                    },
                  ),
                  CupertinoListTile.notched(
                    title: Text(
                      '회원 탈퇴',
                      style: TextStyle(
                        color: Colors.red[300],
                        fontSize: 16,
                      ),
                    ),
                    leading: Icon(
                      Icons.logout_rounded,
                      size: 20,
                      color: Colors.red[300],
                    ),
                    onTap: () {
                      showConfirmDialog(
                        title: "회원 탈퇴하시겠습니까?",
                        content:
                            "커플 연결이 끊기고,\n 모든 데이터가 삭제됩니다.\n이 작업을 되돌릴 수 없습니다.",
                        context: context,
                        dialogType: ConfirmType.DANGER,
                        onPressed: () async {
                          try {
                            setState(() {
                              isLoading = true;
                            });

                            await ref
                                .read(userProvider.notifier)
                                .deleteAccount();
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                            if (context.mounted) {
                              Toast.showErrorToast(message: "회원 탈퇴에 실패했습니다.")
                                  .show(context);
                            }
                          }
                        },
                      );
                    },
                  ),
                  CupertinoListTile.notched(
                    title: Text(
                      '커플 연결 해제',
                      style: TextStyle(
                        color: Colors.red[300],
                        fontSize: 16,
                      ),
                    ),
                    leading: Icon(
                      MdiIcons.heartMinus,
                      size: 20,
                      color: Colors.red[300],
                    ),
                    onTap: () {
                      showConfirmDialog(
                        title: "커플 연결을 해제하시겠습니까?",
                        content: "커플 연결이 해제되어도,\n내 일정은 그대로 유지됩니다",
                        context: context,
                        dialogType: ConfirmType.DANGER,
                        onPressed: () async {
                          if (context.mounted) Navigator.pop(context);
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            await ref
                                .read(userProvider.notifier)
                                .unLinkCouple();
                            if (context.mounted) {
                              Toast.showSuccessToast(message: "커플 연결이 해제되었습니다")
                                  .show(context);
                            }
                            await ref.read(userProvider.notifier).getUserInfo();
                          } catch (e) {
                            if (context.mounted) {
                              if (e is CustomException) {
                                Toast.showErrorToast(message: e.message)
                                    .show(context);
                              } else {
                                Toast.showErrorToast(
                                        message: "커플 연결 해제에 실패했습니다")
                                    .show(context);
                              }
                            }
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 35,
              ),
            ],
          ),
        ),
        FullscreenLoadingIndicator(
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          isLoading: isLoading,
        ),
      ],
    );
  }
}
