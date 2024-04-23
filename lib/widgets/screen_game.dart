import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:jenny/jenny.dart';
import 'package:pedjoeang_indonesia/game/overlays/puzzles/pigpen_cipher.dart';
import 'package:pedjoeang_indonesia/game/overlays/pause_menu.dart';

import '../constants/constants.dart' as constants;
import '../game/components/levels_view.dart';
// import '../game/components/visual_novel_view.dart';
import '../game/overlays/puzzles/slide_puzzle.dart';
import '../game/style/palette.dart';

class ScreenGame extends StatefulWidget {
  const ScreenGame({super.key});

  @override
  State<ScreenGame> createState() => _ScreenGameState();
}

class _ScreenGameState extends State<ScreenGame> {
  final _piGame = PIGame();

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

  List<int> _shuffleBoard(List<int> list) {
    List<int> shuffledNumList = List.from(list);
    shuffledNumList.shuffle();
    return shuffledNumList;
  }

  @override
  Widget build(BuildContext context) {
    PauseMenu pauseMenu = const PauseMenu();

    PigpenCipher pigpenCipher = const PigpenCipher(
      solution: 'chair table eagle house',
      clueImages: [
        'assets/images/yuri.png'
      ]
    );
    
    List<int> slidePuzzleSolution = [1, 2, 3, 4, 5, 6, 7, 8, 0];
    SlidePuzzle slidePuzzle = SlidePuzzle(
      boardSize: 9,
      solution: slidePuzzleSolution, // needs to have 0 as the last index
      shuffledNumList: _shuffleBoard(slidePuzzleSolution),
      clueText: [
        'Urutan meningkat',
        'Kiri ke kanan',
        'Atas ke bawah'
      ]
    );

    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvoked: (_) {
          for (var overlay in constants.flameOverlays) {
            if (_piGame.overlays.isActive(overlay)) {
              _piGame.overlays.remove(overlay);
              break;
            }
            if (overlay == 'PauseMenu') {
              _piGame.overlays.add('PauseMenu');
            }
          }
        },
        child: GameWidget<PIGame>(
          game: _piGame,
          overlayBuilderMap: {
            'PauseMenu': pauseMenu.build,
            'PigpenCipher': pigpenCipher.build,
            'SlidePuzzle': slidePuzzle.build
          },
        ),
      ),
    );
  }
}

class PIGame extends FlameGame {
  Palette get palette => Palette();
  set palette(Palette palette) => Palette();

  late Vector2 uiButtonSize;
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

    yuriSprite = await loadSprite('yuri.png');
    mikoSprite = await loadSprite('miko.png');

    // String startDialogueData = await rootBundle.loadString('assets/dialogue.yarn');
    // _yarnProject.parse(startDialogueData);
    // var dialogueRunner = DialogueRunner(yarnProject: _yarnProject, dialogueViews: [_visualNovelView]);
    
    // dialogueRunner.startDialogue('Library_Meeting');
    // add(_visualNovelView);

    levelView = LevelView(
      puzzleCount: 2,
      puzzleTypes: [
        'SlidePuzzle',
        'PigpenCipher'
      ]
    );
    add(levelView);

    return super.onLoad();
  }
}