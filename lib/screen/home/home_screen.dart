import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('images/pico_logo.png', height: kToolbarHeight),
              const Spacer(),
              const Icon(
                Icons.notifications_rounded,
                size: 30,
              ),
            ],
          ),
          const Text("홈"),
        ],
      ),
    );
  }
}
