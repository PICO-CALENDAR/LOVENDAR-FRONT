// 월간 뷰

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico/calendar/components/week_row.dart';
import 'package:pico/common/model/event_controller.dart';
import 'package:pico/common/utils/extenstions.dart';

class MonthView extends ConsumerWidget {
  const MonthView({
    super.key,
    required this.selectedMonth,
    required this.monthDays,
    // required this.scheduleController,
  });

  final List<DateTime> monthDays;
  final int selectedMonth;
  // final ScheduleController scheduleController;
  // final EventController<EventDetail> eventController;

  List<List<DateTime>> chunkListByWeek(List<DateTime> list) {
    // 7은 일주일이 7일임을 의미

    List<List<DateTime>> chunks = [];
    for (int i = 0; i < list.length; i += 7) {
      int end = (i + 7 < list.length) ? i + 7 : list.length;
      chunks.add(list.sublist(i, end));
    }
    return chunks;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekInMonth = chunkListByWeek(monthDays);
    return Row(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              final totalHeight = constraints.maxHeight;
              final slotWidth = totalWidth / 7;
              final dateCellSlotHeight = (totalHeight / 6) * 0.3;
              final eventCellSlotHeight = (totalHeight / 6) * 0.7;
              print(eventCellSlotHeight);

              return Column(
                children: [
                  for (var week in weekInMonth)
                    WeekRow(
                      selectedMonth: selectedMonth,
                      weekDate: week,
                      monthDays: monthDays,
                      // scheduleController: scheduleController,
                      slotWidth: slotWidth,
                      dateCellSlotHeight: dateCellSlotHeight,
                      totalWidth: totalWidth,
                      eventCellSlotHeight: eventCellSlotHeight,
                      isLastWeek: week == weekInMonth.last,
                    )
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
