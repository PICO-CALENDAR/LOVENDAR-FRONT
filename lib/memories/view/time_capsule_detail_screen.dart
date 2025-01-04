// 세부 페이지
import 'dart:ui';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pico/user/model/user_model.dart';
import 'package:pico/user/provider/user_provider.dart';

class TimeCapsuleDetailScreen extends ConsumerWidget {
  final int index;
  const TimeCapsuleDetailScreen({super.key, required this.index});

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
                color: Colors.black.withOpacity(0.3),
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
                child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 1.2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "제목 $index",
                          style: const TextStyle(
                            fontSize: 24,
                            fontFamily: "Kyobo",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  DateFormat.yMEd().format(DateTime.now()),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "Kyobo",
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  "기념일 종류 $index",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: "Kyobo",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundImage: NetworkImage(
                                    userInfo.partnerProfileImage!,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "From. ${userInfo.partnerName}",
                                  style: const TextStyle(
                                    fontFamily: "Kyobo",
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              back: Container(
                padding: const EdgeInsets.all(18),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 1.2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${DateFormat.yMEd().format(DateTime.now())} 기념일 종류",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(
                      "편지 제목 $index",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
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
