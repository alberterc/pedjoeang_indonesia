import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Color invertColor(Color color) {
  return Color.fromARGB(
    color.alpha,
    255 - color.red,
    255 - color.green,
    255 - color.blue
  );
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
  'PigpenCipher',
  'SlidePuzzle',
  'PauseMenu' // has to be the last index
];