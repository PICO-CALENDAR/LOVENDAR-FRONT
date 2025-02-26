import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lovendar/common/components/action_button.dart';
import 'package:lovendar/common/components/compact_input.dart';
import 'package:lovendar/common/components/date_input.dart';
import 'package:lovendar/common/components/primary_button.dart';
import 'package:lovendar/common/components/toast.dart';
import 'package:lovendar/common/model/custom_exception.dart';
import 'package:lovendar/common/theme/theme_light.dart';
import 'package:lovendar/common/utils/extenstions.dart';
import 'package:lovendar/user/model/register_body.dart';
import 'package:lovendar/user/model/user_model.dart';
import 'package:lovendar/user/provider/profile_form_provider.dart';
import 'package:lovendar/user/provider/user_provider.dart';

class ProfileEdit extends ConsumerStatefulWidget {
  const ProfileEdit({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  ConsumerState<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends ConsumerState<ProfileEdit> {
  late final TextEditingController _controller;
  late DateTime birthday;
  bool validate = false;

  @override
  void initState() {
    super.initState();
    final btnType = ref.read(editButtonProvider);
    _controller = TextEditingController(text: getInitialValue(btnType));

    if (btnType == EditButtonType.birth) {
      birthday = DateTime.parse(getInitialValue(btnType));
    }
    _controller.addListener(() {
      setState(() {}); // controller 값이 바뀔 때마다 build 호출
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final btnType = ref.read(editButtonProvider);
    _controller.text = getInitialValue(btnType); // ✅ 상태 변경 시 초기값 업데이트
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String labelGen(EditButtonType type) {
    switch (type) {
      case EditButtonType.name:
        return "이름";
      case EditButtonType.nickname:
        return "별명";
      case EditButtonType.birth:
        return "생일";
      case EditButtonType.none:
      default:
        return "";
    }
  }

  String getInitialValue(EditButtonType type) {
    final value = ref.read(userProvider) as UserModel;
    switch (type) {
      case EditButtonType.name:
        return value.name;
      case EditButtonType.nickname:
        return value.nickName;
      case EditButtonType.birth:
        return value.birth;
      case EditButtonType.none:
      default:
        return "";
    }
  }

  Future<void> submitChange(EditButtonType type) async {
    final handler = ref.read(userProvider.notifier);
    RegisterBody? body;
    print(type);
    switch (type) {
      case EditButtonType.name:
        body = RegisterBody(name: _controller.text);
        break;
      case EditButtonType.nickname:
        body = RegisterBody(nickName: _controller.text);
        break;
      case EditButtonType.birth:
        if (!birthday.isSameDate(DateTime.parse(getInitialValue(type)))) {
          body = RegisterBody(birth: birthday.toIso8601String().split("T")[0]);
        }
        break;
      case EditButtonType.none:
      default:
        return;
    }
    if (body != null) {
      try {
        await handler.updateUserInfo(body);
        if (mounted) {
          Toast.showSuccessToast(message: "${labelGen(type)}을 성공적으로 변경했습니다")
              .show(context);
          animateToProfileDetailPage(context);
        }
      } catch (e) {
        if (mounted) {
          if (e is CustomException) {
            Toast.showErrorToast(message: e.message).show(context);
          } else {
            Toast.showErrorToast(message: "${labelGen(type)} 변경에 실패했습니다")
                .show(context);
          }
        }
      }
    }
  }

  bool validator(EditButtonType type) {
    switch (type) {
      case EditButtonType.name:
      case EditButtonType.nickname:
        // 아무것도 입력된 것이 없거나, 초기값과 같은 경우 disabled 처리
        return _controller.text.isEmpty ||
            _controller.text == getInitialValue(type);
      case EditButtonType.birth:
        return birthday.isSameDate(DateTime.parse(getInitialValue(type)));
      // 예외 사항에는 무조건 disabled로 일단 처리
      case EditButtonType.none:
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final btnType = ref.watch(editButtonProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(
          title: Text(
            "프로필 수정하기",
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              animateToProfileDetailPage(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              btnType == EditButtonType.birth
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                          child: Text(
                            labelGen(btnType),
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DateInput(
                          initialDate: birthday,
                          getDate: () => birthday,
                          setDate: (DateTime? newDate) {
                            if (newDate != null) {
                              setState(() {
                                birthday = newDate;
                              });
                            }
                          },
                        ),
                      ],
                    )
                  : CompactInput(
                      title: labelGen(btnType),
                      hint: labelGen(btnType),
                      initialValue: getInitialValue(btnType),
                      controller: _controller,
                    ),
              SizedBox(
                height: 20,
              ),
              ActionButton(
                fontSize: 18,
                disabled: validator(btnType),
                buttonName: "저장 하기",
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  await submitChange(btnType);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void animateToProfileDetailPage(BuildContext context) {
    widget.pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}
