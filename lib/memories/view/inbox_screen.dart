// 타임캡슐 페이지
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pico/common/theme/theme_light.dart';
import 'package:pico/common/utils/modals.dart';
import 'package:pico/memories/model/timecapsules_with_anni_response.dart';
import 'package:pico/memories/repository/memory_box_repository.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  late Future<TimecapsulesWithAnniResponse> _timecapsules;
  DateTime today = DateTime.now(); // 오늘 날짜

  @override
  void initState() {
    super.initState();
    _timecapsules = _fetchTimecapsules();
  }

  Future<TimecapsulesWithAnniResponse> _fetchTimecapsules() async {
    final repository = ref.read(memoryBoxRepositoryProvider);
    final response = await repository.getTimecapsules();
    return response;
  }

  Future<void> _refreshData() async {
    setState(() {
      _timecapsules = _fetchTimecapsules(); // 새 Future 할당하여 데이터 새로고침
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: Colors.black.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "타임캡슐 💊",
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
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 35,
                    ),
                    child: RefreshIndicator(
                      onRefresh: _refreshData,
                      child: FutureBuilder<TimecapsulesWithAnniResponse>(
                        future: _timecapsules,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.scaffoldBackgroundColor,
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
                          } else if (!snapshot.hasData ||
                              snapshot.data!.items.isEmpty) {
                            return const Center(
                              child: Text(
                                "생성된 타임캡슐이 없습니다",
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
                                        .withOpacity(0.95),
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor
                                          .withOpacity(0.95),
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                        currentTimecapsule.anniversary,
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
                ),

                // Expanded(
                //   child: ListView.builder(
                //     itemCount: 4,
                //     itemBuilder: (context, index) {
                //       return GestureDetector(
                //         onTap: () {
                //           // Navigator.of(context).push(
                //           //   MaterialPageRoute(
                //           //     builder: (context) =>
                //           //         TimeCapsuleDetailScreen(index: index),
                //           //   ),
                //           // );
                //           Navigator.of(context).push(
                //             createBluredBackgroundPage(
                //               screen: TimeCapsuleDetailScreen(index: index),
                //             ),
                //           );
                //         },
                //         child: Hero(
                //           tag: index,
                //           child: Material(
                //             type: MaterialType.transparency,
                //             child: Container(
                //               padding: const EdgeInsets.all(18),
                //               margin: const EdgeInsets.symmetric(
                //                   vertical: 8, horizontal: 16),
                //               decoration: BoxDecoration(
                //                 color: Colors.white,
                //                 borderRadius: BorderRadius.circular(10),
                //               ),
                //               child: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Text(
                //                     DateFormat.yMEd().format(DateTime.now()),
                //                     style: const TextStyle(
                //                       color: Colors.grey,
                //                       fontFamily: "Kyobo",
                //                       height: 1,
                //                     ),
                //                   ),
                //                   Text(
                //                     "편지 제목 $index",
                //                     style: const TextStyle(
                //                       fontFamily: "Kyobo",
                //                       fontSize: 24,
                //                       fontWeight: FontWeight.bold,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ),
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
