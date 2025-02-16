import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pico/common/theme/theme_light.dart';
import 'package:pico/common/utils/date_operations.dart';
import 'package:pico/common/utils/extenstions.dart';

class DayviewDatePicker extends StatelessWidget {
  final DateTime now = DateTime.now();
  final DateTime selectedDate;
  final void Function(DateTime date) onTap;

  DayviewDatePicker({
    super.key,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset:
                  Offset.fromDirection(360, 10) // changes position of shadow
              ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 7, bottom: 12),
        child: Row(
          children: [
            for (var date in getWeekDate(now))
              Expanded(
                child: DateWidget(
                  date: date,
                  isSelected: date.day == selectedDate.day &&
                      date.month == selectedDate.month &&
                      date.year == selectedDate.year,
                  onTap: () => onTap(date),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DateWidget extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  const DateWidget({
    super.key,
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryColor
                : today.isSameDate(date)
                    ? Colors.grey.shade200
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                date.day.toString(),
                style: TextStyle(
                  fontSize: 18.5,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
              Text(
                DateFormat("E", 'ko').format(date),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
