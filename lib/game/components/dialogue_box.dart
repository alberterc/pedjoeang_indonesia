import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:jenny/jenny.dart';

import '../screen_game.dart';

class DialogueBox extends PositionComponent with HasGameReference<ScreenGame> {
  DialogueBox({this.line});

  DialogueLine? line;
  String characterName = '';
  String characterLine = '';
  late TextPaint characterNameTextPaint;
  late TextPaint characterLineTextPaint;
  TextBoxComponent characterNameTextComponent = TextBoxComponent();
  TextBoxComponent characterLineTextComponent = TextBoxComponent();

  late double characterLineBoxWidth;
  late double characterLineBoxHeight;
  late double characterNameBoxWidth;
  late double characterNameBoxHeight;

  @override
  FutureOr<void> onLoad() {
    characterLineBoxWidth = game.size.x - game.size.x * 0.2;
    characterLineBoxHeight = game.size.y - game.size.y * 0.7;
    characterNameBoxWidth = game.size.x * 0.3;
    characterNameBoxHeight = game.size.y * 0.09;
    
    characterNameTextPaint = TextPaint(
      style: TextStyle(
        fontSize: 16,
        color: game.palette.fontMain.color
      )
    );

    characterLineTextPaint = TextPaint(
      style: TextStyle(
        fontSize: 14,
        color: game.palette.fontMain.color
      )
    );

    characterNameTextComponent = TextBoxComponent(
      text: '',
      textRenderer: characterNameTextPaint,
      position: Vector2(0, 0),
      boxConfig: TextBoxConfig(
        margins: EdgeInsets.symmetric(vertical: characterNameBoxHeight / 5, horizontal: 16.0),
        maxWidth: characterNameBoxWidth - 32,
      )
    );

    characterLineTextComponent = TextBoxComponent(
      text: '',
      textRenderer: characterLineTextPaint,
      position: Vector2(0, game.size.y - game.size.y * 0.9),
      boxConfig: TextBoxConfig(
        margins: EdgeInsets.symmetric(vertical: characterLineBoxHeight / 8, horizontal: 16.0),
        maxWidth: characterLineBoxWidth - 32,
      )
    );

    addAll([characterNameTextComponent, characterLineTextComponent]);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (line != null) {
      characterName = line!.character?.name ?? '';
      characterLine = line!.text;

      characterNameTextComponent.text = characterName;
      characterLineTextComponent.text = characterLine;
    }
  }

  @override
  void render(Canvas canvas) {
    // character name box
    canvas.drawRect(
      Rect.fromLTWH(0, 0, characterNameBoxWidth, characterNameBoxHeight),
      Paint()..color = game.palette.backgroundSecondary.color.withOpacity(0.5)
    );

    // character line box
    canvas.drawRect(
      Rect.fromLTWH(0, game.size.y * 0.1, characterLineBoxWidth, characterLineBoxHeight),
      Paint()..color = game.palette.backgroundSecondary.color.withOpacity(0.5)
    );
  }
}