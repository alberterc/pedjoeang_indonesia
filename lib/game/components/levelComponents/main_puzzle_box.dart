import 'dart:async';
import 'dart:math';
import 'dart:ui' as dart_ui;

import 'package:flame/components.dart';
import 'package:flame/layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../models/puzzle.dart';
import '../../../screens/screen_game.dart';
import '../../../constants/constants.dart' as constants;
import '../uiComponents/custom_togglable_button.dart';

class MainPuzzleBox extends PositionComponent with HasGameReference<PIGame> {
  late Puzzle puzzle;

  @override
  FutureOr<void> onLoad() {
    final mainPuzzle = MainPuzzle()
      ..anchor = Anchor.center
      ..puzzle = puzzle
      ..position = size / 2
      ..size = Vector2(size.x * 0.725, size.y * 0.65);

    final background = SpriteComponent()
      ..sprite = game.mainPuzzleBgSprite
      ..size = size;

    addAll([
      background,
      AlignComponent(
        child: mainPuzzle,
        alignment: Anchor.center
      )
    ]);

    return super.onLoad();
  }
}

class MainPuzzle extends PositionComponent {
  late Puzzle puzzle;
  late CellsBox _cellsBox;

  @override
  FutureOr<void> onLoad() {
    final question = TextBoxComponent(
      text: puzzle.title,
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: constants.fontTinyLarge,
          color: Colors.black,
          fontFamily: 'Pixeloid'
        )
      ),
      position: Vector2(0, 0),
      anchor: Anchor.topLeft,
      align: Anchor.center,
      boxConfig: TextBoxConfig(
        maxWidth: size.x,
        margins: EdgeInsets.zero
      )
    );

    _cellsBox = CellsBox(
      getCellsBoxImage: _takeCellsBoxSnapshot
    )
      ..renderSnapshot = false
      ..anchor = Anchor.topCenter
      ..grid = 5
      ..puzzle = puzzle
      ..size = Vector2(size.x * 0.5, size.x * 0.4)
      ..position = Vector2(question.size.x / 2, question.size.y);

    addAll([
      question,
      _cellsBox
    ]);

    mainPuzzleCellsBoxSnapshot = _takeCellsBoxSnapshot();

    return super.onLoad();
  }

  dart_ui.Image _takeCellsBoxSnapshot() {
    _cellsBox.takeSnapshot();
    return _cellsBox.snapshotAsImage((size.x * 0.5).floor(), (size.x * 0.4).floor());
  }
}

class CellsBox extends PositionComponent with HasGameReference<PIGame>, Snapshot {
  CellsBox({required this.getCellsBoxImage});

  dart_ui.Image Function() getCellsBoxImage;
  late Puzzle puzzle;
  late int grid;

