import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pico/memories/view/timecapsule_editor/anniversary_selection_form.dart';
import 'package:pico/memories/view/timecapsule_editor/letter_form.dart';
import 'package:pico/memories/view/timecapsule_editor/photo_upload_form.dart';

class WritingTimeCapsuleScreen extends StatefulWidget {
  const WritingTimeCapsuleScreen({super.key});

  @override
  State<WritingTimeCapsuleScreen> createState() =>
      _WritingTimeCapsuleScreenState();
}

class _WritingTimeCapsuleScreenState extends State<WritingTimeCapsuleScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: SafeArea(
            child: Column(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        _prevPage();
                        FocusScope.of(context).unfocus(); // 키보드 내리기
                      },
                      child: Text(
                        _currentPage == 0 ? "" : "이전",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _nextPage();
                        FocusScope.of(context).unfocus(); // 키보드 내리기
                      },
                      child: Text(
                        _currentPage == 2 ? "완료" : "다음",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
