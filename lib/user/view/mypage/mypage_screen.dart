import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico/common/contants/urls.dart';
import 'package:pico/user/model/user_model.dart';
import 'package:pico/user/provider/user_provider.dart';
import 'package:pico/user/view/mypage/notifications_setting.dart';
import 'package:pico/user/view/mypage/terms_and_policy.dart';

class MypageScreen extends ConsumerWidget {
  const MypageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userProvider) as UserModel;
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
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // User Info Section
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                // onTap: () => context.go("/mypage"),
                child: Profile(
                  profileImage: userInfo.profileImage,
                  nickName: userInfo.nickName,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () =>
                    userInfo.partnerId == null ? context.push("/invite") : null,
                child: Profile(
                  profileImage: userInfo.partnerProfileImage,
                  nickName: userInfo.partnerNickname,
                ),
              ),
            ),
          ],
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
        // const SizedBox(height: 23),
        // Customer Center Section
        const SectionTitle(title: '고객센터'),
        ListTile(
          onTap: () => Urls.onGoOnSite(Urls.noticeUrl),
          title: const Text(
            '공지사항',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_outward_rounded,
            size: 19,
          ),
        ),

        ListTile(
          onTap: () => Urls.onGoOnSite(Urls.contactUrl),
          title: const Text(
            '의견 보내기',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            size: 23,
          ),
        ),
        ListTile(
          onTap: () => Urls.onGoOnSite(Urls.faqUrl),
          title: const Text(
            '자주 묻는 질문',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_outward_rounded,
            size: 19,
          ),
        ),
        const SizedBox(height: 23),
        // Settings Section
        const SectionTitle(title: '설정'),
        const ListTile(
          title: Text(
            '앱 버전 v1.1.1',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('최신상태', style: TextStyle(color: Colors.green)),
              SizedBox(
                width: 8,
              ),
              Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 19,
              ),
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
          title: const Text(
            '알림 설정',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            size: 23,
          ),
        ),
        const SizedBox(height: 23),
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
          title: const Text(
            '약관 및 정책',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            size: 23,
          ),
        ),
        ListTile(
          onTap: () {
            ref.read(userProvider.notifier).logOut();
          },
          title: Text(
            '로그아웃',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
        ),
        ListTile(
          onTap: () {
            ref.read(userProvider.notifier).deleteAccount();

            // TODO: 이게 왜 안될까..
            context.go("/");
          },
          title: Text(
            '탈퇴하기',
            style: TextStyle(
              color: Colors.red[200],
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}

class Profile extends ConsumerWidget {
  final String? profileImage;
  final String? nickName;

  const Profile({
    super.key,
    this.profileImage,
    this.nickName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: profileImage != null
          ? BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            )
          : BoxDecoration(
              border: Border.all(
                color: Colors.grey[300]!,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
      child: Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: profileImage != null
                  ? NetworkImage(
                      profileImage!,
                    )
                  : AssetImage(
                      "images/profile_placeholder.png",
                    ), // Replace with actual image path
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 27,
              child: nickName != null
                  ? Text(
                      nickName!,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  : Text(
                      "커플 연결을\n 진행해주세요",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.5,
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
