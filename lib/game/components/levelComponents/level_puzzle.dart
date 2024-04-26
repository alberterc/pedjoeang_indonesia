import 'dart:async';

import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

import '../../../widgets/screen_game.dart';
import '../../../constants/constants.dart' as constants;

class LevelPuzzle extends PositionComponent with HasGameReference<PIGame>, TapCallbacks {
  LevelPuzzle({
    required this.onTapUpEvent
  });

  Color get puzzleBoxColor => boxColor;
  set puzzleBoxColor(Color puzzleBoxColor) => boxColor = puzzleBoxColor;

  String get puzzleBoxText => boxText;
  set puzzleBoxText(String puzzleBoxText) => boxText = puzzleBoxText;

  Color boxColor = const Color.fromARGB(255, 255, 255, 255);
  String boxText = '';
  final Function(TapUpEvent, String) onTapUpEvent;
  late TextBoxComponent text;
  late TextPaint textPaint;
  late SpriteComponent background;
  late SpriteComponent icon;
  late Sprite smallIcon;
  
  @override
  FutureOr<void> onLoad() {
    textPaint = TextPaint(
      style: TextStyle(
        fontSize: constants.fontSmall,
        color: constants.fontColorMain,
        fontFamily: 'Pixeloid'
      )
    );

    text = TextBoxComponent(
      text: boxText,
      textRenderer: textPaint,
      align: Anchor.center,
      size: size,
      boxConfig: TextBoxConfig(
        maxWidth: size.x,
        margins: EdgeInsets.zero
      )
    );

    icon = SpriteComponent(
      sprite: smallIcon,
      position: Vector2(size.x / 2, size.y / 2),
      anchor: Anchor.center,
      size: smallIcon.srcSize * 1.25
    );

    background = SpriteComponent(
      sprite: game.smallPuzzleBgSprite,
      size: size
    );

    addAll([
      background,
      icon,
      text
    ]);

    return super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    onTapUpEvent(event, boxText);
  }
}