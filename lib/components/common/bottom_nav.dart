import 'package:flutter/material.dart';
import 'package:pico/components/common/add_event_screen.dart';
import 'package:pico/screen/calendar/calendar_screen.dart';
import 'package:pico/screen/home/home_screen.dart';
import 'package:pico/screen/mypage/mypage_screen.dart';
import 'package:pico/theme/theme_light.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentIndex = 0;
  List screens = [
    const HomeScreen(),
    // const BarEventMonthlyCalendar(),
    const CalendarScreen(),
    const Scaffold(
      body: Text("추억함"),
    ),
    const MypageScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: () {
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
