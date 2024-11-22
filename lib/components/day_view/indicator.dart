import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      decoration: const BoxDecoration(
        color: Colors.red,
        // border: Border.all(),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -3.5,
            top: -3.5,
            child: Container(
              width: 9,
              height: 9,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
    // return Row(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     const SizedBox(width: 80),
    //     Container(
    //       width: 8,
    //       height: 8,
    //       decoration: const BoxDecoration(
    //         color: Colors.red,
    //         shape: BoxShape.circle,
    //       ),
    //     ),
    //     Expanded(
    //       child: Container(
    //         height: 2,
    //         decoration: const BoxDecoration(
    //           color: Colors.red,
    //           // border: Border.all(),
    //         ),
    //       ),
    //     ),
    //   ],
    // );

    return Row(
      children: [
        const SizedBox(width: 80),
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
