import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pico/common/provider/selected_day_provider.dart';
import 'package:pico/home/components/day_view.dart';
import 'package:pico/home/components/dayview_date_picker.dart';
import 'package:pico/common/utils/date_operations.dart';
import 'package:pico/common/utils/extenstions.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final currentWeekDate = getWeekDate(DateTime.now());
  late final PageController _pageController;

  bool isAllDayScheduleTapped = false;

  void toggleIsAllDayScheduleTapped() {
    setState(() {
      isAllDayScheduleTapped = !isAllDayScheduleTapped;
    });
  }

  int getIndex(DateTime tapDate) {
    return currentWeekDate.indexWhere((date) {
      return date.isSameDate(tapDate);
    });
  }

  // int get currentIndex => getIndex(selectedDate);

  @override
  void initState() {
    DateTime selectedDate = ref.read(selectedDayProvider);
    _pageController = PageController(initialPage: getIndex(selectedDate));

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime selectedDate = ref.watch(selectedDayProvider);
    return Column(
      children: [
        // 로고 및 알림 버튼
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 25),
        //   child: Row(
        //     children: [
        //       Image.asset('images/lovendar_logo.png', height: kToolbarHeight),
        //       const Spacer(),
        //       const Icon(
        //         Icons.notifications_rounded,
        //         size: 30,
        //       ),
        //     ],
        //   ),
        // ),
        // 현재 연도 및 월
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              Image.asset('images/lovendar_logo.png', height: kToolbarHeight),
              SizedBox(
                width: 4,
              ),
              Text(
                intl.DateFormat.yMMM().format(DateTime.now()),
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.notifications_rounded,
                size: 30,
              ),
            ],
          ),
        ),
        // DayviewDatePicker
        DayviewDatePicker(
          selectedDate: selectedDate,
          onTap: (date) async {
            _pageController
                .animateToPage(
              getIndex(date),
              duration: Duration(milliseconds: 1),
              curve: Curves.easeInOut,
            )
                .whenComplete(() {
              ref.read(selectedDayProvider.notifier).setSelectedDay(date);
              setState(() {
                isAllDayScheduleTapped = false;
              });
            });
          },
        ),

        // Day View
        Expanded(
          child: PageView.builder(
            itemCount: 7,
            controller: _pageController,
            onPageChanged: (index) {
              ref
                  .read(selectedDayProvider.notifier)
                  .setSelectedDay(currentWeekDate[index]);
              setState(() {
                isAllDayScheduleTapped = false;
              });
            },
            itemBuilder: (context, index) {
              return DayView(
                date: selectedDate,
                isAllDayScheduleTapped: isAllDayScheduleTapped,
                toggleIsAllDayScheduleTapped: toggleIsAllDayScheduleTapped,
              );
            },
          ),
        ),
      ],
    );
  }
}
