import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';

import '../../screen_game.dart';

class HistoryButton extends PositionComponent with HasGameReference<ScreenGame> {
  late final ButtonComponent button;

  @override
  bool get debugMode => true;
  
  @override
  FutureOr<void> onLoad() {
    button = ButtonComponent(
      button: PositionComponent(),
      size: game.uiButtonSize, 
      onPressed: () {
        print('history button pressed');
      }
    );

    add(button);
    
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, game.uiButtonSize.x, game.uiButtonSize.y),
      Paint()..color = game.palette.backgroundSecondary.color
    );
  }
}