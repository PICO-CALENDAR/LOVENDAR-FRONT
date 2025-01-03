import 'package:url_launcher/url_launcher_string.dart';

class Urls {
  static const contactUrl = "https://open.kakao.com/o/sbp7PGZg";
  static const noticeUrl =
      "https://foggy-science-cab.notion.site/13c74a2c070c80a8925ce661d1181182";
  static const faqUrl =
      "https://foggy-science-cab.notion.site/13c74a2c070c808fad77d0b4c6f2d3c2";
  static const termsOfserviceUrl =
      "https://foggy-science-cab.notion.site/13c74a2c070c807992b7cceb303f47c5?pvs=4";
  static const marketingConsentUrl =
      "https://foggy-science-cab.notion.site/13c74a2c070c807a8366cd61961af833?pvs=4";

  static void onGoOnSite(String url) async {
    await launchUrlString(
      url,
      mode: LaunchMode.externalApplication,
    );
  }
}
