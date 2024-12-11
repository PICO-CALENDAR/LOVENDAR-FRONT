import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico/common/auth/model/auth_model.dart';
import 'package:pico/common/auth/provider/auth_provider.dart';
import 'package:pico/common/components/action_button.dart';
import 'package:pico/common/components/input_field.dart';
import 'package:pico/common/components/round_checkbox.dart';
import 'package:pico/common/theme/theme_light.dart';
import 'package:pico/user/model/register_body.dart';
import 'package:pico/user/model/user_model.dart';
import 'package:pico/user/repository/user_repository.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  static String get routeName => 'register';
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  DateTime? _birthDate;
  DateTime? _dDay;
  // 나중에 개인정보 수집 약관 동의에 대해서도 처리
  bool _isTermsAgreed = false;
  bool _isMarketingAgreed = false;
  Gender _genderValue = Gender.MALE;

  bool _isSubmitted = false; // 가입 버튼 눌렀는지 여부를 추적

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showDatePicker({
    required BuildContext context,
    required FormFieldState<DateTime> state,
    required DateTime initialDate,
    required void Function(DateTime?) setDate,
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
                  mode: CupertinoDatePickerMode.date,
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

  Widget genderRadioButton(
      {required String label, required Icon icon, required Gender gender}) {
    final bool isSelected = (_genderValue == gender);
    final Color greyColor = Colors.grey.withOpacity(0.4);
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _genderValue = gender;
          });
        },
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.6,
                color: isSelected ? AppTheme.primaryColor : greyColor,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon.icon,
                  size: 40,
                  color: isSelected ? AppTheme.primaryColor : greyColor,
                ),
                SizedBox(
                  height: 1.8,
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppTheme.primaryColor : greyColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "추가 정보를 입력해주세요",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // 화면의 다른 부분을 탭하면 포커스 해제
        },
        child: SafeArea(
          child: Form(
            autovalidateMode: _isSubmitted
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name TextFormField
                          InputField(
                            title: "별명",
                            hint: "피코",
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '별명을 입력해주세요';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),

                          // Birthday Picker with validation
                          dateInputField(
                            context: context,
                            title: "생년월일",
                            placeholder: "생년월일을 입력하세요",
                            invalidateMessage: "생년월일을 입력해주세요",
                            initialDate: _birthDate ?? DateTime(2000, 1, 1),
                            getDate: () => _birthDate,
                            setDate: (DateTime? newDate) {
                              setState(() {
                                _birthDate = newDate;
                              });
                            },
                          ),
                          const SizedBox(height: 16.0),

                          dateInputField(
                            context: context,
                            title: "처음 만나게 날",
                            placeholder: "처음 만나게 된 날을 입력하세요",
                            invalidateMessage: "처음 만나게 날을 입력해주세요",
                            initialDate: _dDay ?? DateTime.now(),
                            getDate: () => _dDay,
                            setDate: (DateTime? newDate) {
                              setState(() {
                                _dDay = newDate;
                              });
                            },
                          ),

                          const SizedBox(height: 16.0),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                child: Text(
                                  '성별',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  genderRadioButton(
                                      label: "남성",
                                      icon: Icon(Icons.male_rounded),
                                      gender: Gender.MALE),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  genderRadioButton(
                                      label: "여성",
                                      icon: Icon(Icons.female_rounded),
                                      gender: Gender.FEMALE),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  genderRadioButton(
                                      label: "기타",
                                      icon: Icon(Icons.male),
                                      gender: Gender.OTHER),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      // Terms and Marketing Agreement Round Checkboxes
                      FormField<bool>(
                        validator: (value) {
                          if (value == null) {
                            return "서비스 약관 및 개인정보 수집 약관에 동의해주세요";
                          } else {
                            if (!value) {
                              return "서비스 약관 및 개인정보 수집 약관에 동의해주세요";
                            }
                            return null;
                          }
                        },
                        builder: (FormFieldState<bool> state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RoundCheckboxTile(
                                value: _isTermsAgreed,
                                onChanged: (value) {
                                  setState(() {
                                    _isTermsAgreed = value;
                                  });
                                  state.didChange(value);
                                },
                                errorMessage: state.errorText,
                                isError: state.hasError,
                                label: "서비스 이용 및 개인정보 수집 약관에 동의합니다",
                              ),
                            ],
                          );
                        },
                      ),

                      RoundCheckboxTile(
                        value: _isMarketingAgreed,
                        onChanged: (value) {
                          setState(() {
                            _isMarketingAgreed = value;
                          });
                        },
                        label: "(선택) 마케팅 활용 동의 및 광고 수신 동의에 동의합니다",
                      ),
                      const SizedBox(height: 10),
                      ActionButton(
                          buttonName: "가입하기",
                          onPressed: () async {
                            // 가입하기 버튼을 누른 상태로 변경
                            setState(() {
                              _isSubmitted = true;
                            });

                            // 폼 검증
                            if (_formKey.currentState!.validate() &&
                                _isTermsAgreed) {
                              // 조건에 맞게 잘 작성했을 때
                              final authInfo = ref.read(authProvider);
                              if (authInfo is AuthModel) {
                                final body = RegisterBody(
                                  gender: _genderValue,
                                  nickName: _nameController.text,
                                  birth: _birthDate!
                                      .toIso8601String()
                                      .split("T")[0],
                                  dday: _dDay!.toIso8601String().split("T")[0],
                                  isMarketingAgreed: _isMarketingAgreed,
                                  isTermsAgreed: _isTermsAgreed,
                                );

                                try {
                                  final response = await ref
                                      .read(userRepositoryProvider)
                                      .postRegister(
                                        id: authInfo.id.toString(),
                                        body: body,
                                      );

                                  if (mounted) {
                                    ref
                                        .read(authProvider.notifier)
                                        .register(context, response);
                                  }
                                  // 성공 시 처리
                                } on DioException catch (e) {
                                  if (e.response != null) {
                                    print("HTTP 에러: ${e.response?.statusCode}");
                                    print("서버 응답: ${e.response?.data}");
                                  } else {
                                    print("에러 메시지: ${e.message}");
                                  }
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("잘못된 접근입니다"),
                                  ),
                                );
                              }

                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(
                              //     content: Text(
                              //       _birthDate!.toIso8601String().split("T")[0],

                              //       // 'Name: ${_nameController.text}, '
                              //       // 'Birthday: ${_birthDate != null ? "${_birthDate!.year}-${_birthDate!.month.toString().padLeft(2, '0')}-${_birthDate!.day.toString().padLeft(2, '0')}" : 'Not selected'}, '
                              //       // '_dDay: ${_dDay != null ? "${_dDay!.year}-${_dDay!.month.toString().padLeft(2, '0')}-${_dDay!.day.toString().padLeft(2, '0')}" : 'Not selected'}, '
                              //       // 'Marketing Agreement: $_isMarketingAgreed',
                              //     ),
                              //   ),
                              // );
                            } else if (!_isTermsAgreed) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("필수 약관에 동의해야 합니다."),
                                ),
                              );
                            }
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FormField<DateTime> dateInputField({
    required BuildContext context,
    required String title,
    required String placeholder,
    required String invalidateMessage,
    required DateTime initialDate,
    required DateTime? Function() getDate,
    required void Function(DateTime?) setDate,
  }) {
    final date = getDate();
    return FormField<DateTime>(
      validator: (value) {
        if (value == null) {
          return invalidateMessage;
        }
        return null;
      },
      builder: (FormFieldState<DateTime> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
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
            ),
            GestureDetector(
              onTap: () => _showDatePicker(
                context: context,
                state: state,
                initialDate: initialDate,
                setDate: setDate,
              ),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppTheme.greyColor,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    // color: date != null
                    //     ? AppTheme.primaryColor
                    //     : Colors.transparent,
                    color: Colors.transparent,
                    width: 2.0,
                  ),
                ),
                child: Text(
                  date == null
                      ? placeholder
                      : "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                  style: TextStyle(
                    fontSize: 16,
                    color: date == null ? Colors.grey : AppTheme.textColor,
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
