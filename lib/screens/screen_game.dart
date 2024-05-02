import 'dart:async';
import 'dart:math';
import 'dart:ui' as dart_ui;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart' as constants;
import '../game/components/levels_view.dart';
import '../game/overlays/main_clue.dart';
import '../game/overlays/main_correct_answer.dart';
import '../game/overlays/pause_menu.dart';
import '../game/overlays/puzzles/button_order.dart';
import '../game/overlays/puzzles/guess_the_number.dart';
import '../game/overlays/puzzles/pigpen_cipher.dart';
import '../game/overlays/puzzles/slide_puzzle.dart';
import '../game/style/palette.dart';
import '../main.dart';
import '../models/levels.dart';
import '../models/player.dart';
import '../models/puzzle.dart';

final puzzleShowClue = ValueNotifier<Map<String, bool>>({});
final buttonOrderClueMap = ValueNotifier<Map<int, Widget>>({});
final puzzleDone = ValueNotifier<Map<String, bool>>({});
late List<Puzzle> puzzles;
late List<String> mainPuzzleShuffledSolution;
late List<String> mainPuzzleShuffledSolutionCoords;
late List<String> mainPuzzleSelectedItems;
late bool isMainPuzzleCorrect;
late dart_ui.Image mainPuzzleCellsBoxSnapshot;
late Levels levelsData;
late Player playerData;

late List<String> _puzzleType;

class ScreenGame extends StatefulWidget {
  const ScreenGame({
    super.key,
    required this.levelsData
  });

  final Levels levelsData;

  @override
  State<ScreenGame> createState() => _ScreenGameState();
}

