// 타임캡슐 페이지
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pico/common/utils/modals.dart';
import 'package:pico/memories/components/timecapsule/timecapsule_list_item.dart';
import 'package:pico/memories/view/time_capsule_detail_screen.dart';

class SentboxScreen extends StatelessWidget {
  const SentboxScreen({super.key});

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
                  child: SegmentedControlExample(),
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

Map<TimecapsuleType, String> timecapsuleDesc = <TimecapsuleType, String>{
  TimecapsuleType.opened: "열려 있는 타임캡슐",
  TimecapsuleType.upcoming: "잠겨 있는 타임캡슐",
};

class SegmentedControlExample extends StatefulWidget {
  const SegmentedControlExample({super.key});

  @override
  State<SegmentedControlExample> createState() =>
      _SegmentedControlExampleState();
}

class _SegmentedControlExampleState extends State<SegmentedControlExample> {
  TimecapsuleType _selectedSegment = TimecapsuleType.opened;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoSlidingSegmentedControl<TimecapsuleType>(
          backgroundColor: CupertinoColors.systemGrey2,
          // This represents the currently selected segmented control.
          groupValue: _selectedSegment,
          // Callback that sets the selected segmented control.
          onValueChanged: (TimecapsuleType? value) {
            if (value != null) {
              setState(() {
                _selectedSegment = value;
              });
            }
          },
          children: const <TimecapsuleType, Widget>{
            TimecapsuleType.opened: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'opened',
              ),
            ),
            TimecapsuleType.upcoming: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'upcoming',
              ),
            ),
          },
        ),
        Expanded(
          child: Center(
            child: Text(
              'Selected Segment: ${_selectedSegment.name} ${timecapsuleDesc[_selectedSegment]}',
            ),
          ),
        )
      ],
    );
  }
}
