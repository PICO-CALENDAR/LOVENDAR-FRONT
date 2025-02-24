import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageController {
  final ImagePicker _picker = ImagePicker();

  Future<bool> requestPermission() async {
    bool storage = await Permission.storage.request().isGranted;
    bool camera = await Permission.camera.request().isGranted;

    if (await Permission.storage.request().isDenied ||
        await Permission.camera.request().isDenied) {
      return false;
    }
    return true;
  }

  Future<CroppedFile?> takePhoto({double ratio = 1}) async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      image = await compressImage(image.path);
    }

    if (image != null) {
      final croppedImg = await cropImage(imagePath: image.path, ratio: ratio);
      return croppedImg;
    }
    return null;
  }

  Future<XFile?> pickImageFromGallery({double ratio = 1}) async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final croppedImg = await cropImage(imagePath: image.path, ratio: ratio);
      if (croppedImg != null) {
        return await compressImage(image.path);
      }
    }

    return null;
  }

  Future<CroppedFile?> cropImage(
      {required String imagePath, required double ratio}) async {
    return await ImageCropper().cropImage(
      sourcePath: imagePath,
      // 사진은 1:1비율로 가공
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: ratio),
    );
  }

  Future<XFile?> compressImage(String imagePath) async {
    try {
      final String outputPath =
          imagePath.replaceAll('.jpg', '_compressed.jpeg');
      return await FlutterImageCompress.compressAndGetFile(
        imagePath, // 수정 할 파일 경로
        outputPath, // 수정 후 저장할 경로
        format: CompressFormat.jpeg, // 포맷, 용량이 적은 webp로 일단 지정
        quality: 40, // 라이브러리 샘플에 나온 퀄리티가 88, 자신에게 맞게 사용
      );
    } catch (e) {
      // 오류 처리
      print(e);
      return null;
    }
  }
}
