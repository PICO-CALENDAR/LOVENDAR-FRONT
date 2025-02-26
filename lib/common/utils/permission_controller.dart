import 'package:permission_handler/permission_handler.dart';

class PermissionController {
  /// Singleton 패턴으로 인스턴스 관리 (선택 사항)
  static final PermissionController _instance =
      PermissionController._internal();

  factory PermissionController() => _instance;

  PermissionController._internal();

  /// 카메라 및 사진 라이브러리 권한 요청 메소드
  Future<void> requestPermissions() async {
    await requestCameraPermission();
    await requestPhotosPermission();
  }

  /// ✅ 카메라 권한 요청 메소드
  Future<void> requestCameraPermission() async {
    var cameraStatus = await Permission.camera.status;

    if (cameraStatus.isDenied) {
      cameraStatus = await Permission.camera.request();

      if (cameraStatus.isPermanentlyDenied) {
        await openAppSettings();
      }
    }
  }

  /// ✅ 사진 라이브러리 권한 요청 메소드
  Future<void> requestPhotosPermission() async {
    var photosStatus = await Permission.photos.status;

    if (photosStatus.isDenied) {
      photosStatus = await Permission.photos.request();
      print("photosStatus: ${photosStatus.toString()}");

      if (photosStatus.isPermanentlyDenied) {
        await openAppSettings();
      }
    }
  }

  /// ✅ 사진 라이브러리 권한 요청 메소드
  Future<void> requestStoragePermission() async {
    var storageStatus = await Permission.storage.status;

    if (storageStatus.isDenied) {
      storageStatus = await Permission.storage.request();
      print("photosStatus: ${storageStatus.toString()}");

      if (storageStatus.isPermanentlyDenied) {
        await openAppSettings();
      }
    }
  }
}
