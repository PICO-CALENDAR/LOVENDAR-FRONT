import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lovendar/common/contants/layout_const.dart';
import 'package:lovendar/common/schedule/model/schedule_model.dart';
import 'package:lovendar/common/schedule/provider/schedules_provider.dart';
import 'package:lovendar/common/theme/theme_light.dart';
import 'package:lovendar/common/utils/schedule_operations.dart';
import 'package:lovendar/common/view/schedule_detail_screen.dart';

class ScheduleBox extends ConsumerWidget {
  final OrganizedSchedule organizedSchedule;
  final DateTime targetDate;

  const ScheduleBox({
    super.key,
    required this.organizedSchedule,
    required this.targetDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedules = ref.watch(schedulesProvider);
    final scheduleObjs = schedules
        .map(
          (s) => s.copyScheduleOnDate(targetDate: targetDate),
        )
        .whereType<ScheduleModel>()
        .toList();

    ScheduleModel? targetSchedule = scheduleObjs.firstWhere(
        (s) => s.scheduleId == organizedSchedule.scheduleData.scheduleId);

    return Positioned(
      left: organizedSchedule.left,
      top: organizedSchedule.top,
      width: organizedSchedule.width - LayoutConst.scheduleBoxGap,
      height: organizedSchedule.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Material(
          color: organizedSchedule.scheduleData.color,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(6),
          // ),
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => SizedBox(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: ScheduleDetailScreen(
                      date: targetDate,
                      intialSchedule:
                          targetSchedule ?? organizedSchedule.scheduleData,
                    ),
                  ),
                ),
              );
            },
            splashColor: AppTheme.getDarkerColorByScheduleType(
                    organizedSchedule.scheduleData.category)
                .withOpacity(0.2), // 리플 색상
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: max(organizedSchedule.height * 0.06, 7),
                horizontal: max(organizedSchedule.width * 0.05, 5),
              ),
              width: organizedSchedule.width,
              height: organizedSchedule.height,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: Offset.fromDirection(
                        360, 10), // changes position of shadow
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 4,
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (organizedSchedule.scheduleData.isRepeat)
                          Icon(
                            Icons.replay_rounded,
                            size: 13,
                          ),
                        Text(
                          organizedSchedule.scheduleData.title,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                    Wrap(
                      children: [
                        Text(
                          "${DateFormat("h시 m분").format(organizedSchedule.scheduleData.startTime)} ",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600]!,
                          ),
                        ),
                        Text(
                          "· ${organizedSchedule.scheduleData.duration.inHours}h"
                              .toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600]!,
                          ),
                        ),
                      ],
                    ),
                    // Text(
                    //   "${DateFormat.jm().format(organizedSchedule.scheduleData.startTime)} · ${organizedSchedule.scheduleData.duration.inHours}h",
                    //   maxLines: 1,
                    //   overflow: TextOverflow.ellipsis,
                    //   style: TextStyle(
                    //     fontSize: 10,
                    //     fontWeight: FontWeight.w500,
                    //     color: Colors.grey[600]!,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
