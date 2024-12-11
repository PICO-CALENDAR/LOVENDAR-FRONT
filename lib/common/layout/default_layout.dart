import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pico/common/components/primary_button.dart';
import 'package:pico/common/view/add_event_screen.dart';
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
    const HomeScreen(),
    // const BarEventMonthlyCalendar(),
    CalendarScreen(),
    const MemoriesScreen(),
    const MypageScreen(),
  ];

  @override
  void initState() {
    final userInfo = ref.read(userProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userInfo is UserModel && userInfo.partnerId == null) {
        _bottomSheetInviteDialog(context: context);
      }
    });
    super.initState();
  }

  void _bottomSheetInviteDialog({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 220, // 버튼과 선택기를 위한 충분한 높이
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 27,
              vertical: 15,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      "커플 연결을 진행해주세요",
                      style: TextStyle(
                        fontSize: 22,
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
                SizedBox(
                  height: 20,
                ),
                PrimaryButton(
                  buttonName: "커플 연결하기",
                  onPressed: () {
                    context.go("/invite");
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(userProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: () {
          if (userInfo is UserModel && userInfo.partnerId == null) {
            return _bottomSheetInviteDialog(context: context);
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => const AddEventScreen(),
            ),
          );
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 45,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(child: screens[currentIndex]),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(child: _buildBottomNavItem(Icons.home_rounded, "홈", 0)),
            Expanded(
                child: _buildBottomNavItem(
                    Icons.calendar_month_rounded, "캘린더", 1)),
            SizedBox(
              width: MediaQuery.of(context).size.width / 5,
            ), // FloatingActionButton 공간
            Expanded(
                child: _buildBottomNavItem(
                    Icons.shopping_cart_outlined, "추억함", 2)),
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
