import 'package:flutter/material.dart';
import 'package:pico/contants/urls.dart';

class TermsAndPolicy extends StatelessWidget {
  const TermsAndPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          "약관 및 정책",
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 5,
        ),
        children: [
          ListTile(
            onTap: () => Urls.onGoOnSite(Urls.termsOfserviceUrl),
            title: const Text(
              '서비스 이용 약관 및 \n개인정보 처리 방침',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(
              Icons.arrow_outward_rounded,
              size: 21,
            ),
          ),
          ListTile(
            onTap: () => Urls.onGoOnSite(Urls.marketingConsentUrl),
            title: const Text(
              '마케팅 활용 및 광고 수신',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(
              Icons.arrow_outward_rounded,
              size: 21,
            ),
          ),
          const ListTile(
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
