import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:jenny/jenny.dart';

import '../screen_game.dart';
import '../utils/utils.dart';
import 'visualNovelComponents/dialogue_box.dart';
import 'menuComponents/menu_button.dart';
import 'menuComponents/auto_button.dart';
import 'menuComponents/history_button.dart';
import 'menuComponents/skip_button.dart';

class VisualNovelView extends PositionComponent with DialogueView, HasGameReference<ScreenGame> {
  final renderPriority = GameUtils.renderPriority;

  late final ButtonComponent forwardDialogueButton;
  Completer<void> _forwardCompleter = Completer();
  late final TextPaint dialoguePaint;
  final yuri = SpriteComponent();
  final miko = SpriteComponent();
  final background = SpriteComponent();
  late SkipButton skipButton;
  late HistoryButton historyButton;
  late AutoButton autoButton;
  late MenuButton menuButton;
  late DialogueBox dialogueBox;

  @override
  FutureOr<void> onLoad() async {
    skipButton = SkipButton()
      ..priority = renderPriority['ui']!
      ..position = Vector2(game.size.x * 0.02, game.size.y * 0.03);
    
    historyButton = HistoryButton()
      ..priority = renderPriority['ui']!
      ..position = Vector2(skipButton.position.x + game.uiButtonSize.x + game.size.x * 0.02, game.size.y * 0.03);

    menuButton = MenuButton()
      ..priority = renderPriority['ui']!
      ..position = Vector2(game.size.x - game.uiButtonSize.x - game.size.x * 0.02, game.size.y * 0.03);

    autoButton = AutoButton()
      ..priority = renderPriority['ui']!
      ..position = Vector2(menuButton.position.x - game.uiButtonSize.x - game.size.x * 0.02, game.size.y * 0.03);

    dialogueBox = DialogueBox()
      ..priority = renderPriority['ui']!
      ..position = Vector2(game.size.x * 0.1, game.size.y * 0.55);

    yuri
      ..sprite = game.yuriSprite
      ..position = Vector2(game.size.x * 0.75, game.size.y * 0.1)
      ..priority = renderPriority['foreground']!
      ..anchor = Anchor.topCenter
      ..size = Vector2(GameUtils.characterSize, GameUtils.characterSize);

    miko
      ..sprite = game.mikoSprite
      ..position = Vector2(game.size.x * 0.25, game.size.y * 0.1)
      ..priority = renderPriority['foreground']!
      ..anchor = Anchor.topCenter
      ..size = Vector2(GameUtils.characterSize, GameUtils.characterSize);

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

  Future<void> _advance(DialogueLine line) async {
    dialogueBox.line = line;
    // print(line);

    return _forwardCompleter.future;
  }
}