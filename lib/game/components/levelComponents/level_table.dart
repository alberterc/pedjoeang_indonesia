import 'package:flutter/material.dart';
import 'package:flame/components.dart';

import '../../../widgets/screen_game.dart';

class LevelTable extends PositionComponent with HasGameReference<ScreenGame> {
  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = game.palette.backgroundSecondary.color
    );
  }
}