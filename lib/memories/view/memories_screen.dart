import 'package:flutter/cupertino.dart';

class MemoriesScreen extends StatelessWidget {
  static String get routeName => 'memories';
  const MemoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Image.asset(
        "images/new_page.png",
        fit: BoxFit.cover, // 화면에 꽉 차도록 설정
      ),
    );
    // return Column(
    //   children: [
    //     Padding(
    //       padding: EdgeInsets.symmetric(horizontal: 25),
    //       child: Row(
    //         children: [
    //           Image.asset(
    //             'images/lovendar_logo.png',
    //             height: 20,
    //           ),
    //           SizedBox(
    //             width: 4,
    //           ),
    //           Text(
    //             "추억함",
    //             style: TextStyle(
    //               fontSize: 23,
    //               fontWeight: FontWeight.bold,
    //               letterSpacing: 0,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }
}
