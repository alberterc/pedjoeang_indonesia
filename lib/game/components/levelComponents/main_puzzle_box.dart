import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../../screen_game.dart';

class MainPuzzleBox extends PositionComponent with HasGameReference<ScreenGame> {
  Anchor get puzzleBoxAnchor => puzzleAnchor;
  set puzzleBoxAnchor(Anchor puzzleBoxAnchor) => puzzleAnchor = puzzleBoxAnchor;

  Vector2 get puzzleContainerSize => cellsContainerSize;
  set puzzleContainerSize(Vector2 puzzleContainerSize) => cellsContainerSize = puzzleContainerSize;

  double get cellBoxPadding => cellPadding;
  set cellBoxPadding(double cellBoxPadding) => cellPadding = cellBoxPadding;
  
  Anchor puzzleAnchor = Anchor.topLeft;
  Vector2 cellsContainerSize = Vector2(100, 100);
  double cellPadding = 2.0;

  late SpriteComponent puzzleBox;
  late MainPuzzle mainPuzzle;

  @override
  FutureOr<void> onLoad() {
    // puzzleBox = SpriteComponent(
    //   sprite: Sprite(game.images.fromCache('background.png')),
    //   size: size,
    //   anchor: puzzleAnchor
    // );

    mainPuzzle = MainPuzzle()
      ..anchor = Anchor.center
      ..position = size / 2
      ..size = Vector2(size.x * 0.7, size.y * 0.9);

    add(mainPuzzle);

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = const Color.fromARGB(255, 85, 85, 85)
    );
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
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white
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
      ..size = Vector2(size.x * 0.65, size.x * 0.65)
      ..anchor = Anchor.bottomCenter
      ..position = Vector2(size.x / 2, size.y);

    addAll([
      question,
      cellsBox
    ]);

    return super.onLoad();
  }
}

class CellsBox extends PositionComponent with HasGameReference<ScreenGame> {
  int get gridSize => grid;
  set gridSize(int gridSize) => grid = gridSize;

  int grid = 5;
  late List<List<Cell>> cells;

  @override
  FutureOr<void> onLoad() {
    cells = List.generate(grid, (i) => List.generate(grid, (j) => Cell(
      onTapUpEvent: (event, cellName) {
        debugPrint('$cellName pressed');
      },
      cellName: 'Cell [$i][$j]'
    )
      ..size = Vector2(size.x * 0.18, size.x * 0.18)
      ..anchor = Anchor.topLeft
    ));

    for (int i = 0; i < grid; i++) {
      for (int j = 0; j < grid; j++) {
        cells[i][j].position = Vector2((cells[i][j].size.x * 1.135) * j, (cells[i][j].size.x * 1.135) * i);
      }
      addAll(cells[i]);
    }

    return super.onLoad();
  }
}

class Cell extends PositionComponent with TapCallbacks {
  Cell({
    required this.onTapUpEvent,
    required this.cellName
  });

  final Function(TapUpEvent, String) onTapUpEvent;
  String cellName = 'Cell';

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = const Color.fromARGB(255, 172, 172, 172)
    );
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    onTapUpEvent(event, cellName);
  }
}