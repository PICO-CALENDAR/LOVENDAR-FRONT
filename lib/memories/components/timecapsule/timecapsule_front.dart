import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pico/memories/provider/timecapsule_form_provider.dart';
import 'package:pico/user/model/user_model.dart';
import 'package:pico/user/provider/user_provider.dart';

class TimecapsuleFront extends ConsumerWidget {
  const TimecapsuleFront({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userProvider) as UserModel;
    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 1.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "제목을 입력하세요",
              style: const TextStyle(
                fontSize: 24,
                fontFamily: "Kyobo",
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      DateFormat.yMEd().format(DateTime.now()),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontFamily: "Kyobo",
                        height: 1,
                      ),
                    ),
                    Text(
                      "기념일 종류",
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: "Kyobo",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 15,
                      // TODO: 실제 작성자 image로 바꾸기
                      backgroundImage: userInfo.partnerProfileImage != null
                          ? NetworkImage(
                              userInfo.partnerProfileImage!,
                            )
                          : AssetImage(
                              "images/basic_profile.png",
                            ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "From. ${userInfo.partnerName}",
                      style: const TextStyle(
                        fontFamily: "Kyobo",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
