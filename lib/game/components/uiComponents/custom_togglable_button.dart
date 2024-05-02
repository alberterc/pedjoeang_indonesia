import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../../../screens/screen_game.dart';
import '../../../constants/constants.dart' as constants;

class CustomTogglableButton extends PositionComponent with HasGameReference<PIGame>, TapCallbacks {
  CustomTogglableButton({
    required this.text, 
    required this.onTapUpEvent,
    TextPaint? textPaint,
    Color? color,
    Color? selectedColor,
    Color? borderColor,
    Color? selectedBorderColor,
    double? padding,
    double? borderWidth,
    bool? showText,
    bool? showBorder,
    bool? showIcon
  }) : _textPaint = textPaint ?? TextPaint(
    style: TextStyle(
      fontSize: constants.fontSmall,
      color: Colors.black,
      fontFamily: 'Pixeloid'
    )
  ), _padding = padding ?? 0,
    _color = color ?? Colors.white,
    _selectedColor = selectedColor ?? Colors.black,
    _borderColor = borderColor ?? Colors.black,
    _selectedBorderColor = selectedBorderColor ?? Colors.white,
    _borderWidth = borderWidth ?? 1.0,
    _showText = showText ?? false,
    _showBorder = showBorder ?? false,
    _showIcon = showIcon ?? false;


  late Sprite icon;
  set iconSprite(Sprite iconSprite) => icon = iconSprite;
  
  final Function(TapUpEvent, String, bool) onTapUpEvent;
  final String text;
  final bool _showText;
  final bool _showBorder; 
  final bool _showIcon;
  final TextPaint _textPaint;
  final double _padding;
  final Color _color;
  final Color _selectedColor;
  final Color _borderColor;
  final Color _selectedBorderColor;
  final double _borderWidth;
  final _bgPaint = Paint();
  final _borderPaint = Paint();

  bool _isSelected = false;
  
  late TextBoxComponent textComponent;
  late SpriteComponent iconComponent;

  @override
  FutureOr<void> onLoad() {
    if (_showText) {
      textComponent = TextBoxComponent(
        text: text,
        textRenderer: _textPaint,
        size: size,
        align: Anchor.center,
        boxConfig: TextBoxConfig(
          maxWidth: size.x,
          margins: EdgeInsets.zero
        )
      );
      add(textComponent);
    }
    else if (_showIcon) {
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
    
    if (_isSelected) {
      _bgPaint.color = _selectedColor;
      _borderPaint.color = _selectedBorderColor;
    }
    else {
      _bgPaint.color = _color;
      _borderPaint.color = _borderColor;
    }

    if (_showBorder) {
      canvas.drawRect(
        Rect.fromLTWH(_padding, _padding, size.x - (_padding * 2), size.y - (_padding * 2)),
        _borderPaint
      );
      canvas.drawRect(
        Rect.fromLTWH(_padding + _borderWidth, _padding + _borderWidth, size.x - (_padding * 2) - (_borderWidth * 2), size.y - (_padding * 2) - (_borderWidth * 2)),
        _bgPaint
      );
    }
    else {
      canvas.drawRect(
        Rect.fromLTWH(_padding, _padding, size.x - (_padding * 2), size.y - (_padding * 2)),
        _bgPaint
      );
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    _isSelected = !_isSelected;
    onTapUpEvent(event, text, _isSelected);
  }
}