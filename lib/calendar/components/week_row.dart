// 일주일 Row
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lovendar/calendar/components/date_number_cell.dart';
import 'package:lovendar/calendar/components/date_schedule_row.dart';
import 'package:lovendar/common/model/event_controller.dart';

class WeekRow extends ConsumerWidget {
  const WeekRow({
    super.key,
    required this.selectedMonth,
    required this.weekDate,
    required this.monthDays,
    // required this.scheduleController,
    required this.slotWidth,
    required this.dateCellSlotHeight,
    required this.totalWidth,
    required this.eventCellSlotHeight,
    required this.isLastWeek,
  });

  final int selectedMonth;
  final List<DateTime> weekDate;
  final List<DateTime> monthDays;
  // final ScheduleController scheduleController;
  final double slotWidth;
  final double dateCellSlotHeight;
  final double totalWidth;
  final double eventCellSlotHeight;
  final bool isLastWeek;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          children: [
            for (var date in weekDate)
              DateNumberCell(
                width: slotWidth,
                height: dateCellSlotHeight,
                selectedMonth: selectedMonth,
                date: date,
                isLast: date == weekDate.last,
              ),
          ],
        ),
        Row(
          children: [
            DateScheduleRow(
              weekDate: weekDate,
              monthDays: monthDays,
              // scheduleController: scheduleController,
              width: totalWidth,
              height: eventCellSlotHeight,
              selectedMonth: selectedMonth,
              slotWidth: slotWidth,
              isLastWeek: isLastWeek,
            ),
          ],
        )
      ],
    );
  }
}
