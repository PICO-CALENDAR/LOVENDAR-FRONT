import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:lovendar/common/components/primary_button.dart';
import 'package:lovendar/common/components/toast.dart';
import 'package:lovendar/common/schedule/model/schedule_model.dart';
import 'package:lovendar/common/schedule/provider/schedules_provider.dart';
import 'package:lovendar/common/theme/theme_light.dart';
import 'package:lovendar/common/utils/extenstions.dart';
import 'package:lovendar/common/utils/modals.dart';
import 'package:lovendar/common/view/edit_schedule_screen.dart';
import 'package:lovendar/user/model/user_model.dart';
import 'package:lovendar/user/provider/user_provider.dart';

class ScheduleDetailScreen extends ConsumerStatefulWidget {
  final DateTime date;
  final ScheduleModel intialSchedule;

  const ScheduleDetailScreen({
    super.key,
    required this.date,
    required this.intialSchedule,
  });

  @override
  ConsumerState<ScheduleDetailScreen> createState() =>
      _ScheduleDetailScreenState();
}

class _ScheduleDetailScreenState extends ConsumerState<ScheduleDetailScreen> {
  late int scheduleId;
  late ScheduleModel schedule;

  @override
  void initState() {
    super.initState();
    scheduleId = widget.intialSchedule.scheduleId;
    _updateSchedule();
  }

