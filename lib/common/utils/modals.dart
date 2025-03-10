import 'dart:ui';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:lovendar/common/components/compact_input.dart';
import 'package:lovendar/common/components/fullscreen_loading_indicator.dart';
import 'package:lovendar/common/theme/theme_light.dart';
import 'package:lovendar/common/view/invite_screen.dart';
import 'package:lovendar/user/view/mypage/profile_detail.dart';
import 'package:lovendar/user/view/mypage/profile_edit.dart';

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
    builder: (ctx) => CupertinoAlertDialog(
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
            Navigator.of(ctx).pop();
          },
        ),
        CupertinoButton(
          onPressed: () {
            if (onPressed != null) {
              onPressed();
            }
            Navigator.of(ctx).pop();
          },
          child: Text(
            confirmName,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: dialogType == ConfirmType.DANGER
                  ? Theme.of(ctx).colorScheme.error
                  : Theme.of(ctx).primaryColor,
            ),
          ),
        ),
      ],
    ),
  );
}

void showOptionsDialog({
  required String firstOptionName,
  required String secondOptionName,
  String cancelName = "취소",
  required String title,
  String? content,
  required BuildContext context,
  void Function()? firstOptionPressed,
  void Function()? secondOptionPressed,
}) {
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: content != null ? Text(content) : SizedBox.shrink(),
      actions: <Widget>[
        CupertinoButton(
          onPressed: () {
            if (firstOptionPressed != null) {
              firstOptionPressed();
              Navigator.of(context).pop();
            }
          },
          child: Text(
            firstOptionName,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
        CupertinoButton(
          onPressed: () {
            if (secondOptionPressed != null) {
              secondOptionPressed();
              Navigator.of(context).pop();
            }
          },
          child: Text(
            secondOptionName,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
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

// 초대 모달
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

Route createBluredBackgroundPage({required Widget screen}) {
  return PageRouteBuilder(
    opaque: false,
    pageBuilder: (context, animation, secondaryAnimation) {
      return screen;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

// 사용자 프로필 정보
void showProfileDetail(BuildContext context) {
  final PageController pageController = PageController();
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
                      pageController.dispose();
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
                              "프로필 수정하기",
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

                Positioned(
                  top: topContainerHeight - 45,
                  left: 20,
                  child: Image.asset(
                    height: 50,
                    "images/sparrow_couple.png",
                  ),
                ),

                // 불투명한 하단 영역
                Positioned(
                  top: topContainerHeight,
                  left: 0,
                  right: 0,
                  height:
                      MediaQuery.of(context).size.height - topContainerHeight,
                  child: Stack(
                    children: [
                      Container(
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
                              // child: ProfileDetail(),
                              child: PageView(
                                physics:
                                    NeverScrollableScrollPhysics(), // 스크롤 막기
                                controller: pageController,
                                children: [
                                  ProfileDetail(
                                    pageController: pageController,
                                  ),
                                  ProfileEdit(
                                    pageController: pageController,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

// 로딩이 뜨는 모달
// Future<void> showLoadingModal(BuildContext context) {
//   return showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (BuildContext context) {
//       return DraggableScrollableSheet(
//         initialChildSize: 1,
//         minChildSize: 1,
//         maxChildSize: 1,
//         builder: (context, scrollController) {
//           return SizedBox(
//             height: MediaQuery.of(context).size.height,
//             child: Stack(
//               children: [
//                 FullscreenLoadingIndicator(
//                   screenWidth: MediaQuery.of(context).size.width,
//                   screenHeight: MediaQuery.of(context).size.height,
//                   isLoading: true,
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     },
//   );
// }

// 버튼 옵션 모달
void showButtonsModal(BuildContext context, List<Widget> children) {
  showCupertinoModalBottomSheet(
    expand: false,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Material(
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ),
    ),
  );
}

// 네트워크 없을 때, 설정 모달
// void showNetworkAlertDialog() {
//   showCupertinoDialog(
//     context: Navigator.of(context, rootNavigator: true).context,
//     builder: (BuildContext context) {
//       return CupertinoAlertDialog(
//         title: const Text("인터넷 연결 필요"),
//         content: const Text("인터넷에 연결되지 않았습니다.\nWi-Fi 또는 모바일 데이터를 켜주세요."),
//         actions: <Widget>[
//           CupertinoDialogAction(
//             onPressed: () =>
//                 AppSettings.openAppSettings(type: AppSettingsType.wifi),
//             child: const Text("확인"),
//           ),
//         ],
//       );
//     },
//   );
// }
