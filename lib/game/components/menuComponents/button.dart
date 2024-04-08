import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../../screen_game.dart';

class Button extends PositionComponent with HasGameReference<ScreenGame>, TapCallbacks {
  Button({
    required this.text, 
    required this.onTapUpEvent, 
    this.showText = true,
    this.color = Colors.white
  });  
  final Function(TapUpEvent, String) onTapUpEvent;

  String text = '';
  bool showText;
  Color color;

  late TextBoxComponent textComponent;

  @override
  FutureOr<void> onLoad() {
    if (showText) {
      textComponent = TextBoxComponent(
        text: text,
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black
          )
        ),
        size: size,
        align: Anchor.center,
        boxConfig: TextBoxConfig(
          maxWidth: size.x,
          margins: EdgeInsets.zero
        )
      );

      add(textComponent);
    }

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = color
    );
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    onTapUpEvent(event, text);
  }
}