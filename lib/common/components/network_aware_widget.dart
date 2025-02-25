import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkAwareWidget extends StatefulWidget {
  final Widget child;

  const NetworkAwareWidget({
    super.key,
    required this.child,
  });

  @override
  State createState() => _NetworkAwareWidgetState();
}

class _NetworkAwareWidgetState extends State<NetworkAwareWidget> {
  late StreamSubscription<InternetStatus> _listener;
  bool _isDialogShown = false;

  @override
  void initState() {
    super.initState();
    _listener = InternetConnection().onStatusChange.listen((status) {
      if (status == InternetStatus.disconnected && !_isDialogShown) {
        _isDialogShown = true;
        _showNetworkAlertDialog();
      } else if (status == InternetStatus.connected && _isDialogShown) {
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        _isDialogShown = false;
      }
    });
  }

  void _showNetworkAlertDialog() {
    showCupertinoDialog(
      context: Navigator.of(context, rootNavigator: true).context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("인터넷 연결 필요"),
          content: const Text("인터넷에 연결되지 않았습니다.\nWi-Fi 또는 모바일 데이터를 켜주세요."),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () =>
                  AppSettings.openAppSettings(type: AppSettingsType.wifi),
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _listener.cancel(); // 리스너 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
