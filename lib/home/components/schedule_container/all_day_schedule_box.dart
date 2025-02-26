import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lovendar/common/schedule/model/schedule_model.dart';
import 'package:lovendar/common/schedule/provider/schedules_provider.dart';
import 'package:lovendar/common/view/schedule_detail_screen.dart';

class AllDayScheduleBox extends ConsumerWidget {
  final DateTime date;
  final ScheduleType category;
  final bool isTapped;
  final void Function() toggleIsTapped;

  const AllDayScheduleBox({
    super.key,
    required this.date,
    required this.category,
    required this.isTapped,
    required this.toggleIsTapped,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ScheduleModel? targetSchedule = scheduleObjs.firstWhere(
    //     (s) => s.scheduleId == organizedSchedule.scheduleData.scheduleId);

    final allDaySchedulesInDateByCat = ref
        .read(schedulesProvider.notifier)
        .getAllDaySchedulesByDateAndCat(date: date, category: category);

    return Column(
      children: [
        for (int idx = 0; idx < allDaySchedulesInDateByCat.length; idx++)
          // if (isTapped || idx == 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: GestureDetector(
              onTap: () {
                if (!isTapped) {
                  if (isTapped || idx == 0) {
                    toggleIsTapped();
                  }
                } else {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    isDismissible: false,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.85,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: ScheduleDetailScreen(
                            date: date,
                            intialSchedule: allDaySchedulesInDateByCat[idx],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: isTapped || idx == 0 ? 27.5 : 0,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  height: 27.5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: allDaySchedulesInDateByCat[idx].color,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset.fromDirection(
                              360, 10) // changes position of shadow
                          ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.replay_rounded,
                            size: isTapped || idx == 0 ? 13 : 0,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            allDaySchedulesInDateByCat[idx].title,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      allDaySchedulesInDateByCat.length > 1 && !isTapped
                          ? Text(
                              "+${allDaySchedulesInDateByCat.length - 1}개 더보기",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600]!,
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
