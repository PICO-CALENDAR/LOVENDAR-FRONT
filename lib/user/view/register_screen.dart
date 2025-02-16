import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico/common/auth/model/auth_model.dart';
import 'package:pico/common/auth/provider/auth_provider.dart';
import 'package:pico/common/components/action_button.dart';
import 'package:pico/common/components/date_input.dart';
import 'package:pico/common/components/input_field.dart';
import 'package:pico/common/components/round_checkbox.dart';
import 'package:pico/common/components/toast.dart';
import 'package:pico/common/theme/theme_light.dart';
import 'package:pico/user/model/register_body.dart';
import 'package:pico/user/model/user_model.dart';
import 'package:pico/user/provider/user_provider.dart';
import 'package:pico/user/repository/user_repository.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  static String get routeName => 'register';
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
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
    _nicknameController.dispose();
    super.dispose();
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
                ? AutovalidateMode.always
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
                            title: "이름",
                            hint: "김피코",
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '이름(실명)을 입력해주세요';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),

                          // Name TextFormField
                          InputField(
                            title: "별명",
                            hint: "귀여운 피코",
                            controller: _nicknameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '별명을 입력해주세요';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),

                          // Birthday Picker with validation
                          DateInput(
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

                          DateInput(
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
                                  name: _nameController.text,
                                  gender: _genderValue,
                                  nickName: _nicknameController.text,
                                  birth: _birthDate!
                                      .toIso8601String()
                                      .split("T")[0],
                                  dday: _dDay!.toIso8601String().split("T")[0],
                                  isMarketingAgreed: _isMarketingAgreed,
                                  isTermsAgreed: _isTermsAgreed,
                                );

                                try {
                                  // 회원가입
                                  final response = await ref
                                      .read(userRepositoryProvider)
                                      .postRegister(
                                        id: authInfo.id.toString(),
                                        body: body,
                                      );

                                  // 회원가입한 걸로 auth 저장 (token 저장 로직 포함)
                                  await ref
                                      .read(authProvider.notifier)
                                      .register(response);

                                  ref.read(userProvider.notifier).getUserInfo();

                                  // // 로그인 후 홈으로 이동
                                  // if (context.mounted) {
                                  //   context.go("/");
                                  // }
                                  // 성공 시 처리
                                } on DioException catch (e) {
                                  if (e.response != null) {
                                    print("HTTP 에러: ${e.response?.statusCode}");
                                    print("서버 응답: ${e.response?.data}");
                                  } else {
                                    print("에러 메시지: ${e.message}");
                                  }
                                  if (context.mounted) {
                                    Toast.showErrorToast(
                                            message: "회원가입 중 오류가 발생했습니다")
                                        .show(context);
                                  }
                                }
                              } else {
                                Toast.showErrorToast(message: "잘못된 접근입니다")
                                    .show(context);
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
                              Toast.showErrorToast(message: "필수 약관에 동의해야 합니다")
                                  .show(context);
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
}
