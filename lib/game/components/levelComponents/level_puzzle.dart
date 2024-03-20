import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flame/components.dart';

import '../../screen_game.dart';

class LevelPuzzle extends PositionComponent with HasGameReference<ScreenGame> {
  Vector2 get puzzleBoxSize => boxSize;
  set puzzleBoxSize(Vector2 puzzleBoxSize) => boxSize = puzzleBoxSize;

  Color get puzzleBoxColor => boxColor;
  set puzzleBoxColor(Color puzzleBoxColor) => boxColor = puzzleBoxColor;

  String get puzzleBoxText => boxText;
  set puzzleBoxText(String puzzleBoxText) => boxText = puzzleBoxText;

  Anchor get puzzleBoxAnchor => boxAnchor;
  set puzzleBoxAnchor(Anchor puzzleBoxAnchor) => boxAnchor = puzzleBoxAnchor;

  Vector2 boxSize = Vector2(20, 20);
  Color boxColor = const Color.fromARGB(255, 255, 255, 255);
  String boxText = '';
  Anchor boxAnchor = Anchor.topLeft;

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
      anchor: boxAnchor,
      align: Anchor.center,
      size: boxSize,
      boxConfig: TextBoxConfig(
        maxWidth: boxSize.x,
        margins: EdgeInsets.zero
      )
    );

    box = SpriteComponent(
      sprite: Sprite(
        game.images.fromCache('background.png')
      ),
      size: boxSize,
      paint: Paint()..color = boxColor,
      anchor: boxAnchor
    );

    addAll([box, text]);

    return super.onLoad();
  }

  // @override
  // void render(Canvas canvas) {
  //   canvas.drawRect(
  //     Rect.fromLTWH(0, 0, boxSize.x, boxSize.y),
  //     Paint()..color = boxColor
  //   );
  // }
}