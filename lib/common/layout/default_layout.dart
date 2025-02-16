import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:pico/common/components/primary_button.dart';
import 'package:pico/common/utils/modals.dart';
import 'package:pico/common/view/edit_schedule_screen.dart';
import 'package:pico/calendar/view/calendar_screen.dart';
import 'package:pico/home/view/home/home_screen.dart';
import 'package:pico/memories/view/memories_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:pico/common/theme/theme_light.dart';
import 'package:pico/user/model/user_model.dart';
import 'package:pico/user/provider/user_provider.dart';
import 'package:pico/user/view/mypage/mypage_screen.dart';

class DefaultLayout extends ConsumerStatefulWidget {
  const DefaultLayout({super.key});

  @override
  ConsumerState<DefaultLayout> createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends ConsumerState<DefaultLayout> {
  int currentIndex = 0;

  List screens = [
    HomeScreen(),
    // const BarEventMonthlyCalendar(),
    CalendarScreen(),
    MemoriesScreen(),
    MypageScreen(),
  ];

  // void _bottomSheetInviteDialog({
  //   required BuildContext context,
  // }) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext builder) {
  //       return SizedBox(
  //         height: 220, // 버튼과 선택기를 위한 충분한 높이
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(
  //             horizontal: 27,
  //             vertical: 15,
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Column(
  //                 children: [
  //                   Text(
  //                     "커플 연결을 진행해주세요",
  //                     style: TextStyle(
  //                       fontSize: 22,
  //                       fontWeight: FontWeight.bold,
  //                       color: Theme.of(context).primaryColor,
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 2,
  //                   ),
  //                   Text(
  //                     "서로의 초대코드를 입력하면\n일정이 서로 연결됩니다",
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.w500,
  //                       color: Colors.grey,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(
  //                 height: 20,
  //               ),
  //               PrimaryButton(
  //                 buttonName: "커플 연결하기",
  //                 onPressed: () {
  //                   context.go("/invite");
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(userProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'add-btn',
        shape: CircleBorder(),
        elevation: 1,
        onPressed: () {
          // if (userInfo is UserModel && userInfo.partnerId == null) {
          //   print(userInfo.partnerId);
          //   return _bottomSheetInviteDialog(context: context);
          // }
          // context.push(
          //   "/editSchedule",
          // );

          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            isDismissible: false,
            builder: (BuildContext context) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: EditScheduleScreen(),
                ),
              );
            },
          );

          // showAddScheduleModal(context);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     fullscreenDialog: true,
          //     builder: (context) => const EditScheduleScreen(),
          //   ),
          // );
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 45,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Stack(
          children: [
            screens[currentIndex],
            currentIndex != 3 &&
                    userInfo is UserModel &&
                    userInfo.partnerId == null
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                    ),
                    child: Center(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            width: constraints.maxWidth * 0.72,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Image.asset(
                                      "images/invite_bar.png",
                                      width: constraints.maxWidth * 0.3,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "커플 연결을 진행해주세요",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "서로의 초대코드를 입력하면\n일정이 서로 연결됩니다",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                PrimaryButton(
                                  width: constraints.maxWidth * 0.5,
                                  buttonName: "커플 연결하기",
                                  fontSize: 14,
                                  onPressed: () {
                                    showInviteModal(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : SizedBox.shrink()
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(child: _buildBottomNavItem(Icons.home_rounded, "홈", 0)),
            Expanded(
                child: _buildBottomNavItem(
                    Icons.calendar_month_rounded, "캘린더", 1)),
            Expanded(
              child: SizedBox(),
            ), // FloatingActionButton 공간
            Expanded(
                child:
                    _buildBottomNavItem(MdiIcons.emailHeartOutline, "추억함", 2)),
            Expanded(child: _buildBottomNavItem(Icons.person, "마이", 3)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 30,
            color: currentIndex == index
                ? AppTheme.primaryColor
                : Colors.grey.shade400,
          ),
          Text(
            label,
            style: TextStyle(
              color: currentIndex == index
                  ? AppTheme.primaryColor
                  : Colors.grey.shade400,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