class _ScreenGameState extends State<ScreenGame> {
  @override
  Widget build(BuildContext context) {
    mainPuzzleShuffledSolution = [];
    mainPuzzleSelectedItems = [];
    mainPuzzleShuffledSolutionCoords = [];
    isMainPuzzleCorrect = false;
    _puzzleType = [];

    MainClue mainClue = const MainClue();
    PauseMenu pauseMenu = const PauseMenu();

    return Scaffold(
      body: FutureBuilder(
        future: playerProvider.getPlayers(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
            playerData = snapshot.data![0];

            // Update player data: change current level
            if (playerData.currLevel + 1 <= playerData.unlockedLevelCount) {
              playerProvider.updatePlayer(
                Player(
                  id: playerData.id,
                  currLevel: playerData.currLevel + 1,
                  unlockedLevelCount: playerData.unlockedLevelCount
                )
              );
            }

            levelsData = widget.levelsData;
            final levels = levelsData.levels;
            final mainPuzzle = levels[playerData.currLevel - 1].mainPuzzle;
            puzzles = levels[playerData.currLevel - 1].puzzles;

            Map<String, Widget Function(BuildContext, PIGame)> overlayMap = {};

            MainCorrectAnswer mainCorrectAnswer = MainCorrectAnswer(
              question: mainPuzzle.title,
              solution: mainPuzzle.clueTexts[0]
            );

            overlayMap.addAll(
              {
                'MainClue': mainClue.build,
                'MainCorrectAnswer': mainCorrectAnswer.build,
                'PauseMenu': pauseMenu.build
              }
            );

            for (var puzzle in puzzles) {
              puzzleShowClue.value[puzzle.type] = puzzle.initialShowClue;
              puzzleDone.value[puzzle.type] = false;
              _puzzleType.add(puzzle.type);

              if (puzzle.type == 'SlidePuzzle') {
                SlidePuzzle slidePuzzle = SlidePuzzle(
                  order: puzzle.order,
                  boardSize: 9,
                  solution: puzzle.solution.cast<int>(),
                  shuffledNumList: _shuffleBoard(puzzle.solution.cast<int>()),
                  clueTexts: puzzle.clueTexts.cast<String>()
                );
                overlayMap.addAll({
                  puzzle.type: slidePuzzle.build
                });
              }
              else if (puzzle.type == 'PigpenCipher') {
                PigpenCipher pigpenCipher = PigpenCipher(
                  order: puzzle.order,
                  solution: puzzle.solution[0],
                  clueImages: puzzle.clueImages.cast<String>()
                );
                overlayMap.addAll({
                  puzzle.type: pigpenCipher.build
                });
              }
              else if (puzzle.type == 'GuessTheNumber') {
                GuessTheNumber guessTheNumber = GuessTheNumber(
                  order: puzzle.order,
                  solutions: puzzle.solution.cast<String>(),
                  clueTexts: puzzle.clueTexts
                );
                overlayMap.addAll({
                  puzzle.type: guessTheNumber.build
                });
              }
              else if (puzzle.type == 'ButtonOrder') {
                List<String> buttonOrderClueList = puzzles[3].clueImages.cast<String>();
                String buttonOrderClue = buttonOrderClueList[Random().nextInt(buttonOrderClueList.length)];
                _getOrderList(buttonOrderClue);
                ButtonOrder buttonOrder = ButtonOrder(
                  order: puzzle.order,
                  clueImage: buttonOrderClue
                );
                overlayMap.addAll({
                  puzzle.type: buttonOrder.build
                });
              }
            }
            puzzleShowClue.value['MainPuzzle'] = mainPuzzle.initialShowClue;
            
            final piGame = PIGame(mainPuzzle: mainPuzzle);

            return PopScope(
              canPop: false,
              onPopInvoked: (_) {
                for (var overlay in constants.flameOverlays) {
                  if (piGame.overlays.isActive(overlay)) {
                    piGame.overlays.remove(overlay);
                    break;
                  }
                  if (overlay == 'PauseMenu') {
                    piGame.overlays.add('PauseMenu');
                  }
                }
              },
              child: GameWidget<PIGame>(
                game: piGame,
                overlayBuilderMap: overlayMap,
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      ),
    );
  }

  List<int> _shuffleBoard(List<int> list) {
    List<int> shuffledNumList = List.from(list);
    shuffledNumList.shuffle();
    return shuffledNumList;
  }

  void _getOrderList(String clueImage) {
    constants.splitImage(clueImage, 2, 7).then((clueMapList) {
      var rand = Random().nextInt(clueMapList.length);
      Map<int, Widget> pickedClueMap = clueMapList[rand];
      buttonOrderClueMap.value = pickedClueMap;
    });
  }
}

class PIGame extends FlameGame {
  PIGame({required this.mainPuzzle});

  final Puzzle mainPuzzle;

  Palette get palette => Palette();
  set palette(Palette palette) => Palette();

  late Vector2 uiButtonSize;
  late Sprite bgSprite;
  late Sprite tableSprite;
  late Sprite mainPuzzleBgSprite;
  late Sprite smallPuzzleBgSprite;
  late List<Sprite> smallPuzzleIcon;
  late Map<String, Sprite> envelopeIconSprite;
  late Map<String, Sprite> menuIconSprite;
  late Map<String, Sprite> checkmarkIconSprite;
  late LevelView levelView;
  
  @override
  Future<void> onLoad() async {
    uiButtonSize = Vector2(size.x * 0.05, size.x * 0.05);

    // load sprite assets for game
    bgSprite = await loadSprite('bricks.png');
    tableSprite = await loadSprite('game/table.png');
    mainPuzzleBgSprite = await loadSprite('game/broken_paper.png');
    smallPuzzleBgSprite = await loadSprite('game/small_paper.png');
    smallPuzzleIcon = [
      await loadSprite('game/small_grid.png'),
      await loadSprite('game/small_pigpen.png'),
      await loadSprite('game/small_guess_num.png'),
      await loadSprite('game/small_btn_order.png')
    ];
    envelopeIconSprite = {
      'dark': await loadSprite('game/envelope_icon.png'),
      'light': await loadSprite('game/envelope_icon_light.png'),
    };
    menuIconSprite = {
      'dark': await loadSprite('game/menu_icon.png'),
      'light': await loadSprite('game/menu_icon_light.png'),
    };
    checkmarkIconSprite = {
      'dark': await loadSprite('game/checkmark_icon.png'),
      'light': await loadSprite('game/checkmark_icon_light.png'),
    };

    levelView = LevelView(
      puzzleCount: puzzles.length,
      puzzleTypes: _puzzleType
    );
    add(levelView);

    return super.onLoad();
  }
}