// 타임캡슐 페이지
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lovendar/common/theme/theme_light.dart';
import 'package:lovendar/common/utils/modals.dart';
import 'package:lovendar/memories/components/timecapsule/timecapsule_list_item.dart';
import 'package:lovendar/memories/components/timecapsule/timecapsule_card.dart';
import 'package:lovendar/memories/model/timecapsule_model.dart';
import 'package:lovendar/memories/model/timecapsules_response.dart';
import 'package:lovendar/memories/repository/memory_box_repository.dart';

class SentboxScreen extends StatelessWidget {
  const SentboxScreen({super.key});
  static const ALPHA_VALUE = 76;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: Colors.black.withAlpha(ALPHA_VALUE),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "보낸 타임캡슐",
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
                Expanded(
                  child: MyTimecapsuleTab(),
                ),

                // Expanded(
                //   child: ListView.builder(
                //     itemCount: 4,
                //     itemBuilder: (context, index) {
                //       return GestureDetector(
                //         onTap: () {
                //           Navigator.of(context).push(
                //             createBluredBackgroundPage(
                //               screen: TimeCapsuleDetailScreen(index: index),
                //             ),
                //           );
                //         },
                //         child: Hero(
                //           tag: index,
                //           child: TimecapsuleListItem(),
                //         ),
                //       );
                //     },
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum TimecapsuleType { opened, upcoming }

extension TimecapsuleTypeExtension on TimecapsuleType {
  String get value {
    switch (this) {
      case TimecapsuleType.opened:
        return "열린";
      case TimecapsuleType.upcoming:
        return "잠긴";
    }
  }
}

class MyTimecapsuleTab extends ConsumerStatefulWidget {
  const MyTimecapsuleTab({super.key});

  @override
  ConsumerState<MyTimecapsuleTab> createState() => _MyTimecapsuleTabState();
}

class _MyTimecapsuleTabState extends ConsumerState<MyTimecapsuleTab> {
  TimecapsuleType _selectedSentBox = TimecapsuleType.upcoming;

  late Map<TimecapsuleType, Future<TimecapsulesResponse>> myTimeCapsules;

  @override
  void initState() {
    super.initState();

    myTimeCapsules = <TimecapsuleType, Future<TimecapsulesResponse>>{
      TimecapsuleType.upcoming: _fetchOpenedMyTimecapsules(),
      TimecapsuleType.opened: _fetchUpcomingMyTimecapsules(),
    };
  }

  Future<TimecapsulesResponse> _fetchOpenedMyTimecapsules() async {
    final repository = ref.read(memoryBoxRepositoryProvider);
    final response = await repository.getOpenedMyTimecapsules();
    return response;
  }

  Future<TimecapsulesResponse> _fetchUpcomingMyTimecapsules() async {
    final repository = ref.read(memoryBoxRepositoryProvider);
    final response = await repository.getUpcomingMyTimecapsules();
    return response;
  }

  Future<void> _refreshData() async {
    setState(() {
      myTimeCapsules = <TimecapsuleType, Future<TimecapsulesResponse>>{
        TimecapsuleType.upcoming: _fetchOpenedMyTimecapsules(),
        TimecapsuleType.opened: _fetchUpcomingMyTimecapsules(),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoSlidingSegmentedControl<TimecapsuleType>(
          backgroundColor: Colors.white24,
          // backgroundColor: CupertinoColors.systemGrey2,
          groupValue: _selectedSentBox,
          onValueChanged: (TimecapsuleType? value) {
            if (value != null) {
              setState(() {
                _selectedSentBox = value;
              });
            }
          },
          children: const <TimecapsuleType, Widget>{
            TimecapsuleType.upcoming: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 26,
                vertical: 7,
              ),
              child: Text(
                '잠긴 타임캡슐',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TimecapsuleType.opened: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 26,
                vertical: 7,
              ),
              child: Text(
                '열린 타임캡슐',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          },
        ),
        // Expanded(
        //   child: Center(
        //     child: Text(
        //       'Selected Segment: ${_selectedSentBox.name} ${myTimeCapsules[_selectedSentBox]}',
        //     ),
        //   ),
        // )

        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: FutureBuilder<TimecapsulesResponse>(
              future: myTimeCapsules[_selectedSentBox],
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.scaffoldBackgroundColorDark,
                    ),
                  ); // 로딩 표시
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "오류 발생: ${snapshot.error}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ); // 오류 메시지
                } else if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
                  return Center(
                    child: Text(
                      "${_selectedSentBox.value} 타임캡슐이 없습니다.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ); // 데이터 없음 처리
                }

                final timecapsules = snapshot.data!.items;

                return ListView.separated(
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  itemCount: timecapsules.length,
                  itemBuilder: (context, index) {
                    final currentTimecapsule = timecapsules[index];

                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .scaffoldBackgroundColor
                              .withAlpha(200),
                          border: Border.all(
                            color: Theme.of(context)
                                .scaffoldBackgroundColor
                                .withAlpha(200),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // // 타임캡슐이 무조건 하나는 있을것이므로, 0번째 타임캡슐 기준으로 날짜 계산
                                // Text(
                                //   DateFormat.yMd().format(
                                //     currentTimecapsule.timeCapsules[0]
                                //         .scheduleStartTime,
                                //   ),
                                //   style: TextStyle(
                                //     fontFamily: "Kyobo",
                                //     fontSize: 14,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                                // Text(
                                //   "D-${currentTimecapsule.timeCapsules[0].scheduleStartTime.difference(today).inDays}",
                                //   style: TextStyle(
                                //     fontFamily: "Kyobo",
                                //     fontSize: 14,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                              ],
                            ),
                            Text(
                              currentTimecapsule.scheduleTitle,
                              style: TextStyle(
                                fontFamily: "Kyobo",
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      SizedBox(height: 10), // ✅ 간격 추가
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
