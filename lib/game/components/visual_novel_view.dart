import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:jenny/jenny.dart';

import '../../constants/constants.dart' as constants;
import '../../widgets/screen_game.dart';
import 'visualNovelComponents/dialogue_box.dart';
import 'levels_view.dart';
import 'menuComponents/button.dart';

class VisualNovelView extends PositionComponent with DialogueView, HasGameReference<PIGame> {
  final renderPriority = constants.renderPriority;

  late final ButtonComponent forwardDialogueButton;
  Completer<void> _forwardCompleter = Completer();
  late final TextPaint dialoguePaint;
  final yuri = SpriteComponent();
  final miko = SpriteComponent();
  final background = SpriteComponent();
  late LevelView levelView;
  late Button skipButton;
  late Button historyButton;
  late Button autoButton;
  late Button menuButton;
  late DialogueBox dialogueBox;

  @override
  FutureOr<void> onLoad() async {
    skipButton = Button(
      text: 'Skip',
      showText: false,
      onTapUpEvent: (event, buttonName) {
        debugPrint('$buttonName button pressed');
      },
      color: game.palette.backgroundSecondary.color
    )
      ..priority = renderPriority['ui']!
      ..size = game.uiButtonSize
      ..position = Vector2(game.size.x * 0.02, game.size.y * 0.03);
    
    historyButton = Button(
      text: 'History',
      showText: false,
      onTapUpEvent: (event, buttonName) {
        debugPrint('$buttonName button pressed');
      },
      color: game.palette.backgroundSecondary.color
    )
      ..priority = renderPriority['ui']!
      ..size = game.uiButtonSize
      ..position = Vector2(skipButton.position.x + game.uiButtonSize.x + game.size.x * 0.02, game.size.y * 0.03);

    menuButton = Button(
      text: 'Menu',
      showText: false,
      onTapUpEvent: (event, buttonName) {
        game.overlays.add('PauseMenu');
      },
      color: game.palette.backgroundSecondary.color
    )
      ..priority = renderPriority['ui']!
      ..size = game.uiButtonSize
      ..position = Vector2(game.size.x - game.uiButtonSize.x - game.size.x * 0.02, game.size.y * 0.03);

    autoButton = Button(
      text: 'Auto',
      showText: false,
      onTapUpEvent: (event, buttonName) {
        debugPrint('$buttonName button pressed');
      },
      color: game.palette.backgroundSecondary.color
    )
      ..priority = renderPriority['ui']!
      ..size = game.uiButtonSize
      ..position = Vector2(menuButton.position.x - game.uiButtonSize.x - game.size.x * 0.02, game.size.y * 0.03);

    dialogueBox = DialogueBox()
      ..priority = renderPriority['ui']!
      ..position = Vector2(game.size.x * 0.1, game.size.y * 0.55);

    yuri
      ..sprite = game.yuriSprite
      ..position = Vector2(game.size.x * 0.75, game.size.y * 0.1)
      ..priority = renderPriority['foreground']!
      ..anchor = Anchor.topCenter
      ..size = Vector2(constants.characterSize, constants.characterSize);

    miko
      ..sprite = game.mikoSprite
      ..position = Vector2(game.size.x * 0.25, game.size.y * 0.1)
      ..priority = renderPriority['foreground']!
      ..anchor = Anchor.topCenter
      ..size = Vector2(constants.characterSize, constants.characterSize);

    background
      ..sprite = await game.loadSprite('background.png')
      ..priority = renderPriority['background']!
      ..size = game.size;

    forwardDialogueButton = ButtonComponent(
      button: PositionComponent(),
      priority: renderPriority['under_ui']!,
      size: game.size, 
      onPressed: () {
        if (!_forwardCompleter.isCompleted) {
          _forwardCompleter.complete();
        }
      }
    );
    
    addAll([background, miko, yuri, forwardDialogueButton, dialogueBox, skipButton, historyButton, autoButton, menuButton]);
    return super.onLoad();
  }

  @override
  FutureOr<bool> onLineStart(DialogueLine line) async {
    _forwardCompleter = Completer();
    await _advance(line);
    return super.onLineStart(line);
  }

  Future<void> _advance(DialogueLine line) {
    dialogueBox.line = line;
    return _forwardCompleter.future;
  }

  // @override
  // FutureOr<void> onDialogueFinish() {
  //   levelView = LevelView(puzzleCount: 4);
  //   removeAll([background, miko, yuri, forwardDialogueButton, dialogueBox, skipButton, historyButton, autoButton, menuButton]);
  //   add(levelView);

  //   return super.onDialogueFinish();
  // }
}