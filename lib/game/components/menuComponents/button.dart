import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../../../widgets/screen_game.dart';
import '../../../constants/constants.dart' as constants;

class Button extends PositionComponent with HasGameReference<PIGame>, TapCallbacks {
  Button({
    required this.text, 
    required this.onTapUpEvent,
    required this.showBorder,
    TextPaint? textPaint,
    double? padding,
    this.showText = true,
    this.showIcon = false,
    this.color = Colors.white
  }) : textPaint = textPaint ?? TextPaint(
    style: TextStyle(
      fontSize: constants.fontSmall,
      color: Colors.black,
      fontFamily: 'Pixeloid'
    )
  ), padding = padding ?? 0;

  set iconSprite(Sprite iconSprite) => icon = iconSprite;

  final Function(TapUpEvent, String) onTapUpEvent;
  String text = '';
  final bool showBorder; 
  final bool showText;
  final bool showIcon;
  final Color color;
  TextPaint textPaint;
  late double padding;
  late Sprite icon;
  late Color borderColor;
  late double borderWidth;

  late TextBoxComponent textComponent;
  late SpriteComponent iconComponent;
  
  @override
  FutureOr<void> onLoad() {
    if (showText) {
      textComponent = TextBoxComponent(
        text: text,
        textRenderer: textPaint,
        size: size,
        align: Anchor.center,
        boxConfig: TextBoxConfig(
          maxWidth: size.x,
          margins: EdgeInsets.zero
        )
      );

      add(textComponent);
    }
    else if (showIcon) {
      iconComponent = SpriteComponent(
        sprite: icon,
        position: Vector2(size.x / 2, size.y / 2),
        anchor: Anchor.center,
        size: size / 1.7
      );
      add(iconComponent);
    }

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (showBorder) {
      canvas.drawRect(
        Rect.fromLTWH(padding, padding, size.x - (padding * 2), size.y - (padding * 2)),
        Paint()..color = borderColor
      );
      canvas.drawRect(
        Rect.fromLTWH(padding + borderWidth, padding + borderWidth, size.x - (padding * 2) - (borderWidth * 2), size.y - (padding * 2) - (borderWidth * 2)),
        Paint()..color = color
      );
    }
    else {
      canvas.drawRect(
        Rect.fromLTWH(padding, padding, size.x - (padding * 2), size.y - (padding * 2)),
        Paint()..color = color
      );
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    onTapUpEvent(event, text);
  }
}