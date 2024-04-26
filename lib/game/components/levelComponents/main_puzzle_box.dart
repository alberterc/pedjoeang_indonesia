import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/layout.dart';
import 'package:flutter/material.dart';

import '../../../widgets/screen_game.dart';
import '../../../constants/constants.dart' as constants;
import '../menuComponents/button.dart';


class MainPuzzleBox extends PositionComponent with HasGameReference<PIGame> {
  late MainPuzzle mainPuzzle;
  late SpriteComponent background;

  @override
  FutureOr<void> onLoad() {
    mainPuzzle = MainPuzzle()
      ..anchor = Anchor.center
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
  late TextBoxComponent question;
  late CellsBox cellsBox;

  @override
  FutureOr<void> onLoad() {
    question = TextBoxComponent(
      text: '[Pertanyaan mengenai sejarah penjajahan di Indonesia]',
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
      ..size = Vector2(size.x * 0.5, size.x * 0.4)
      ..anchor = Anchor.topCenter
      ..grid = 5
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

  late int grid;
  late List<List<Button>> cells;

  @override
  FutureOr<void> onLoad() {
    cells = List.generate(grid, (i) => List.generate(grid, (j) => Button(
      onTapUpEvent: (event, _) {
        
      },
      text: '',
      textPaint: TextPaint(
        style: TextStyle(
          fontSize: constants.fontTiny,
          color: constants.fontColorSecondary,
          fontFamily: 'Pixeloid'
        )
      ),
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
}