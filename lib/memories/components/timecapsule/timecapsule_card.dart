// 세부 페이지
import 'dart:ui';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lovendar/memories/components/timecapsule/timecapsule_back.dart';
import 'package:lovendar/memories/components/timecapsule/timecapsule_front.dart';
import 'package:lovendar/user/model/user_model.dart';
import 'package:lovendar/user/provider/user_provider.dart';

class TimecapsuleCard extends ConsumerWidget {
  final int index;
  const TimecapsuleCard({super.key, required this.index});
  static const ALPHA_VALUE = 76;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userProvider) as UserModel;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                color: Colors.black.withAlpha(ALPHA_VALUE),
              ),
            ),
          ),
          Center(
            child: FlipCard(
              fill: Fill
                  .fillBack, // Fill the back side of the card to make in the same size as the front.
              direction: FlipDirection.HORIZONTAL, // default
              side: CardSide.FRONT, // The side to initially display.
              front: Hero(
                tag: index,
                child: TimecapsuleFront(),
              ),
              // TODO : 실제 값 데이터에 맞게 수정
              back: TimecapsuleBack(
                scheduleTitle: "test",
                scheduleStartTime: DateTime.now(),
              ),
            ),
          ),
          // Center(
          //   child: Hero(
          //     tag: index,
          //     child: Material(
          //       type: MaterialType.transparency,
          //       child: Container(
          //         width: MediaQuery.of(context).size.width,
          //         height: MediaQuery.of(context).size.width * 1.2,
          //         padding: const EdgeInsets.all(18),
          //         margin:
          //             const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               DateFormat.yMEd().format(DateTime.now()),
          //               style: const TextStyle(color: Colors.grey),
          //             ),
          //             Text(
          //               "편지 제목 $index",
          //               style: const TextStyle(
          //                 fontSize: 24,
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