  void _updateSchedule() {
    final schedules = ref.read(schedulesProvider);
    setState(() {
      schedule = schedules.firstWhere(
        (s) => s.scheduleId == scheduleId,
        orElse: () => ScheduleModel.empty(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final parentContext = context;
    final userInfo = ref.watch(userProvider) as UserModel;
    final scheduleStartDateOnSelectedDate = DateTime(
      widget.date.year,
      widget.date.month,
      widget.date.day,
      schedule.startTime.hour,
      schedule.startTime.minute,
    );
    final scheduleEndDateOnSelectedDate =
        scheduleStartDateOnSelectedDate.add(schedule.duration);

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
              body: schedule.scheduleId == -999
                  ? Center(
                      child: Text(
                        "일정을 찾을 수 없습니다.",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  : SafeArea(
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
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              spreadRadius: 0,
                                              blurRadius: 10,
                                              offset: Offset.fromDirection(360,
                                                  10) // changes position of shadow
                                              ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  schedule.title,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                if (schedule.isRepeat)
                                                  Icon(
                                                    Icons.replay_rounded,
                                                    size: 20,
                                                  ),
                                              ],
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
                                                    backgroundImage:
                                                        NetworkImage(
                                                      userInfo
                                                          .partnerProfileImage!,
                                                    ),
                                                  ),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                if (schedule.category !=
                                                    ScheduleType.YOURS)
                                                  CircleAvatar(
                                                    radius: 12,
                                                    backgroundImage:
                                                        userInfo.profileImage !=
                                                                null
                                                            ? NetworkImage(
                                                                userInfo
                                                                    .profileImage!,
                                                              )
                                                            : AssetImage(
                                                                "images/basic_profile.png",
                                                              ),
                                                  ),
                                                SizedBox(
                                                  width: 5,
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
                                      height: 10,
                                    ),
                                    if (schedule.meetingPeople != null)
                                      if (schedule.meetingPeople!.isNotEmpty)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                  spreadRadius: 0,
                                                  blurRadius: 10,
                                                  offset: Offset.fromDirection(
                                                      360,
                                                      10) // changes position of shadow
                                                  ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    MdiIcons.accountGroup,
                                                    color: AppTheme.textColor,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "만나는 사람",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                schedule.meetingPeople!,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                    SizedBox(
                                      height: 10,
                                    ),
                                    if (schedule.isRepeat)
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.replay_rounded,
                                                size: 18,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error,
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                "반복 : ${schedule.repeatType!.getName()}",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .error,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (schedule.repeatEndDate != null)
                                            Text(
                                              "${DateFormat.yMEd().format(schedule.repeatEndDate!)}에 종료",
                                              style: TextStyle(
                                                color: AppTheme.textColor,
                                              ),
                                            ),
                                        ],
                                      ),
                                    Text(
                                      // 실제 선택한 날짜를 startTimed으로 보여줌. 끝난 날짜도 마찬가지로 계산
                                      "${DateFormat.yMMMMd().format(scheduleStartDateOnSelectedDate)} ${schedule.isAllDay ? "(하루종일)" : "${scheduleStartDateOnSelectedDate.hour}시 ${scheduleStartDateOnSelectedDate.minute}분"}",
                                      // "${DateFormat.yMMMMd().format(schedule.startTime)} ${schedule.isAllDay ? "(하루종일)" : "${schedule.startTime.hour}시 ${schedule.startTime.minute}분"}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[600]!,
                                      ),
                                    ),
                                    Text(
                                      // 실제 선택한 날짜를 startTimed으로 보여줌. 끝난 날짜도 마찬가지로 계산
                                      "${DateFormat.yMMMMd().format(scheduleEndDateOnSelectedDate)} ${schedule.isAllDay ? "(하루종일)" : "${scheduleEndDateOnSelectedDate.hour}시 ${scheduleEndDateOnSelectedDate.minute}분"}",
                                      // "${DateFormat.yMMMMd().format(schedule.endTime)} ${schedule.isAllDay ? "(하루종일)" : "${schedule.endTime.hour}시 ${schedule.endTime.minute}분"}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[600]!,
                                      ),
                                    ),
                                    // schedule.startTime.isSameDate(schedule.endTime)
                                    //     ? SizedBox.shrink()
                                    //     : Text(
                                    //         "${DateFormat.yMMMMd().format(schedule.endTime)} ${schedule.isAllDay ? "(하루종일)" : "${schedule.endTime.hour}시 ${schedule.endTime.minute}분"}",
                                    //         style: TextStyle(
                                    //           fontSize: 15,
                                    //           fontWeight: FontWeight.w500,
                                    //           color: Colors.grey[600]!,
                                    //         ),
                                    //       ),
                                  ],
                                ),
                              ),
                            ),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                const double gap = 10.0;
                                final parentWidth = constraints.maxWidth - gap;
                                if (schedule.category != ScheduleType.YOURS) {
                                  return Row(
                                    children: [
                                      // 삭제 버튼
                                      PrimaryButton(
                                        fontSize: 16,
                                        backgroundColor: AppTheme.greyColor,
                                        fontColor: AppTheme.textColor,
                                        width: parentWidth / 2,
                                        buttonName: "삭제",
                                        onPressed: () {
                                          if (schedule.isRepeat) {
                                            //반복 일정인 경우
                                            showOptionsDialog(
                                              context: context,
                                              title: "반복 일정 삭제",
                                              content:
                                                  '모든 일정을 삭제하시겠습니까, 아니면 현재 일정과 이후 모든 일정을 삭제하겠습니까?',
                                              firstOptionName: "모든 일정 삭제",
                                              firstOptionPressed: () async {
                                                print("hello");
                                                // 모든 일정 삭제
                                                try {
                                                  await ref
                                                      .read(schedulesProvider
                                                          .notifier)
                                                      .deleteSchedule(
                                                          schedule.scheduleId);
                                                  if (parentContext.mounted) {
                                                    Toast.showSuccessToast(
                                                            message:
                                                                "모든 반복 일정이 삭제되었습니다")
                                                        .show(parentContext);
                                                    Navigator.of(parentContext)
                                                        .pop();
                                                  }
                                                } catch (e) {
                                                  if (parentContext.mounted) {
                                                    Toast.showErrorToast(
                                                            message:
                                                                e.toString())
                                                        .show(parentContext);
                                                  }
                                                }
                                              },
                                              secondOptionName:
                                                  "현재 일정 및 이후 일정만 삭제",
                                              secondOptionPressed: () async {
                                                // 현재 일정 및 이후 일정 삭제
                                                try {
                                                  await ref
                                                      .read(schedulesProvider
                                                          .notifier)
                                                      .deleteRepeatSchedule(
                                                        scheduleId:
                                                            schedule.scheduleId,
                                                        repeatEndDate:
                                                            widget.date,
                                                      );
                                                  if (parentContext.mounted) {
                                                    Toast.showSuccessToast(
                                                            message:
                                                                "현재 일정 및 이후 일정이 삭제되었습니다")
                                                        .show(parentContext);
                                                    Navigator.of(parentContext)
                                                        .pop();
                                                  }
                                                } catch (e) {
                                                  if (parentContext.mounted) {
                                                    Toast.showErrorToast(
                                                            message:
                                                                e.toString())
                                                        .show(parentContext);
                                                  }
                                                }
                                              },
                                            );
                                          } else {
                                            showConfirmDialog(
                                              context: context,
                                              title: "정말로 삭제하겠습니까?",
                                              content:
                                                  '일정이 영구 삭제되며,\n이 작업은 되돌릴 수 없습니다',
                                              confirmName: "삭제",
                                              dialogType: ConfirmType.DANGER,
                                              onPressed: () async {
                                                try {
                                                  await ref
                                                      .read(schedulesProvider
                                                          .notifier)
                                                      .deleteSchedule(
                                                          schedule.scheduleId);
                                                  if (parentContext.mounted) {
                                                    Toast.showSuccessToast(
                                                            message:
                                                                "삭제에 성공했습니다")
                                                        .show(parentContext);
                                                    Navigator.of(parentContext)
                                                        .pop();
                                                  }
                                                } catch (e) {
                                                  if (parentContext.mounted) {
                                                    Toast.showErrorToast(
                                                            message:
                                                                e.toString())
                                                        .show(parentContext);
                                                  }
                                                }
                                              },
                                            );
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        width: gap,
                                      ),
                                      PrimaryButton(
                                        fontSize: 16,
                                        width: parentWidth / 2,
                                        buttonName: "수정",
                                        onPressed: () async {
                                          // Navigator.of(context).push(
                                          //   MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         EditScheduleScreen(
                                          //       mode: EditMode.EDIT,
                                          //       initialScheduleValue:
                                          //           widget.schedule,
                                          //     ),
                                          //   ),
                                          // );

                                          // 수정 페이지로 이동 후, 수정 결과 반환
                                          final updatedSchedule =
                                              await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditScheduleScreen(
                                                mode: EditMode.EDIT,
                                                initialScheduleValue:
                                                    schedule.copyWithNewDate(
                                                  targetDate: DateTime(
                                                    widget.date.year,
                                                    widget.date.month,
                                                    widget.date.day,
                                                    schedule.startTime.hour,
                                                    schedule.startTime.minute,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );

                                          if (updatedSchedule != null &&
                                              updatedSchedule
                                                  is ScheduleModel) {
                                            // 새로운 ID로 변경될 수 있으므로 업데이트
                                            setState(() {
                                              scheduleId =
                                                  updatedSchedule.scheduleId;
                                            });
                                            _updateSchedule(); // 최신 데이터 반영
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
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
