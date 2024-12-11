import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InviteScreen extends StatelessWidget {
  const InviteScreen({super.key});
  static String get routeName => 'invite';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "커플 연결을 진행해주세요",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              context.go("/");
            },
          ),
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
