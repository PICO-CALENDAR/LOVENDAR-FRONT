import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pico/components/day_view/day_view.dart';
import 'package:pico/components/day_view/dayview_date_picker.dart';
import 'package:pico/utils/date_operations.dart';
import 'package:pico/utils/extenstions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final currentWeekDate = getWeekDate(DateTime.now());
  late final PageController _pageController;

  DateTime selectedDate = DateTime.now();

  int getIndex(DateTime tapDate) {
    return currentWeekDate.indexWhere((date) {
      return date.isSameDate(tapDate);
    });
  }

  int get currentIndex => getIndex(selectedDate);

  @override
  void initState() {
    _pageController = PageController(initialPage: currentIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 로고 및 알림 버튼
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              Image.asset('images/pico_logo.png', height: kToolbarHeight),
              const Spacer(),
              const Icon(
                Icons.notifications_rounded,
                size: 30,
              ),
            ],
          ),
        ),
        // 현재 연도 및 월
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              Text(
                intl.DateFormat.yMMM().format(DateTime.now()),
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
        // DayviewDatePicker
        DayviewDatePicker(
          selectedDate: selectedDate,
          onTap: (date) {
            final offset = _pageController.offset;
            _pageController.jumpToPage(getIndex(date));
            _pageController.jumpTo(offset);
            setState(() {
              selectedDate = date;
            });
          },
        ),

        // Day View
        Expanded(
          child: PageView.builder(
            itemCount: 7,
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                selectedDate = currentWeekDate[index];
              });
            },
            itemBuilder: (context, index) {
              return DayView(date: selectedDate);
            },
          ),
        ),
      ],
    );
  }
}
