import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../screen_game.dart';
import '../utils/utils.dart';
import 'levelComponents/level_puzzle.dart';
import 'levelComponents/level_table.dart';
import 'menuComponents/menu_button.dart';

class LevelView extends PositionComponent with HasGameReference<ScreenGame> {
  LevelView({required this.puzzleCount});

  final renderPriority = GameUtils.renderPriority; 

  int puzzleCount;
  late SpriteComponent background;
  late LevelTable levelTable;
  late LevelPuzzle basePuzzle;
  late List<LevelPuzzle> puzzles;
  late MenuButton menuButton;

  @override
  FutureOr<void> onLoad() async {
    double tableLeft = game.size.x * 0.08;
    double tableTop = game.size.y * 0.05;
    double basePuzzleLeft = game.size.x * 0.15;
    double basePuzzleTop = game.size.y * 0.2;

    menuButton = MenuButton()
      ..priority = renderPriority['ui']!
      ..position = Vector2(game.size.x - game.uiButtonSize.x - game.size.x * 0.02, game.size.y * 0.03);

    background = SpriteComponent()
      ..sprite = await game.loadSprite('background.png')
      ..priority = renderPriority['background']!
      ..size = game.size;

    levelTable = LevelTable()
      ..priority = renderPriority['foreground']!
      ..tableBoxSize = Vector2(game.size.x - (tableLeft * 2), game.size.y - (tableTop * 2))
      ..position = Vector2(tableLeft, tableTop);

    basePuzzle = LevelPuzzle()
      ..priority = renderPriority['foreground']!
      ..puzzleBoxSize = Vector2(game.size.x - ((tableLeft + basePuzzleLeft) * 2), game.size.y - ((tableTop + basePuzzleTop) * 2))
      ..puzzleBoxColor = const Color.fromARGB(255, 70, 70, 70)
      ..puzzleBoxText = 'Puzzle 1'
      ..puzzleBoxAnchor = Anchor.topLeft
      ..position = Vector2(tableLeft + basePuzzleLeft, tableTop + basePuzzleTop);

    puzzles = List.generate(puzzleCount - 1, (index) => LevelPuzzle()
      ..priority = renderPriority['foreground']!
      ..puzzleBoxAnchor = Anchor.center
    );

    List<Vector2> puzzlePositions = [
      Vector2(basePuzzle.x, basePuzzle.y),
      Vector2(basePuzzle.x + basePuzzle.puzzleBoxSize.x, basePuzzle.y),
      Vector2(basePuzzle.x, basePuzzle.puzzleBoxSize.y + basePuzzle.y),
      Vector2(basePuzzle.x + basePuzzle.puzzleBoxSize.x, basePuzzle.puzzleBoxSize.y + basePuzzle.y),
    ];
    for (int i = 0; i < puzzles.length; i++) {
      puzzles[i]
        ..position = puzzlePositions[i]
        ..puzzleBoxSize = Vector2(game.size.x * 0.15, game.size.x * 0.15)
        ..puzzleBoxColor = Color.fromARGB(255, (i * 50), (i * 50), 1 + 255)
        ..puzzleBoxText = 'Puzzle ${i + 2}';
    }

    addAll([background, levelTable, basePuzzle, menuButton]);
    addAll(puzzles);

    return super.onLoad();
  }
}