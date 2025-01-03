import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pico/common/theme/theme_light.dart';
import 'package:pico/common/utils/modals.dart';
import 'package:pico/memories/components/blured_container.dart';
import 'package:pico/memories/components/transparent_touchable_image.dart';
import 'package:pico/memories/view/inbox_screen.dart';
import 'package:pico/memories/view/sentbox_screen.dart';
import 'package:pico/user/model/user_model.dart';
import 'package:pico/user/provider/user_provider.dart';

class MemoriesScreen extends ConsumerStatefulWidget {
  static String get routeName => 'memories';
  const MemoriesScreen({super.key});

  @override
  ConsumerState<MemoriesScreen> createState() => _MemoriesScreenState();
}

class _MemoriesScreenState extends ConsumerState<MemoriesScreen> {
  bool isBirdTapped = false;

  @override
  Widget build(BuildContext context) {
    final messageWidth = 200;
    final messageHeight = 110;
    final userInfo = ref.watch(userProvider) as UserModel;

    return Stack(
      children: [
        // 전체 배경
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
            "images/bird_with_bg.png",
            fit: BoxFit.cover,
          ),
        ),

        // 우편함
        // TransparentTouchableImage(
        //   width: MediaQuery.of(context).size.width,
        //   height: MediaQuery.of(context).size.height,
        //   imagePath: 'images/mailbox.png',
        //   onTap: () {
        //     HapticFeedback.heavyImpact();
        //     // print("우편함");
        //   },
        // ),

        // 새 버튼 - 투명 픽셀 감지 적용
        TransparentTouchableImage(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          imagePath: 'images/bird.png',
          onTap: () {
            HapticFeedback.heavyImpact();
            setState(() {
              isBirdTapped = !isBirdTapped;
            });
          },
        ),

        Positioned(
          top: 25,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BluredContainer(
                  width: 130,
                  height: 45,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          MdiIcons.heartMultiple,
                          color: Colors.red.shade600,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "325일",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: ui.FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    createBluredBackgroundPage(
                      screen: SentboxScreen(),
                    ),
                  ),
                  child: BluredContainer(
                    type: BluredContainerType.CIRCLE,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Center(
                        child: Icon(
                          MdiIcons.sendVariantClock,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),

        // if (isBirdTapped)
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          top: isBirdTapped
              ? MediaQuery.of(context).size.height * 0.29 - messageHeight / 2
              : MediaQuery.of(context).size.height * 0.3 -
                  messageHeight / 2, // 처음에는 약간 아래 위치
          left: MediaQuery.of(context).size.width * 0.5 - messageWidth / 2,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            opacity: isBirdTapped ? 1.0 : 0.0, // 탭되지 않았을 때는 투명
            child: BluredContainer(
              width: messageWidth,
              height: messageHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 14,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "안녕! 오늘 하루는 어때?",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: ui.FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${userInfo.partnerNickname} ❤️에게\n전하고픈 마음을\n타임캡슐에 작성해봐",
                        textAlign: ui.TextAlign.center,
                        style: TextStyle(
                          fontWeight: ui.FontWeight.w500,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          left: 0,
          right: 0,
          bottom: isBirdTapped ? 100 : 90,
          child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              opacity: isBirdTapped ? 1.0 : 0.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();

                      Navigator.of(context).push(
                        createBluredBackgroundPage(
                          screen: InboxScreen(),
                        ),
                      );
                    },
                    child: BluredContainer(
                      width: 130,
                      height: 50,
                      child: Center(
                        child: Text(
                          "받은 타임캡슐 보기",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: ui.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                    },
                    child: BluredContainer(
                      width: 130,
                      height: 50,
                      child: Center(
                        child: Text(
                          "타임캡슐 작성하기",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: ui.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
