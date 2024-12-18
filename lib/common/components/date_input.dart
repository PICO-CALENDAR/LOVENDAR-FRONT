import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pico/common/theme/theme_light.dart';

enum DateInputSize {
  large,
  medium,
  small,
}

class DateInput extends StatelessWidget {
  final String? title;
  final String? placeholder;
  final String invalidateMessage;
  final DateTime initialDate;
  final DateTime? Function() getDate;
  final void Function(DateTime?) setDate;
  final DateInputSize size;
  final CupertinoDatePickerMode mode;
  final String? Function(DateTime? value)? validator;

  String? _defaultValidator(DateTime? value) {
    if (value == null) {
      return invalidateMessage;
    }
    return null;
  }

  const DateInput({
    super.key,
    this.title,
    this.placeholder,
    this.invalidateMessage = "값을 입력해주세요",
    required this.initialDate,
    required this.getDate,
    required this.setDate,
    this.size = DateInputSize.medium,
    this.mode = CupertinoDatePickerMode.date,
    this.validator,
  });

  void _showDatePicker({
    required BuildContext context,
    required FormFieldState<DateTime> state,
  }) {
    DateTime? dateValue;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 350, // 버튼과 선택기를 위한 충분한 높이
          child: Column(
            children: [
              // 취소 및 확인 버튼이 있는 Row
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: const Text(
                        '취소',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // 모달 닫기
                      },
                    ),
                    CupertinoButton(
                      child: const Text(
                        '확인',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        if (dateValue != null) {
                          state.didChange(dateValue);
                          setDate(dateValue);
                        } else {
                          dateValue = initialDate;
                          state.didChange(dateValue);
                          setDate(dateValue);
                        }
                        Navigator.pop(context); // 모달 닫기
                      },
                    ),
                  ],
                ),
              ),
              // 연도와 월만 선택할 수 있는 CupertinoDatePicker
              Flexible(
                child: CupertinoDatePicker(
                  initialDateTime: initialDate, // 연도와 월만 선택하고 1일로 고정
                  mode: mode,
                  onDateTimeChanged: (DateTime newDate) {
                    dateValue = newDate;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final date = getDate();
    return FormField<DateTime>(
      validator: validator ?? _defaultValidator,
      builder: (FormFieldState<DateTime> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title != null
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title!,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (state.hasError)
                          Text(
                            state.errorText!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12.0,
                            ),
                          ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
            GestureDetector(
              onTap: () => _showDatePicker(
                context: context,
                state: state,
              ),
              child: Container(
                width: size == DateInputSize.medium ? double.infinity : null,
                padding: size == DateInputSize.small
                    ? const EdgeInsets.symmetric(vertical: 5, horizontal: 10)
                    : const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppTheme.greyColor,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    // color: date != null
                    //     ? AppTheme.primaryColor
                    //     : Colors.transparent,
                    color: Colors.transparent,
                    width: 2.0,
                  ),
                ),
                child: Text(
                  date == null && placeholder != null
                      ? placeholder!
                      : mode == CupertinoDatePickerMode.date
                          ? DateFormat.yMMMMd().format(date!)
                          : DateFormat.jm().format(date!),
                  style: TextStyle(
                    fontSize: 14,
                    color: date == null ? Colors.grey : AppTheme.textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
