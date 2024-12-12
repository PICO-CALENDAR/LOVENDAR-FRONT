import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pico/common/components/action_button.dart';
import 'package:pico/common/components/input_field.dart';
import 'package:pico/common/model/custom_calendar.dart';
import 'package:pico/common/theme/theme_light.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eventTitle = TextEditingController();
  final TextEditingController _eventPeople = TextEditingController();

  bool isAllDay = false;
  EventCategory selectedTab = EventCategory.MINE;
  List<String> days = ["일", "월", "화", "수", "목", "금", "토"];
  Set<String> selectedDays = {};

  @override
  void dispose() {
    _eventTitle.dispose();
    _eventPeople.dispose();
    super.dispose();
  }

  Widget _buildTabButton(EventCategory label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = label;
        });
      },
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selectedTab == label
              ? Colors.brown.shade100
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label.name,
            style: TextStyle(
              color: selectedTab == label ? Colors.brown : AppTheme.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimePicker(String label, BuildContext context) {
    return Row(
      children: [
        Icon(
          label == '시작'
              ? Icons.arrow_forward_rounded
              : Icons.arrow_back_rounded,
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
        TextButton(
          onPressed: () {
            // Show date and time picker
          },
          child: const Text(
            '2024년 10월 19일',
            style: TextStyle(color: Colors.black),
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: () {
            // Show time picker
          },
          child: const Text(
            '10:30',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "일정 추가",
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name TextFormField
                          InputField(
                            title: "일정 이름",
                            hint: "일정 이름을 입력하세요",
                            controller: _eventTitle,
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
                              _buildTabButton(EventCategory.MINE),
                              SizedBox(
                                width: 10,
                              ),
                              _buildTabButton(EventCategory.OURS),
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
                                    value: isAllDay,
                                    activeColor: Theme.of(context).primaryColor,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isAllDay = value ?? false;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildDateTimePicker('시작', context),
                          _buildDateTimePicker('종료', context),

                          const SizedBox(height: 16),
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
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: days.map((day) {
                              return ChoiceChip(
                                label: Text(day),
                                selected: selectedDays.contains(day),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      selectedDays.add(day);
                                    } else {
                                      selectedDays.remove(day);
                                    }
                                  });
                                },
                                selectedColor: Colors.brown.shade100,
                                backgroundColor: Colors.grey.shade200,
                              );
                            }).toList(),
                          ),

                          InputField(
                            title: "만나는 사람",
                            hint: "만나는 사람을 입력해주세요",
                            controller: _eventPeople,
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
                  buttonName: "일정 추가",
                  onPressed: () async {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
