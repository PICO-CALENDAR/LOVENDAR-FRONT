import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pico/common/components/action_button.dart';
import 'package:pico/common/components/date_input.dart';
import 'package:pico/common/components/input_field.dart';
import 'package:pico/common/components/toast.dart';
import 'package:pico/common/provider/selected_day_provider.dart';
import 'package:pico/common/schedule/model/schedule_model.dart';
import 'package:pico/common/schedule/model/update_schedule_body.dart';
import 'package:pico/common/schedule/provider/schedules_provider.dart';
import 'package:pico/common/schedule/repository/schedule_repository.dart';
import 'package:pico/common/theme/theme_light.dart';
import 'package:pico/common/utils/extenstions.dart';
import 'package:pico/common/utils/modals.dart';
import 'package:pico/user/view/register_screen.dart';
import 'package:go_router/go_router.dart';

enum EditMode {
  EDIT,
  ADD,
}

class EditScheduleScreen extends ConsumerStatefulWidget {
  final EditMode mode;
  final ScheduleModel? initialScheduleValue;

  static String get routeName => 'editSchedule';
  const EditScheduleScreen({
    super.key,
    this.mode = EditMode.ADD,
    this.initialScheduleValue,
  });

  @override
  ConsumerState<EditScheduleScreen> createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends ConsumerState<EditScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _scheduleTitle = TextEditingController();
  final TextEditingController _meetingPeople = TextEditingController();
  bool _isSubmitted = false; // 저장 혹은 추가 버튼 눌렀는지 여부를 추적

  bool _isAllDay = false;
  ScheduleType _category = ScheduleType.MINE;
  RepeatType? _repeatType;
  late DateTime _initialDay;
  late DateTime startDay;
  late DateTime endDay;
  late DateTime startTime;
  late DateTime endTime;
  List<DropdownMenuItem<RepeatType>> repeatDropDownMenuItems = [
    DropdownMenuItem<RepeatType>(
      value: null,
      child: Text(
        "없음",
        style: TextStyle(
          color: AppTheme.textColor,
          fontSize: 14,
        ),
      ),
    ),
    ...RepeatType.values.map(
      (item) => DropdownMenuItem<RepeatType>(
        value: item,
        child: Text(
          item.getName(),
          style: TextStyle(
            color: AppTheme.textColor,
            fontSize: 14,
          ),
        ),
      ),
    )
  ];

  bool isDateRangeValid() {
    if (_isAllDay) {
      final start = DateTime(startDay.year, startDay.month, startDay.day, 0, 0);
      final end = DateTime(endDay.year, endDay.month, endDay.day, 0, 0);
      return start.isBefore(end) || start.isSameDate(end);
    } else {
      final start = DateTime(startDay.year, startDay.month, startDay.day,
          startTime.hour, startTime.minute);
      final end = DateTime(
          endDay.year, endDay.month, endDay.day, endTime.hour, endTime.minute);

      return start.isBefore(end);
    }
  }

  // bool isEndRangeValid() {
  //   final end = DateTime(
  //       endDay.year, endDay.month, endDay.day, endTime.hour, endTime.minute);
  //   final start = DateTime(startDay.year, startDay.month, startDay.day,
  //       startTime.hour, startTime.minute);
  //   return end.isAfter(start);
  // }

