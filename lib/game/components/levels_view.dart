import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';

import '../../constants/constants.dart' as constants;
import '../../screens/screen_game.dart';
import 'levelComponents/level_puzzle.dart';
import 'levelComponents/level_table.dart';
import 'levelComponents/main_puzzle_box.dart';

class LevelView extends PositionComponent with HasGameReference<PIGame> {
  LevelView({required this.puzzleCount, required this.puzzleTypes});

  final renderPriority = constants.renderPriority;
  final int puzzleCount;
  final List<String> puzzleTypes;

  @override
  FutureOr<void> onLoad() async {
    double tableLeft = game.size.x * 0.08;
    double tableTop = game.size.y * 0.05;
    double mainPuzzleLeft = game.size.x * 0.1;
    double mainPuzzleTop = game.size.y * 0.07;

    // load audio files to cache into memory
    await FlameAudio.audioCache.loadAll([
      'answer_correct.mp3',
      'answer_wrong.mp3',
      'button_click.mp3'
    ]);

    final menuButton = SpriteButtonComponent()
      ..priority = renderPriority['ui']!
      ..button = game.menuIconSprite['dark']!
      ..buttonDown  = game.menuIconSprite['light']!
      ..size = game.uiButtonSize
      ..position = Vector2(game.size.x - game.uiButtonSize.x - game.size.x * 0.02, game.size.y * 0.03) 
      ..onPressed = () {
        FlameAudio.play('button_click.mp3');
        game.overlays.add('PauseMenu');
      };

    final background = SpriteComponent()
      ..sprite = game.bgSprite
      ..priority = renderPriority['background']!
      ..size = game.size;

    final levelTable = LevelTable()
      ..priority = renderPriority['foreground']!
      ..sprite = game.tableSprite
      ..size = Vector2(game.size.x - (tableLeft * 2), game.size.y - (tableTop * 2))
      ..position = Vector2(tableLeft, tableTop);

    final mainPuzzleBox =  MainPuzzleBox()
      ..priority = renderPriority['foreground']!
      ..puzzle = game.mainPuzzle
      ..size = Vector2(game.size.x - ((tableLeft + mainPuzzleLeft) * 2), game.size.y - ((tableTop + mainPuzzleTop) * 2))
      ..position = Vector2(tableLeft + mainPuzzleLeft, tableTop + mainPuzzleTop);

    final mainClueButton = SpriteButtonComponent()
      ..priority = renderPriority['ui']!
      ..button = game.envelopeIconSprite['dark']!
      ..buttonDown = game.envelopeIconSprite['light']!
      ..anchor = Anchor.center
      ..size = game.uiButtonSize
      ..position = Vector2(mainPuzzleBox.x * 0.8, mainPuzzleBox.y + mainPuzzleBox.size.y / 2)
      ..onPressed = () {
        FlameAudio.play('page_turn.mp3');
        game.overlays.add('MainClue');
      };

    final mainPuzzleSubmitButton = SpriteButtonComponent()
      ..priority = renderPriority['ui']!
      ..button = game.checkmarkIconSprite['dark']!
      ..buttonDown = game.checkmarkIconSprite['light']!
      ..anchor = Anchor.center
      ..size = game.uiButtonSize
      ..position = Vector2(game.size.x - mainPuzzleBox.x * 0.8, mainPuzzleBox.y + mainPuzzleBox.size.y / 2)
      ..onPressed = () {
        game.overlays.add('MainCorrectAnswer');
      };

    final levelPuzzles = List.generate(puzzleCount, (index) => LevelPuzzle(
      onTapUpEvent: (_) {
        FlameAudio.play('page_turn.mp3');
        game.overlays.add(puzzleTypes[index]);
      }
    )
      ..priority = renderPriority['foreground']!
      ..anchor = Anchor.center
    );

    List<Vector2> puzzlePositions = [
      Vector2(mainPuzzleBox.x, mainPuzzleBox.y * 2),
      Vector2(mainPuzzleBox.x + mainPuzzleBox.size.x, mainPuzzleBox.y * 2),
      Vector2(mainPuzzleBox.x, mainPuzzleBox.size.y),
      Vector2(mainPuzzleBox.x + mainPuzzleBox.size.x, mainPuzzleBox.size.y),
    ];
    for (int i = 0; i < levelPuzzles.length; i++) {
      levelPuzzles[i]
        ..position = puzzlePositions[i]
        ..size = Vector2(constants.cipherSize, constants.cipherSize)
        ..smallIcon = game.smallPuzzleIcon[i];
    }

    addAll([background, levelTable, mainPuzzleBox, mainPuzzleSubmitButton, mainClueButton, menuButton]);
    addAll(levelPuzzles);

    return super.onLoad();
  }
}