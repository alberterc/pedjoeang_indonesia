import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:go_router/go_router.dart';

import '../../constants/constants.dart' as constants;
import '../screen_game.dart';
import 'levelComponents/level_puzzle.dart';
import 'levelComponents/level_table.dart';
import 'levelComponents/main_puzzle_box.dart';
import 'menuComponents/button.dart';

class LevelView extends PositionComponent with HasGameReference<ScreenGame> {
  LevelView({required this.puzzleCount});

  final renderPriority = constants.renderPriority; 

  int puzzleCount;
  late SpriteComponent background;
  late LevelTable levelTable;
  late MainPuzzleBox mainPuzzle;
  late TextBoxComponent mainTimeLimit;
  late List<LevelPuzzle> puzzles;
  late Button mainPuzzleSubmitButton;
  late Button menuButton;

  @override
  FutureOr<void> onLoad() async {
    double tableLeft = game.size.x * 0.08;
    double tableTop = game.size.y * 0.05;
    double mainPuzzleLeft = game.size.x * 0.1;
    double mainPuzzleTop = game.size.y * 0.1;

    menuButton = Button(
      text: 'Menu',
      showText: false,
      
      onTapUpEvent: (event, buttonName) {
        debugPrint('$buttonName button pressed');
      },
      
      color: game.palette.backgroundSecondary.color
    )
      ..priority = renderPriority['ui']!
      ..size = game.uiButtonSize
      ..position = Vector2(game.size.x - game.uiButtonSize.x - game.size.x * 0.02, game.size.y * 0.03);

    background = SpriteComponent()
      ..sprite = await game.loadSprite('background.png')
      ..priority = renderPriority['background']!
      ..size = game.size;

    levelTable = LevelTable()
      ..priority = renderPriority['foreground']!
      ..size = Vector2(game.size.x - (tableLeft * 2), game.size.y - (tableTop * 2))
      ..position = Vector2(tableLeft, tableTop);

    mainPuzzle =  MainPuzzleBox()
      ..priority = renderPriority['foreground']!
      ..size = Vector2(game.size.x - ((tableLeft + mainPuzzleLeft) * 2), game.size.y - ((tableTop + mainPuzzleTop) * 2))
      ..puzzleBoxAnchor = Anchor.topLeft
      ..position = Vector2(tableLeft + mainPuzzleLeft, tableTop + mainPuzzleTop);

    mainTimeLimit = TextBoxComponent(
      priority: renderPriority['foreground'],
      text: '00:00',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.black
        )
      ),
      position: Vector2(mainPuzzle.x, mainPuzzle.y * 0.65),
      anchor: Anchor.topLeft,
      size: Vector2(mainPuzzle.size.x, game.size.y * 0.04),
      align: Anchor.center,
      boxConfig: TextBoxConfig(
        maxWidth: mainPuzzle.size.x,
        margins: EdgeInsets.zero
      )
    );

    mainPuzzleSubmitButton = Button(
      text: 'Submit',
      onTapUpEvent: (event, buttonName) {
        debugPrint('$buttonName button pressed');
      },
      color: const Color.fromARGB(255, 85, 85, 85)
    )
      ..priority = renderPriority['ui']!
      ..position = Vector2(mainPuzzle.x + mainPuzzle.size.x / 2, mainPuzzle.y * 1.35 + mainPuzzle.size.y)
      ..anchor = Anchor.center
      ..size = Vector2(mainPuzzle.size.x * 0.4, game.size.y * 0.07);

    puzzles = List.generate(puzzleCount, (index) => LevelPuzzle(
      onTapUpEvent: (event, buttonName) {
        debugPrint('$buttonName button pressed');
      }
    )
      ..priority = renderPriority['foreground']!
      ..anchor = Anchor.center
    );

    List<Vector2> puzzlePositions = [
      Vector2(mainPuzzle.x, mainPuzzle.y * 1.5),
      Vector2(mainPuzzle.x + mainPuzzle.size.x, mainPuzzle.y * 1.5),
      Vector2(mainPuzzle.x, mainPuzzle.size.y + mainPuzzle.y * 0.5),
      Vector2(mainPuzzle.x + mainPuzzle.size.x, mainPuzzle.size.y + mainPuzzle.y * 0.5),
    ];
    for (int i = 0; i < puzzles.length; i++) {
      puzzles[i]
        ..position = puzzlePositions[i]
        ..size = Vector2(constants.cipherSize, constants.cipherSize)
        // ..size = Vector2(game.size.x * 0.125, game.size.x * 0.12)
        ..puzzleBoxColor = Color.fromARGB(255, (i * 50), (i * 50), 1 + 255)
        ..puzzleBoxText = 'Cipher ${i + 1}';
    }

    addAll([background, levelTable, mainPuzzle, mainTimeLimit, mainPuzzleSubmitButton, menuButton]);
    addAll(puzzles);

    return super.onLoad();
  }
}