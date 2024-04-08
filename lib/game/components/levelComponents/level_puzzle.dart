import 'dart:async';

import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

import '../../screen_game.dart';

class LevelPuzzle extends PositionComponent with HasGameReference<ScreenGame>, TapCallbacks {
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
  late SpriteComponent box;
  
  @override
  FutureOr<void> onLoad() {
    textPaint = TextPaint(
      style: const TextStyle(
        fontSize: 16,
        // color: game.palette.fontMain.color
        color: Colors.white
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

    // box = SpriteComponent(
    //   sprite: Sprite(
    //     game.images.fromCache('background.png')
    //   ),
    //   size: size,
    //   paint: Paint()..color = boxColor
    // );

    addAll([
      // box,
      text
    ]);

    return super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    onTapUpEvent(event, boxText);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = boxColor
    );
  }
}