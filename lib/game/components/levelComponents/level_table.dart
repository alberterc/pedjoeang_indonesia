import 'package:flutter/material.dart';
import 'package:flame/components.dart';

import '../../screen_game.dart';

class LevelTable extends PositionComponent with HasGameReference<ScreenGame> {
  Vector2 get tableBoxSize => boxSize;
  set tableBoxSize(Vector2 tableBoxSize) => boxSize = tableBoxSize;

  Vector2 boxSize = Vector2(20, 20);

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, boxSize.x, boxSize.y),
      Paint()..color = game.palette.backgroundSecondary.color
    );
  }
}