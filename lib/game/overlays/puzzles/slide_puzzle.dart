import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../widgets/screen_game.dart';
import '../../../widgets/partials/custom_close_button_icon.dart';
import '../../../widgets/partials/puzzle_body.dart';
import '../../../constants/constants.dart' as constants;

class SlidePuzzle {
  const SlidePuzzle({
    required this.boardSize,
    required this.solution,
    required this.shuffledNumList,
    required this.clueText
  });

  final int boardSize;
  final List<int> solution;
  final List<int> shuffledNumList;
  final List<String> clueText;

  Widget build(BuildContext context, PIGame game) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    List<Widget> clueWidgetTextList = [];
    for (var clue in clueText) {
      clueWidgetTextList.add(
        Text(
          clue,
          style: TextStyle(fontSize: constants.fontTinyLarge)
        )
      );
      clueWidgetTextList.add(
        const SizedBox(height: 8.0)
      );
    }
    _SlidePuzzle slidePuzzle = _SlidePuzzle(
      game: game,
      boardSize: boardSize,
      solution: solution,
      screenWidth: screenWidth,
      boardNumbers: shuffledNumList,
      clueWidgetTextList: clueWidgetTextList
    );

    return Positioned(
      left: game.size.x * 0.08,
      top: game.size.y * 0.05,
      right: game.size.x * 0.08,
      bottom: 0,
      child: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 68, 239, 0)
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(0),
          physics: const ClampingScrollPhysics(),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: CustomCloseButtonIcon(
                  onPressed: () => game.overlays.remove('SlidePuzzle'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Align(
                  alignment: Alignment.center,
                  child: slidePuzzle
                )
              )
            ]
          )
        )
      )
    );
  }
}

class _SlidePuzzle extends StatefulWidget {
  const _SlidePuzzle({
    required this.game,
    required this.boardSize,
    required this.solution,
    required this.screenWidth,
    required this.boardNumbers,
    required this.clueWidgetTextList
  });
  
  final PIGame game;
  final int boardSize;
  final List<int> solution;
  final double screenWidth;
  final List<int> boardNumbers;
  final List<Widget> clueWidgetTextList;

  @override
  State<_SlidePuzzle> createState() => _SlidePuzzleState();
}

class _SlidePuzzleState extends State<_SlidePuzzle> {
  @override
  Widget build(BuildContext context) {
    final int boardSize = widget.boardSize;
    final List<int> solution = widget.solution;
    List<int> boardNumbers = widget.boardNumbers;

    return PuzzleBody(
      title: 'Benarkan Urutan Angka',
      spacing: 64.0,
      showClue: true,
      clue: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.clueWidgetTextList,
      ),
      body: SizedBox(
        width: widget.screenWidth * 0.25,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 14.0,
            crossAxisSpacing: 14.0
          ),
          shrinkWrap: true,
          itemCount: boardSize,
          itemBuilder: (_, index) {
            if (boardNumbers[index] == 0) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2.0)
                ),
              );
            }
            else {
              return TextButton(
                style: ButtonStyle(
                  side: MaterialStateProperty.resolveWith<BorderSide>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return const BorderSide(
                          color: Colors.black,
                          width: 2.0
                        );
                      }
                      if (states.contains(MaterialState.focused)) {
                        return const BorderSide(
                          color: Colors.black,
                          width: 2.0
                        );
                      }
                      if (states.contains(MaterialState.pressed)) {
                        return const BorderSide(
                          color: Colors.black,
                          width: 2.0
                        );
                      }
                      return const BorderSide(
                          color: Colors.white,
                          width: 2.0
                        );
                    }
                  )
                ),
                onPressed: () async {
                  List<int> newList = await _onTileClick(boardNumbers, await _getCurrentIndex(boardNumbers, boardNumbers[index]));
                  setState(() {
                    boardNumbers = newList;
                  });
                  // if (await _checkAnswer(boardNumbers, solution)) {
                  //   _win(widget.game);
                  // }
                  _win(widget.game);
                },
                child: Text(
                  '${boardNumbers[index]}',
                  style: TextStyle(
                    fontSize: constants.fontSmallLarge
                  ),
                )
              );
            }
          }
        )
      ),
    );
  }

  void _win(PIGame game) {
    game.overlays.remove('SlidePuzzle');
  }

  Future<bool> _checkAnswer(List<int> boardNumbers, List<int> solution) async {
    return listEquals(boardNumbers, solution);
  }

  Future _getCurrentIndex(List<int> boardNumbers, int tileValue) async {
    return boardNumbers.indexOf(tileValue);
  }

  Future _onTileClick(List<int> list, int index) async {
    const int puzzleSize = 3;
    int emptyTileIndex = list.indexOf(0);
    int emptyTileRow = emptyTileIndex ~/ puzzleSize;
    int emptyTileCol = emptyTileIndex % puzzleSize;

    int clickedTileRow = index ~/ puzzleSize;
    int clickedTileCol = index % puzzleSize;

    // element moves up
    if ((clickedTileRow - 1 == emptyTileRow) && (clickedTileCol == emptyTileCol)) {
      list[emptyTileIndex] = list[index];
      list[index] = 0;
    }
    // element moves down
    else if ((clickedTileRow + 1 == emptyTileRow) && (clickedTileCol == emptyTileCol)) {
      list[emptyTileIndex] = list[index];
      list[index] = 0;
    }
    // element moves to the left
    if ((clickedTileRow == emptyTileRow) && (clickedTileCol - 1 == emptyTileCol)) {
      list[emptyTileIndex] = list[index];
      list[index] = 0;
    }
    // moves element to the right
    else if ((clickedTileRow == emptyTileRow) && (clickedTileCol + 1 == emptyTileCol)) {
      list[emptyTileIndex] = list[index];
      list[index] = 0;
    }

    return list;
  }
}