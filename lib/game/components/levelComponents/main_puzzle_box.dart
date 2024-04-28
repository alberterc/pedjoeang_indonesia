import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../models/puzzle.dart';
import '../../../widgets/screen_game.dart';
import '../../../constants/constants.dart' as constants;
import '../menuComponents/button.dart';

List<String> _solution = [];
List<String> _selectedChars = [];

class MainPuzzleBox extends PositionComponent with HasGameReference<PIGame> {
  late Puzzle puzzle;
  late MainPuzzle mainPuzzle;
  late SpriteComponent background;

  @override
  FutureOr<void> onLoad() {
    mainPuzzle = MainPuzzle()
      ..anchor = Anchor.center
      ..puzzle = puzzle
      ..position = size / 2
      ..size = Vector2(size.x * 0.725, size.y * 0.65);

    background = SpriteComponent()
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
  late TextBoxComponent question;
  late CellsBox cellsBox;

  @override
  FutureOr<void> onLoad() {
    question = TextBoxComponent(
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

    cellsBox = CellsBox()
      ..anchor = Anchor.topCenter
      ..grid = 5
      ..puzzle = puzzle
      ..size = Vector2(size.x * 0.5, size.x * 0.4)
      ..position = Vector2(question.size.x / 2, question.size.y);

    addAll([
      question,
      cellsBox
    ]);

    return super.onLoad();
  }
}

class CellsBox extends PositionComponent with HasGameReference<PIGame> {
  int get gridSize => grid;
  set gridSize(int gridSize) => grid = gridSize;

  late Puzzle puzzle;
  late int grid;
  late List<List<Button>> cells;

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
      _solution.addAll(chars);
      gridChar.addAll(chars);
    }
    int solutionOnlyCharLength = gridChar.length;
    for (int i = 0; i < grid * grid - solutionOnlyCharLength; i++) {
      gridChar.add(allChars[Random().nextInt(allChars.length)]);
    }
    gridChar.shuffle();

    cells = List.generate(grid, (i) => List.generate(grid, (j) => Button(
      onTapUpEvent: (event, _, isSelected) {
        isSelected ? _selectedChars.add(gridChar[i * grid + j]) : _selectedChars.remove(gridChar[i * grid + j]);
        _checkAnswer();
      },
      text: gridChar[i * grid + j],
      showBorder: true,
      showText: true,
      color: Colors.black
    )
      ..size = Vector2(size.x * 0.15, size.x * 0.15)
      ..borderColor = Colors.white
      ..borderWidth = 1.0
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
    var selectedSort = _selectedChars..sort();
    var solutionSort = _solution..sort();
    if (selectedSort.length == solutionSort.length) {
      if (listEquals(selectedSort, solutionSort)) {
        _win();
      }
    }
  }

  void _win() {
    // TODO: add win information
  }
}