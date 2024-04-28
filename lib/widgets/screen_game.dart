import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pedjoeang_indonesia/game/overlays/main_correct_answer.dart';
// import 'package:flutter/services.dart';
// import 'package:jenny/jenny.dart';

import '../constants/constants.dart' as constants;
import '../game/components/levels_view.dart';
// import '../game/components/visual_novel_view.dart';
import '../game/overlays/main_clue.dart';
import '../game/overlays/pause_menu.dart';
import '../game/overlays/puzzles/button_order.dart';
import '../game/overlays/puzzles/guess_the_number.dart';
import '../game/overlays/puzzles/pigpen_cipher.dart';
import '../game/overlays/puzzles/slide_puzzle.dart';
import '../game/style/palette.dart';
import '../models/levels.dart';
import '../models/puzzle.dart';

final puzzleShowClue = ValueNotifier<Map<String, bool>>({});
final buttonOrderClueMap = ValueNotifier<Map<int, Widget>>({});
final puzzleDone = ValueNotifier<Map<String, bool>>({});

class ScreenGame extends StatefulWidget {
  const ScreenGame({super.key, required this.levelData});

  final Levels levelData;

  @override
  State<ScreenGame> createState() => _ScreenGameState();
}

class _ScreenGameState extends State<ScreenGame> {
  /*
    store several variables here:
    - playerProgress (currentLevel)
    - each puzzle solution

    when the player clicked the "Submit" button in the level view 
    and the answer is correct:
    - update playerProgress (to the next level)
    - close/pop that ScreenGame widget then start a new ScreenGame widget the
      updated playerProgress and new puzzle solutions
   */

  @override
  Widget build(BuildContext context) {
    MainClue mainClue = const MainClue();
    PauseMenu pauseMenu = const PauseMenu();

    final levels = widget.levelData.levels;
    final mainPuzzle = widget.levelData.levels[0].mainPuzzle;
    final puzzles = levels[0].puzzles;
    for (var puzzle in puzzles) {
      puzzleShowClue.value[puzzle.type] = puzzle.initialShowClue;
      puzzleDone.value[puzzle.type] = false;
    }

    MainCorrectAnswer mainCorrectAnswer = MainCorrectAnswer(
      question: mainPuzzle.title,
      solution: mainPuzzle.clueTexts[0]
    );

    List<int> slidePuzzleSolution = puzzles[0].solution.cast<int>();
    List<String> slidePuzzleClue = puzzles[0].clueTexts;
    SlidePuzzle slidePuzzle = SlidePuzzle(
      boardSize: 9,
      solution: slidePuzzleSolution,
      shuffledNumList: _shuffleBoard(slidePuzzleSolution),
      clueTexts: slidePuzzleClue
    );

    String pigpenCipherSolution = puzzles[1].solution[0];
    List<String> pigpenCipherClue = puzzles[1].clueImages.cast<String>();
    PigpenCipher pigpenCipher = PigpenCipher(
      solution: pigpenCipherSolution,
      clueImages: pigpenCipherClue
    );

    GuessTheNumber guessTheNumber = GuessTheNumber(
      solutions: puzzles[2].solution.cast<String>(),
      clueTexts: puzzles[2].clueTexts
    );

    List<String> buttonOrderClueList = puzzles[3].clueImages.cast<String>();
    String buttonOrderClue = buttonOrderClueList[Random().nextInt(buttonOrderClueList.length)];
    _getOrderList(buttonOrderClue);
    ButtonOrder buttonOrder = ButtonOrder(
      clueImage: buttonOrderClue
    );

    final piGame = PIGame(mainPuzzle: mainPuzzle);

    return Scaffold(
      body: PopScope(
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
          overlayBuilderMap: {
            'MainClue': mainClue.build,
            'MainCorrectAnswer': mainCorrectAnswer.build,
            'PauseMenu': pauseMenu.build,
            'SlidePuzzle': slidePuzzle.build,
            'PigpenCipher': pigpenCipher.build,
            'GuessTheNumber': guessTheNumber.build,
            'ButtonOrder': buttonOrder.build
          },
        )
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
  late Sprite yuriSprite;
  late Sprite mikoSprite;
  // final YarnProject _yarnProject = YarnProject();
  // final VisualNovelView _visualNovelView = VisualNovelView();
  late LevelView levelView;
  
  @override
  Future<void> onLoad() async {
    uiButtonSize = Vector2(size.x * 0.05, size.x * 0.05);
    
    // TODO: decide game assets loading
    // should all assets for both the visual novel view and level view be pre-loaded after the player presses "Start Game"
    // or should they be loaded every time the player changes between the views?

    // load image assets for game
    bgSprite = await loadSprite('ui/game/BG_Mini_Castle_Dark_Gray.png', srcSize: Vector2(600, 360));
    tableSprite = await loadSprite('ui/game/BG_Mini_Ground_Dark.png');
    mainPuzzleBgSprite = await loadSprite('ui/game/broken_paper.png');
    smallPuzzleBgSprite = await loadSprite('ui/game/small_paper.png');
    smallPuzzleIcon = [
      await loadSprite('ui/game/small_grid.png'),
      await loadSprite('ui/game/small_pigpen.png'),
      await loadSprite('ui/game/small_guess_num.png'),
      await loadSprite('ui/game/small_btn_order.png')
    ];
    envelopeIconSprite = {
      'dark': await loadSprite('ui/game/envelope_icon.png'),
      'light': await loadSprite('ui/game/envelope_icon_light.png'),
    };
    menuIconSprite = {
      'dark': await loadSprite('ui/game/menu_icon.png'),
      'light': await loadSprite('ui/game/menu_icon_light.png'),
    };
    checkmarkIconSprite = {
      'dark': await loadSprite('ui/game/checkmark_icon.png'),
      'light': await loadSprite('ui/game/checkmark_icon_light.png'),
    };

    yuriSprite = await loadSprite('yuri.png');
    mikoSprite = await loadSprite('miko.png');

    // String startDialogueData = await rootBundle.loadString('assets/dialogue.yarn');
    // _yarnProject.parse(startDialogueData);
    // var dialogueRunner = DialogueRunner(yarnProject: _yarnProject, dialogueViews: [_visualNovelView]);
    
    // dialogueRunner.startDialogue('Library_Meeting');
    // add(_visualNovelView);

    levelView = LevelView(
      puzzleCount: 4,
      puzzleTypes: [
        'SlidePuzzle',
        'PigpenCipher',
        'GuessTheNumber',
        'ButtonOrder'
      ]
    );
    add(levelView);

    return super.onLoad();
  }
}