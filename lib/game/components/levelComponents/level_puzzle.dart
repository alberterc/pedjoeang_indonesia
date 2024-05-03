import 'dart:async';

import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

import '../../../screens/screen_game.dart';
import '../../../constants/constants.dart' as constants;

class LevelPuzzle extends PositionComponent with HasGameReference<PIGame>, TapCallbacks, Snapshot {
  LevelPuzzle({
    required this.onTapUpEvent
  });

  final String _boxText = '';
  final Function(TapUpEvent) onTapUpEvent;
  late Sprite smallIcon;
  
  @override
  FutureOr<void> onLoad() {
    final textPaint = TextPaint(
      style: TextStyle(
        fontSize: constants.fontSmall,
        color: constants.fontColorMain,
        fontFamily: 'Pixeloid'
      )
    );

    final text = TextBoxComponent(
      text: _boxText,
      textRenderer: textPaint,
      align: Anchor.center,
      size: size,
      boxConfig: TextBoxConfig(
        maxWidth: size.x,
        margins: EdgeInsets.zero
      )
    );

    final icon = SpriteComponent(
      sprite: smallIcon,
      position: Vector2(size.x / 2, size.y / 2),
      anchor: Anchor.center,
      size: smallIcon.srcSize * 1.25
    );

    final background = SpriteComponent(
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
    onTapUpEvent(event);
  }
}