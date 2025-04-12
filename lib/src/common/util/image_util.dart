import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageHelper {
  static Future<XFile> getXFileFromAsset(String assetPath) async {
    ByteData byteData = await rootBundle.load(assetPath);
    List<int> bytes = byteData.buffer.asUint8List();

    Directory tempDir = await getTemporaryDirectory();
    File tempFile = File('${tempDir.path}/temp_image.png');

    await tempFile.writeAsBytes(bytes);
    return XFile(tempFile.path);
  }

  static Future<Uint8List> pathToUINT8List(String path) async {
    File file = File(path);
    final compressedImage = await compressImage(file);
    Uint8List bytes = await compressedImage!.readAsBytes();
    return bytes;
  }

  static Future<File?> compressImage(File file) async {
    final decodedImage = await decodeImageFromList(file.readAsBytesSync());
    int originalWidth = decodedImage.width;
    int originalHeight = decodedImage.height;

    if (originalWidth <= 256) {
      return file;
    }

    double aspectRatio = originalHeight / originalWidth;
    int newWidth = 256;
    int newHeight = (256 * aspectRatio).round();

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      '${file.path}_compressed.jpg',
      quality: 85,
      minWidth: newWidth,
      minHeight: newHeight,
    );

    return result != null ? File(result.path) : null;
  }

  static File getImageFromFile(XFile image) {
    return File(image.path);
  }
}
