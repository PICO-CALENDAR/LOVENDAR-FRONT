import 'package:flutter/material.dart';
import 'package:pico/contants/urls.dart';
import 'package:pico/screen/mypage/notifications_setting.dart';
import 'package:pico/screen/mypage/terms_and_policy.dart';

class MypageScreen extends StatelessWidget {
  const MypageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 5,
      ),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "마이페이지",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // User Info Section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(
                    'assets/avatar.png'), // Replace with actual image path
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '김피코',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'username@gmail.com',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Event Banner
        // Container(
        //   padding: const EdgeInsets.symmetric(vertical: 12),
        //   alignment: Alignment.center,
        //   decoration: BoxDecoration(
        //     color: Colors.brown[300], // Customize banner color
        //     borderRadius: BorderRadius.circular(8),
        //   ),
        //   child: const Text(
        //     '이벤트 및 광고 배너',
        //     style: TextStyle(color: Colors.white),
        //   ),
        // ),
        // const SizedBox(height: 24),
        // Customer Center Section
        const SectionTitle(title: '고객센터'),
        ListTile(
          onTap: () => Urls.onGoOnSite(Urls.noticeUrl),
          title: const Text(
            '공지사항',
          ),
          trailing: const Icon(
            Icons.arrow_outward_rounded,
            size: 21,
          ),
        ),

        ListTile(
          onTap: () => Urls.onGoOnSite(Urls.contactUrl),
          title: const Text(
            '의견 보내기',
          ),
          trailing: const Icon(
            Icons.chevron_right,
            size: 25,
          ),
        ),
        ListTile(
          onTap: () => Urls.onGoOnSite(Urls.faqUrl),
          title: const Text(
            '자주 묻는 질문',
          ),
          trailing: const Icon(
            Icons.arrow_outward_rounded,
            size: 21,
          ),
        ),
        const SizedBox(height: 24),
        // Settings Section
        const SectionTitle(title: '설정'),
        const ListTile(
          title: Text('앱 버전 v1.1.1'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('최신상태', style: TextStyle(color: Colors.green)),
              Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationsSetting(),
              ),
            );
          },
          title: const Text('알림 설정'),
          trailing: const Icon(
            Icons.chevron_right,
            size: 25,
          ),
        ),
        const SizedBox(height: 24),
        // Account Section
        const SectionTitle(title: '계정'),
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TermsAndPolicy(),
              ),
            );
          },
          title: const Text('약관 및 정책'),
          trailing: const Icon(
            Icons.chevron_right,
            size: 25,
          ),
        ),
        const ListTile(
          title: Text(
            '로그아웃',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        ListTile(
          title: Text(
            '탈퇴하기',
            style: TextStyle(color: Colors.red[200]),
          ),
        ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
