// 디데이 수정 모달 창
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pico/common/components/action_button.dart';
import 'package:pico/common/components/date_input.dart';
import 'package:pico/common/components/toast.dart';
import 'package:pico/common/theme/theme_light.dart';
import 'package:pico/common/utils/date_operations.dart';
import 'package:pico/common/utils/extenstions.dart';
import 'package:pico/user/model/user_model.dart';
import 'package:pico/user/provider/user_provider.dart';

class DdayEidtModal extends ConsumerStatefulWidget {
  const DdayEidtModal({super.key});
  static const ALPHA_VALUE = 76;

  @override
  ConsumerState<DdayEidtModal> createState() => _DdayEidtModalState();
}

class _DdayEidtModalState extends ConsumerState<DdayEidtModal> {
  late DateTime ddayDateTime;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    final todayMid = DateTime(today.year, today.month, today.day);
    final userInfo = ref.read(userProvider) as UserModel;
    ddayDateTime =
        userInfo.dday != null ? DateTime.parse(userInfo.dday!) : todayMid;
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(userProvider) as UserModel;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: Colors.black.withAlpha(DdayEidtModal.ALPHA_VALUE),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: SafeArea(
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                width: screenWidth * 0.8,
                height: screenWidth * 0.8 * 1.2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Text(
                            "우리가 만난 날",
                            style: TextStyle(
                              fontFamily: "Kyobo",
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 프로필
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey,
                                backgroundImage: userInfo.profileImage != null
                                    ? NetworkImage(userInfo.profileImage!)
                                    : AssetImage(
                                        "images/basic_profile.png",
                                      ), // Replace  // Replace with actual image path
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Icon(
                                  MdiIcons.cardsHeart,
                                  color: Colors.pinkAccent,
                                ),
                              ),
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey,
                                backgroundImage: userInfo.partnerProfileImage !=
                                        null
                                    ? NetworkImage(
                                        userInfo.partnerProfileImage!)
                                    : AssetImage(
                                        "images/basic_profile.png",
                                      ), // Replace  // Replace with actual image path
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          // 디데이 한글로
                          Text(
                            parseStringDdayToInDaysString(
                                dday: ddayDateTime
                                    .toIso8601String()
                                    .split("T")[0]),
                            style: TextStyle(
                              fontFamily: "Kyobo",
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: userInfo.dday != null
                                  ? !ddayDateTime.isSameDate(
                                          DateTime.parse(userInfo.dday!))
                                      ? AppTheme.primaryColorDark
                                      : AppTheme.textColor
                                  : Color.fromARGB(255, 86, 96, 73),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          // 디데이 날짜 입력 Input 및 저장
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Column(
                              children: [
                                DateInput(
                                  initialDate: ddayDateTime,
                                  getDate: () => ddayDateTime,
                                  setDate: (DateTime? newDate) {
                                    final today = DateTime.now();
                                    final todayMid = DateTime(
                                        today.year, today.month, today.day);

                                    if (newDate != null) {
                                      if (newDate.isAfter(todayMid)) {
                                        Toast.showErrorToast(
                                                message: "미래의 날짜는 선택할 수 없습니다.")
                                            .show(context);
                                        return;
                                      }

                                      setState(() {
                                        ddayDateTime = newDate;
                                      });
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                ActionButton(
                                  fontSize: 14,
                                  disabled: userInfo.dday != null
                                      ? ddayDateTime.isSameDate(
                                          DateTime.parse(userInfo.dday!))
                                      : false,
                                  buttonName: "디데이 수정하기",
                                  onPressed: () async {
                                    // TODO: Dday 수정하는 API 요청 보내기 (커플 맺기 에러 해결 뒤)
                                    FocusScope.of(context).unfocus();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    // 실제 디데이
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
