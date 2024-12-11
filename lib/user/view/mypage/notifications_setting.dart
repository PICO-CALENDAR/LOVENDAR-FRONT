import 'package:flutter/material.dart';

class NotificationsSetting extends StatelessWidget {
  const NotificationsSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          "알림 설정",
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 5,
        ),
        children: const [
          ListTile(
            title: Text(
              '오픈소스',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: Icon(
              Icons.chevron_right,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}