  @override
  FutureOr<void> onLoad() {
    String solution = puzzle.clueTexts.first.toUpperCase();
    List<String> allChars = List.generate(26, (i) => String.fromCharCode(i + 65)) + List.generate(10, (i) => i.toString());
    List<String> words = solution.split(' ');
    List<String> gridChar = [];

    for (String word in words) {
      var chars = word.split('');
      for (String char in chars) {
        if (allChars.contains(char)) {
          allChars.remove(char);
        }
      }
      mainPuzzleShuffledSolution.addAll(chars);
      gridChar.addAll(chars);
    }
    int solutionOnlyCharLength = gridChar.length;
    for (int i = 0; i < grid * grid - solutionOnlyCharLength; i++) {
      var random = Random().nextInt(allChars.length);
      gridChar.add(allChars[random]);
    }
    gridChar.shuffle();
    var gridCharMap = { for (int i = 0; i < gridChar.length; i++) i: gridChar[i] };
    List<int> mainPuzzleShuffledSolutionIndex = [];
    for (int i = 0; i < mainPuzzleShuffledSolution.length; i++) {
      mainPuzzleShuffledSolutionIndex.add(gridCharMap.keys.firstWhere((key) => gridCharMap[key] == mainPuzzleShuffledSolution[i]));
      gridCharMap.remove(gridCharMap.keys.firstWhere((key) => gridCharMap[key] == mainPuzzleShuffledSolution[i]));
    }
    for (int i = 0; i < grid; i++) {
      for (int j = 0; j < grid; j++) {
        if (mainPuzzleShuffledSolutionIndex.contains(i * grid + j)) {
          mainPuzzleShuffledSolutionCoords.add('${i + 1}${String.fromCharCode(j + 65)}');
        }
      }
    }

    var cells = List.generate(grid, (i) => List.generate(grid, (j) => CustomTogglableButton(
      onTapUpEvent: (event, _, isSelected) {
        isSelected ? mainPuzzleSelectedItems.add(gridChar[i * grid + j]) : mainPuzzleSelectedItems.remove(gridChar[i * grid + j]);
        _checkAnswer();
      },
      text: gridChar[i * grid + j],
      showBorder: true,
      showText: true,
      color: Colors.black,
      selectedColor: Colors.white,
      borderColor: Colors.white,
      selectedBorderColor: Colors.black,
      borderWidth: 1.0
    )
      ..size = Vector2(size.x * 0.15, size.x * 0.15)
      ..anchor = Anchor.center
    ));

    int countLeft = grid - 1,
        countRight = grid % 2 != 0 ? 2 : 1,
        countTop = grid - 1,
        countBottom = grid % 2 != 0 ? 2 : 1;
    for (int row = 0; row < grid; row++) {
      if (grid % 2 == 0) {
        if (row < (grid - grid / 2).floor()) {
          for (int col = 0; col < grid; col++) {
            if (col < (grid - grid / 2).floor()) {
              cells[row][col].position = Vector2(
                (size.x / 2) - ((size.x * 0.15 / 2) * countLeft),
                (size.y / 2) - ((size.x * 0.15 / 2) * countTop)
              );
              countLeft -= 2;
            }
            else if (col >= (grid - grid / 2).floor()) {
              cells[row][col].position = Vector2(
                (size.x / 2) + ((size.x * 0.15 / 2) * countRight),
                (size.y / 2) - ((size.x * 0.15 / 2) * countTop)
              );
              countRight += 2;
            }
          }
          countTop -= 2;
        }
        else if (row >= (grid - grid / 2).floor()) {
          for (int col = 0; col < grid; col++) {
            if (col < (grid - grid / 2).floor()) {
              cells[row][col].position = Vector2(
                (size.x / 2) - ((size.x * 0.15 / 2) * countLeft),
                (size.y / 2) + ((size.x * 0.15 / 2) * countBottom)
              );
              countLeft -= 2;
            }
            else if (col >= (grid - grid / 2).floor()) {
              cells[row][col].position = Vector2(
                (size.x / 2) + ((size.x * 0.15 / 2) * countRight),
                (size.y / 2) + ((size.x * 0.15 / 2) * countBottom)
              );
              countRight += 2;
            }
          }
          countBottom += 2;
        }
        countLeft = grid - 1;
        countRight = 1;
      }
      else {
        if (row < (grid - grid / 2).floor()) {
          for (int col = 0; col < grid; col++) {
            if (col < (grid - grid / 2).floor()) {
              cells[row][col].position = Vector2(
                (size.x / 2) - ((size.x * 0.15 / 2) * countLeft),
                (size.y / 2) - ((size.x * 0.15 / 2) * countTop)
              );
              countLeft -= 2;
            }
            else if (col > (grid - grid / 2).floor()) {
              cells[row][col].position = Vector2(
                (size.x / 2) + ((size.x * 0.15 / 2) * countRight),
                (size.y / 2) - ((size.x * 0.15 / 2) * countTop)
              );
              countRight += 2;
            }
            else {
              cells[row][col].position = Vector2(
                size.x / 2,
                (size.y / 2) - ((size.x * 0.15 / 2) * countTop)
              );
            }
          }
          countTop -= 2;
        }
        else if (row > (grid - grid / 2).floor()) {
          for (int col = 0; col < grid; col++) {
            if (col < (grid - grid / 2).floor()) {
              cells[row][col].position = Vector2(
                (size.x / 2) - ((size.x * 0.15 / 2) * countLeft),
                (size.y / 2) + ((size.x * 0.15 / 2) * countBottom)
              );
              countLeft -= 2;
            }
            else if (col > (grid - grid / 2).floor()) {
              cells[row][col].position = Vector2(
                (size.x / 2) + ((size.x * 0.15 / 2) * countRight),
                (size.y / 2) + ((size.x * 0.15 / 2) * countBottom)
              );
              countRight += 2;
            }
            else {
              cells[row][col].position = Vector2(
                size.x / 2,
                (size.y / 2) + ((size.x * 0.15 / 2) * countBottom)
              );
            }
          }
          countBottom += 2;
        }
        else {
          for (int col = 0; col < grid; col++) {
            if (col < (grid - grid / 2).floor()) {
              cells[row][col].position = Vector2(
                (size.x / 2) - ((size.x * 0.15 / 2) * countLeft),
                size.y / 2
              );
              countLeft -= 2;
            }
            else if (col > (grid - grid / 2).floor()) {
              cells[row][col].position = Vector2(
                (size.x / 2) + ((size.x * 0.15 / 2) * countRight),
                size.y / 2
              );
              countRight += 2;
            }
            else {
              cells[row][col].position = Vector2(
                size.x / 2,
                size.y / 2
              );
            }
          }
        }
        countLeft = grid - 1;
        countRight = 2;
      }
      addAll(cells[row]);
    }

    return super.onLoad();
  }

  void _checkAnswer() {
    var selectedSort = mainPuzzleSelectedItems..sort();
    var solutionSort = mainPuzzleShuffledSolution..sort();
    if (selectedSort.length == solutionSort.length) {
      if (listEquals(selectedSort, solutionSort)) {
        _win();
      }
      else {
        _lose();
      }
    }
    else {
      _lose();
    }
    mainPuzzleCellsBoxSnapshot = getCellsBoxImage();
  }

  void _win() {
    isMainPuzzleCorrect = true;
  }

  void _lose() {
    isMainPuzzleCorrect = false;
  }
}