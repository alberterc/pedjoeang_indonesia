import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:image/image.dart' as img_lib;

Color invertColor(Color color) {
  return Color.fromARGB(
    color.alpha,
    255 - color.red,
    255 - color.green,
    255 - color.blue
  );
}

Future <List<Image>> splitImage(String path, int widthDivider, int heigthDivider) async {
  img_lib.Image? image = await decodeAsset(path);

  if (image != null) {
    List<Image> outputImageList = [];
    int x = 0, y = 0;
    int width = (image.width / widthDivider).floor();
    int height = (image.height / heigthDivider).floor();
    for (int i = 0; i < heigthDivider; i++) {
      for (int j = 0; j < widthDivider; j++) {
        img_lib.Image croppedImage = img_lib.copyCrop(image, x: x, y: y, width: width, height: height);
        outputImageList.add(Image.memory(img_lib.encodeJpg(croppedImage)));
        x += width;
      }
      x = 0;
      y += height;
    }

    return outputImageList;
  }
  return [];
}

Future<img_lib.Image?> decodeAsset(String path) async {
  final data = await rootBundle.load(path);
  final buffer = await ImmutableBuffer.fromUint8List(data.buffer.asUint8List());
  final id = await ImageDescriptor.encoded(buffer);
  final codec = await id.instantiateCodec(
    targetHeight: id.height,
    targetWidth: id.width
  );
  final fi = await codec.getNextFrame();
  final uiImage = fi.image;
  final uiBytes = await uiImage.toByteData();
  final image = img_lib.Image.fromBytes(width: id.width, height: id.height, bytes: uiBytes!.buffer, numChannels: 4);

  return image;
}

const String gameName = "Pedjoeang Indonesia";
const Map<String, int> renderPriority = {
  'ui': 10,
  'under_ui': 9,
  'foreground': 1,
  'background': 0
};
double characterSize = 320.sp;
double fontTiny = 8.sp;
double fontTinyLarge = 10.sp;
double fontSmall = 12.sp;
double fontSmallLarge = 14.sp;
double fontMedium = 16.sp;
double fontLarge = 32.sp;
double gridSize = 140.sp;
double cipherSize = 90.sp; //default 80.sp
double forceAspectRatio = 16 / 9;
Color backgroundColorPrimary = const Color(0xffefbf97);
Color backgroundColorSecondary = const Color(0xffD9D9D9);
Color fontColorMain = const Color.fromARGB(255, 0, 0, 0);
const flameOverlays = [
  'SlidePuzzle',
  'PigpenCipher',
  'GuessTheNumber',
  'ButtonOrder',
  'PauseMenu' // has to be the last index
];