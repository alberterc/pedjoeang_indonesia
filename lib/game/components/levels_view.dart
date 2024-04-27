import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart' as constants;
import '../../widgets/screen_game.dart';
import 'levelComponents/level_puzzle.dart';
import 'levelComponents/level_table.dart';
import 'levelComponents/main_puzzle_box.dart';

class LevelView extends PositionComponent with HasGameReference<PIGame> {
  LevelView({required this.puzzleCount, required this.puzzleTypes});

  final renderPriority = constants.renderPriority;

  int puzzleCount;
  late SpriteComponent background;
  late LevelTable levelTable;
  late MainPuzzleBox mainPuzzle;
  late List<String> puzzleTypes;
  late List<LevelPuzzle> puzzles;
  late SpriteButtonComponent mainPuzzleSubmitButton;
  late SpriteButtonComponent menuButton;
  late SpriteButtonComponent mainClueButton;

  @override
  FutureOr<void> onLoad() async {
    double tableLeft = game.size.x * 0.08;
    double tableTop = game.size.y * 0.05;
    double mainPuzzleLeft = game.size.x * 0.1;
    double mainPuzzleTop = game.size.y * 0.07;

    menuButton = SpriteButtonComponent()
      ..priority = renderPriority['ui']!
      ..button = game.menuIconSprite['dark']!
      ..buttonDown  = game.menuIconSprite['light']!
      ..size = game.uiButtonSize
      ..position = Vector2(game.size.x - game.uiButtonSize.x - game.size.x * 0.02, game.size.y * 0.03) 
      ..onPressed = () {
        game.overlays.add('PauseMenu');
      };

    background = SpriteComponent()
      ..sprite = game.bgSprite
      ..decorator = PaintDecorator.tint(const Color.fromARGB(28, 230, 201, 129))
      ..priority = renderPriority['background']!
      ..size = game.size;

    levelTable = LevelTable()
      ..priority = renderPriority['foreground']!
      ..sprite = game.tableSprite
      ..size = Vector2(game.size.x - (tableLeft * 2), game.size.y - (tableTop * 2))
      ..position = Vector2(tableLeft, tableTop);

    mainPuzzle =  MainPuzzleBox()
      ..priority = renderPriority['foreground']!
      ..puzzle = game.mainPuzzle
      ..size = Vector2(game.size.x - ((tableLeft + mainPuzzleLeft) * 2), game.size.y - ((tableTop + mainPuzzleTop) * 2))
      ..position = Vector2(tableLeft + mainPuzzleLeft, tableTop + mainPuzzleTop);

    mainClueButton = SpriteButtonComponent()
      ..priority = renderPriority['ui']!
      ..button = game.envelopeIconSprite['dark']!
      ..buttonDown = game.envelopeIconSprite['light']!
      ..anchor = Anchor.center
      ..size = game.uiButtonSize
      ..position = Vector2(mainPuzzle.x * 0.8, mainPuzzle.y + mainPuzzle.size.y / 2)
      ..onPressed = () {
        game.overlays.add('MainClue');
      };

    mainPuzzleSubmitButton = SpriteButtonComponent()
      ..priority = renderPriority['ui']!
      ..button = game.checkmarkIconSprite['dark']!
      ..buttonDown = game.checkmarkIconSprite['light']!
      ..anchor = Anchor.center
      ..size = game.uiButtonSize
      ..position = Vector2(game.size.x - mainPuzzle.x * 0.8, mainPuzzle.y + mainPuzzle.size.y / 2);

    puzzles = List.generate(puzzleCount, (index) => LevelPuzzle(
      onTapUpEvent: (event, buttonName) {
        game.overlays.add(puzzleTypes[index]);
      }
    )
      ..priority = renderPriority['foreground']!
      ..anchor = Anchor.center
    );

    List<Vector2> puzzlePositions = [
      Vector2(mainPuzzle.x, mainPuzzle.y * 2),
      Vector2(mainPuzzle.x + mainPuzzle.size.x, mainPuzzle.y * 2),
      Vector2(mainPuzzle.x, mainPuzzle.size.y),
      Vector2(mainPuzzle.x + mainPuzzle.size.x, mainPuzzle.size.y),
    ];
    for (int i = 0; i < puzzles.length; i++) {
      puzzles[i]
        ..position = puzzlePositions[i]
        ..size = Vector2(constants.cipherSize, constants.cipherSize)
        ..puzzleBoxColor = Color.fromARGB(255, (i * 50), (i * 50), 1 + 255)
        ..smallIcon = game.smallPuzzleIcon[i];
    }

    addAll([background, levelTable, mainPuzzle, mainPuzzleSubmitButton, mainClueButton, menuButton]);
    addAll(puzzles);

    return super.onLoad();
  }
}