  @override
  void initState() {
    _initialDay = ref.read(selectedDayProvider);
    if (widget.mode == EditMode.ADD) {
      startDay = DateTime(_initialDay.year, _initialDay.month, _initialDay.day);
      endDay = DateTime(_initialDay.year, _initialDay.month, _initialDay.day);
      startTime = _initialDay;
      endTime = _initialDay.add(Duration(hours: 1));
    } else {
      if (widget.initialScheduleValue != null) {
        final initialValue = widget.initialScheduleValue!;
        _scheduleTitle.text = initialValue.title;
        _category = initialValue.category;
        _isAllDay = initialValue.isAllDay;
        startDay = DateTime(initialValue.startTime.year,
            initialValue.startTime.month, initialValue.startTime.day);
        endDay = DateTime(initialValue.endTime.year, initialValue.endTime.month,
            initialValue.endTime.day);
        startTime = initialValue.startTime;
        endTime = initialValue.endTime;
        _repeatType = initialValue.repeatType;
        if (initialValue.meetingPeople != null) {
          _meetingPeople.text = initialValue.meetingPeople!;
        }
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    _scheduleTitle.dispose();
    _meetingPeople.dispose();
    super.dispose();
  }

  Widget _buildTabButton(ScheduleType label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _category = label;
        });
      },
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _category == label
              ? Theme.of(context).primaryColor
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label.getName(),
            style: TextStyle(
              color: _category == label
                  ? AppTheme.scaffoldBackgroundColor
                  : AppTheme.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimePicker(String label, BuildContext context) {
    final bool isStart = label == '시작';

    return Row(
      children: [
        Icon(
          isStart ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        if (isStart)
          // 시작 날짜
          DateInput(
            validator: (value) => null,
            size: DateInputSize.small,
            initialDate: startDay,
            getDate: () => startDay,
            setDate: (DateTime? newDate) {
              if (newDate != null) {
                setState(() {
                  startDay = newDate;
                });
              }
            },
          )
        else
          // 종료 날짜
          DateInput(
            validator: (value) => null,
            size: DateInputSize.small,
            initialDate: endDay,
            getDate: () => endDay,
            setDate: (DateTime? newDate) {
              if (newDate != null) {
                setState(() {
                  endDay = newDate;
                });
              }
            },
          ),
        const SizedBox(width: 8),
        if (!_isAllDay)
          if (isStart)
            // 시작 시간
            DateInput(
              validator: (value) => null,
              size: DateInputSize.small,
              mode: CupertinoDatePickerMode.time,
              initialDate: startTime,
              getDate: () => startTime,
              setDate: (DateTime? newTime) {
                if (newTime != null) {
                  setState(() {
                    startTime = newTime;
                  });
                }
              },
            )
          else
            // 종료 시간
            DateInput(
              validator: (value) => null,
              size: DateInputSize.small,
              mode: CupertinoDatePickerMode.time,
              initialDate: endTime,
              getDate: () => endTime,
              setDate: (DateTime? newTime) {
                if (newTime != null) {
                  setState(() {
                    endTime = newTime;
                  });
                }
              },
            )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(scheduleRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mode == EditMode.ADD ? "일정 추가" : "일정 수정",
        ),
        automaticallyImplyLeading: false, // 이전 버튼 제거
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () {
              try {
                context.pop();
              } catch (e) {
                context.go("/");
              }
            },
          ),
        ],
        // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Form(
                      autovalidateMode: _isSubmitted
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InputField(
                            title: "일정 이름",
                            hint: "일정 이름을 입력하세요",
                            controller: _scheduleTitle,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '일정 이름을 입력해주세요';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _buildTabButton(ScheduleType.MINE),
                              SizedBox(
                                width: 10,
                              ),
                              _buildTabButton(ScheduleType.OURS),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    MdiIcons.calendarToday,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "하루종일",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Center(
                                child: Transform.scale(
                                  scale: 0.9, // 스위치 크기를 확대 (1.0이 기본 크기)
                                  child: CupertinoSwitch(
                                    value: _isAllDay,
                                    activeColor: Theme.of(context).primaryColor,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _isAllDay = value ?? false;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (!isDateRangeValid())
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 4,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '시작 일자는 종료 일자보다 이전이어야 합니다',
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          _buildDateTimePicker('시작', context),
                          const SizedBox(height: 16),
                          _buildDateTimePicker('종료', context),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    MdiIcons.repeat,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  SizedBox(width: 8),
                                  Text('반복', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                              SizedBox(
                                width: 200,
                                height: 40,
                                child: DropdownButtonFormField2<RepeatType>(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    isCollapsed: true,
                                    // Add Horizontal padding using menuItemStyleData.padding so it matches
                                    // the menu padding when button's width is not specified.
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),

                                    // Add more decoration..
                                  ),
                                  // hint: const Text(
                                  //   '반복 설정',
                                  //   style: TextStyle(fontSize: 14),
                                  // ),
                                  items: repeatDropDownMenuItems,
                                  onChanged: (value) {
                                    _repeatType = value;
                                  },
                                  // onSaved: (value) {
                                  //   repeatType = value;
                                  // },
                                  buttonStyleData: ButtonStyleData(
                                    padding: EdgeInsets.only(right: 10),
                                  ),
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      Icons.arrow_drop_down_rounded,
                                      color: Colors.black45,
                                    ),
                                    iconSize: 24,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          InputField(
                            title: "만나는 사람",
                            hint: "만나는 사람을 입력해주세요",
                            controller: _meetingPeople,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ActionButton(
                  buttonName: widget.mode == EditMode.ADD ? "일정 추가" : "일정 수정",
                  onPressed: () async {
                    setState(() {
                      _isSubmitted = true;
                    });

                    if (_formKey.currentState!.validate() &&
                        isDateRangeValid()) {
                      // 일정 추가

                      final start = _isAllDay
                          ? DateTime(
                              startDay.year,
                              startDay.month,
                              startDay.day,
                              0,
                              0,
                            )
                          : DateTime(
                              startDay.year,
                              startDay.month,
                              startDay.day,
                              startTime.hour,
                              startTime.minute,
                            );
                      final end = _isAllDay
                          ? DateTime(
                              endDay.year,
                              endDay.month,
                              endDay.day,
                              0,
                              0,
                            )
                          : DateTime(
                              endDay.year,
                              endDay.month,
                              endDay.day,
                              endTime.hour,
                              endTime.minute,
                            );

                      if (widget.mode == EditMode.ADD) {
                        final body = ScheduleModelBase(
                          title: _scheduleTitle.text,
                          startTime: start,
                          endTime: end,
                          category: _category,
                          isAllDay: _isAllDay,
                          isRepeat: _repeatType != null,
                          repeatType: _repeatType,
                        );

                        try {
                          // print(body.toJson().toString());

                          await ref
                              .read(schedulesProvider.notifier)
                              .postAddSchedule(body);
                          Toast.showSuccessToast(
                            message: "일정을 성공적으로 추가했습니다",
                          ).show(context);
                          Navigator.of(context).pop();
                        } catch (e) {
                          print(e);
                          if (mounted) {
                            Toast.showErrorToast(
                              message: "일정 추가에 문제가 생겼습니다",
                            ).show(context);
                          }
                        }
                      } else {
                        if (widget.initialScheduleValue != null) {
                          final initial = widget.initialScheduleValue!;
                          final bool isTitleChanged =
                              initial.title != _scheduleTitle.text;
                          final bool isStartTimeChanged =
                              !initial.startTime.isAtSameMomentAs(start);
                          final bool isEndTimeChanged =
                              !initial.endTime.isAtSameMomentAs(end);
                          final bool isCategoryChanged =
                              initial.category != _category;
                          final bool isAllDayChanged =
                              initial.isAllDay != _isAllDay;
                          final bool isRepeatTypeChanged =
                              initial.repeatType != _repeatType;

                          final UpdateScheduleBody updatedBody =
                              UpdateScheduleBody(
                            title: isTitleChanged
                                ? _scheduleTitle.text
                                : initial.title,
                            startTime:
                                isStartTimeChanged ? start : initial.startTime,
                            endTime: isEndTimeChanged ? end : initial.endTime,
                            category: isCategoryChanged
                                ? _category
                                : initial.category,
                            isAllDay:
                                isAllDayChanged ? _isAllDay : initial.isAllDay,
                            isRepeat: isRepeatTypeChanged
                                ? _repeatType != null
                                : initial.isRepeat,
                            repeatType: isRepeatTypeChanged
                                ? _repeatType
                                : initial.repeatType,
                          );

                          try {
                            // print(body.toJson().toString());

                            await ref
                                .read(schedulesProvider.notifier)
                                .postEditSchedule(
                                  scheduleId: initial.scheduleId.toString(),
                                  body: updatedBody,
                                );
                            Toast.showSuccessToast(
                              message: "일정을 성공적으로 수정했습니다",
                            ).show(context);
                            Navigator.of(context).pop();
                          } catch (e) {
                            if (mounted) {
                              Toast.showErrorToast(
                                message: "일정 수정에 문제가 생겼습니다",
                              ).show(context);
                            }
                          }
                        }
                      }
                    } else {
                      // final body = UpdateScheduleBody(
                      //   title: _scheduleTitle.text,
                      //   startTime: start,
                      //   endTime: end,
                      //   category: _category,
                      //   isAllDay: _isAllDay,
                      //   isRepeat: _repeatType != null,
                      //   repeatType: _repeatType,
                      // );
                    }

                    // else {
                    //   // if (!isDateRangeValid()) {
                    //   //   print("날짜 범위가 잘못되었습니다.");
                    //   // }
                    //   // print("폼 검증 실패");
                    // }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
