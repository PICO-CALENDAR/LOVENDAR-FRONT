import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pico/common/components/toast.dart';
import 'package:pico/memories/provider/memory_box_provider.dart';
import 'package:pico/memories/provider/timecapsule_form_provider.dart';
import 'package:pico/memories/view/timecapsule_editor/anniversary_selection_form.dart';
import 'package:pico/memories/view/timecapsule_editor/letter_form.dart';
import 'package:pico/memories/view/timecapsule_editor/photo_upload_form.dart';

class WritingTimeCapsuleScreen extends ConsumerStatefulWidget {
  const WritingTimeCapsuleScreen({super.key});

  @override
  ConsumerState<WritingTimeCapsuleScreen> createState() =>
      _WritingTimeCapsuleScreenState();
}

class _WritingTimeCapsuleScreenState
    extends ConsumerState<WritingTimeCapsuleScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _nextPage() async {
    final timecapsuleForm = ref.read(timecapsuleFormProvider);
    final validations = [
      timecapsuleForm.schedule != null,
      timecapsuleForm.photo != null,
      timecapsuleForm.letterTitle != null && timecapsuleForm.letter != null
    ];

    final messages = [
      "타임캡슐이 열릴 기념일을 선택해주세요",
      "타임캡슐에 들어갈 사진을 선택해주세요",
      "타임캡슐의 제목과 편지를 적어주세요"
    ];

    if (_currentPage < 2) {
      if (!validations[_currentPage]) {
        Toast.showErrorToast(
          message: messages[_currentPage],
        ).show(context);
        return;
      }
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (_currentPage == 2) {
      // 맨 마지막, 타임캡슐 생성하기
      // 유효성 검사
      if (timecapsuleForm.letterTitle!.length > 16) {
        Toast.showErrorToast(
          message: "16자 이하로 제목을 작성해주세요",
        ).show(context);
        return;
      }

      if (timecapsuleForm.letterTitle!.isEmpty ||
          timecapsuleForm.letter!.isEmpty) {
        Toast.showErrorToast(
          message: "제목과 편지를 작성해주요",
        ).show(context);
        return;
      }
      // 모든 일정 삭제
      try {
        await ref.read(memoryBoxProvider.notifier).createTimecapsule();
        if (mounted) {
          ref.read(timecapsuleFormProvider.notifier).resetAll();
          Navigator.of(context).pop();
          Toast.showSuccessToast(message: "타임캡슐을 성공적으로 생성했습니다").show(context);
          Confetti.launch(
            context,
            options: const ConfettiOptions(
              particleCount: 100,
              spread: 70,
              y: 0.6,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          Toast.showErrorToast(message: e.toString()).show(context);
        }
      }
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: Colors.black.withOpacity(0.3),
          // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            MdiIcons.handHeart,
                            size: 30,
                            color: Colors.white,
                          ),
                          const Text(
                            "타임 캡슐 작성하기",
                            style: TextStyle(
                              fontFamily: "Kyobo",
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              ref
                                  .read(timecapsuleFormProvider.notifier)
                                  .resetAll();
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.close_rounded,
                              size: 27,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final hight = constraints.maxHeight;
                          return Row(
                            children: [
                              AnimatedContainer(
                                curve: Curves.easeInOut,
                                duration: Duration(
                                  milliseconds: 100,
                                ),
                                width: width * ((_currentPage + 1) / 3),
                                height: hight,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(), // 스크롤 막기
                        controller: _pageController,
                        onPageChanged: _onPageChanged,
                        children: [
                          AnniversarySelectionForm(),
                          PhotoUploadForm(),
                          LetterForm(),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  height: 65,
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _currentPage != 0
                                ? StepButton(
                                    label: "이전",
                                    onPressed: () {
                                      _prevPage();
                                      FocusScope.of(context)
                                          .unfocus(); // 키보드 내리기
                                    },
                                  )
                                : SizedBox.shrink(),
                            StepButton(
                              label: _currentPage == 2 ? "완료" : "다음",
                              onPressed: () {
                                _nextPage();
                                FocusScope.of(context).unfocus(); // 키보드 내리기
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
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

class StepButton extends StatelessWidget {
  const StepButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  final void Function()? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor, // ✅ 배경색 변경
        foregroundColor: Colors.white, // 글자색 변경
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
