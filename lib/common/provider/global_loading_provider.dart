// loading 상태를 관리하는 StateNotifier
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider 선언
final globalLoadingProvider =
    StateNotifierProvider<LoadingNotifier, bool>((ref) {
  return LoadingNotifier();
});

class LoadingNotifier extends StateNotifier<bool> {
  LoadingNotifier() : super(false);

  void setLoading(bool value) => state = value;
  void startLoading() => state = true;
  void stopLoading() => state = false;
}
