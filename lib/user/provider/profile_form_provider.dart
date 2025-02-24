// import 'package:flutter_riverpod/flutter_riverpod.dart';

// Notifier 클래스
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum EditButtonType {
  nickname,
  name,
  birth,
  none, // 아무 버튼도 눌리지 않았을 경우
}

final editButtonProvider = NotifierProvider<EditButtonNotifier, EditButtonType>(
  EditButtonNotifier.new,
);

class EditButtonNotifier extends Notifier<EditButtonType> {
  @override
  EditButtonType build() {
    return EditButtonType.none; // 초기 상태는 아무 버튼도 눌리지 않음
  }

  void selectButton(EditButtonType type) {
    state = type; // 버튼 선택 시 상태 업데이트
  }

  void clearSelection() {
    state = EditButtonType.none; // 선택 해제
  }
}
