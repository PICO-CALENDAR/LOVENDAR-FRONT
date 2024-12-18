import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pico/common/components/primary_button.dart';
import 'package:pico/common/components/toast.dart';
import 'package:pico/common/schedule/model/schedule_model.dart';
import 'package:pico/common/schedule/provider/schedules_provider.dart';
import 'package:pico/common/theme/theme_light.dart';
import 'package:pico/common/utils/extenstions.dart';
import 'package:pico/common/utils/modals.dart';
import 'package:pico/common/view/edit_schedule_screen.dart';
import 'package:pico/user/model/user_model.dart';
import 'package:pico/user/provider/user_provider.dart';

class ScheduleDetailScreen extends ConsumerWidget {
  final ScheduleModel schedule;

  const ScheduleDetailScreen({
    super.key,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parentContext = context;
    final userInfo = ref.watch(userProvider) as UserModel;
    return Material(
      child: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                title: Text(
                  '일정 세부사항',
                ),
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 25,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: schedule.color,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        schedule.title,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          if (schedule.category !=
                                              ScheduleType.MINE)
                                            CircleAvatar(
                                              radius: 12,
                                              backgroundImage: NetworkImage(
                                                userInfo.partnerProfileImage!,
                                              ),
                                            ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          if (schedule.category !=
                                              ScheduleType.YOURS)
                                            CircleAvatar(
                                              radius: 12,
                                              backgroundImage: NetworkImage(
                                                userInfo.profileImage,
                                              ),
                                            ),
                                          SizedBox(
                                            width: 7,
                                          ),
                                          Text(
                                            "${schedule.category.getName()}의 일정",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              schedule.isAllDay
                                  ? Text(
                                      "${DateFormat.yMMMMd().format(schedule.startTime)} ${schedule.isAllDay ? "(하루종일)" : ""}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[600]!,
                                      ),
                                    )
                                  : Text(
                                      "${DateFormat.yMMMMd().format(schedule.startTime)} ${schedule.startTime.hour}시 ${schedule.startTime.minute}분",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[600]!,
                                      ),
                                    ),
                              schedule.isAllDay
                                  ? schedule.startTime
                                          .isSameDate(schedule.endTime)
                                      ? SizedBox.shrink()
                                      : Text(
                                          "${DateFormat.yMMMMd().format(schedule.endTime)} ${schedule.isAllDay ? "(하루종일)" : ""}",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[600]!,
                                          ),
                                        )
                                  : Text(
                                      "${DateFormat.yMMMMd().format(schedule.startTime)} ${schedule.startTime.hour}시 ${schedule.startTime.minute}분",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[600]!,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          const double gap = 10.0;
                          final parentWidth = constraints.maxWidth - gap;

                          return Row(
                            children: [
                              PrimaryButton(
                                fontSize: 16,
                                backgroundColor: AppTheme.greyColor,
                                fontColor: AppTheme.textColor,
                                width: parentWidth / 2,
                                buttonName: "삭제",
                                onPressed: () {
                                  showConfirmDialog(
                                    context: context,
                                    title: "정말로 삭제하겠습니까?",
                                    content: '일정이 영구 삭제되며,\n이 작업은 되돌릴 수 없습니다',
                                    confirmName: "삭제",
                                    onPressed: () async {
                                      try {
                                        await ref
                                            .read(schedulesProvider.notifier)
                                            .deleteSchedule(
                                                schedule.scheduleId);
                                        Toast.showSuccessToast(
                                                message: "삭제에 성공했습니다")
                                            .show(parentContext);
                                        Navigator.of(parentContext).pop();
                                        Navigator.of(parentContext).pop();
                                      } catch (e) {
                                        Toast.showErrorToast(
                                                message: "삭제에 실패했습니다")
                                            .show(parentContext);
                                      }
                                    },
                                  );
                                },
                              ),
                              SizedBox(
                                width: gap,
                              ),
                              PrimaryButton(
                                fontSize: 16,
                                width: parentWidth / 2,
                                buttonName: "수정",
                                onPressed: () {
                                  // print("수정");
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => EditScheduleScreen(
                                        mode: EditMode.EDIT,
                                        initialScheduleValue: schedule,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
