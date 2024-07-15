import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../screens/partials/puzzle_status.dart';
import '../../../screens/screen_game.dart';
import '../../../screens/partials/paper_close_button.dart';
import '../../../screens/partials/puzzle_body.dart';
import '../../../constants/constants.dart' as constants;

late bool _isPuzzleDone;

class SlidePuzzle {
  const SlidePuzzle({
    required this.order,
    required this.boardSize,
    required this.solution,
    required this.shuffledNumList,
    required this.clueTexts
  });

  final int order;
  final int boardSize;
  final List<int> solution;
  final List<int> shuffledNumList;
  final List<String> clueTexts;

  Widget build(BuildContext context, PIGame game) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    List<Widget> clueWidgetTextList = [];
    for (var clue in clueTexts) {
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
      puzzleOrder: order,
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
            image: DecorationImage(
            image: AssetImage('assets/images/old_paper.png'),
            fit: BoxFit.fill
          )
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(0),
          physics: const ClampingScrollPhysics(),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: PaperCloseButton(
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
    required this.puzzleOrder,
    required this.boardSize,
    required this.solution,
    required this.screenWidth,
    required this.boardNumbers,
    required this.clueWidgetTextList,
  });
  
  final int puzzleOrder;
  final int boardSize;
  final List<int> solution;
  final double screenWidth;
  final List<int> boardNumbers;
  final List<Widget> clueWidgetTextList;

  @override
  State<_SlidePuzzle> createState() => _SlidePuzzleState();
}

class _SlidePuzzleState extends State<_SlidePuzzle> {
  static const _gap = SizedBox(height: 24.0);

  @override
  void initState() {
    super.initState();
    _isPuzzleDone = puzzleDone.value['SlidePuzzle']!;
  }

  @override
  Widget build(BuildContext context) {
    final int boardSize = widget.boardSize;
    final List<int> solution = widget.solution;
    List<int> boardNumbers = widget.boardNumbers;

    return ValueListenableBuilder(
      valueListenable: puzzleShowClue,
      builder: (context, value, _) {
        return PuzzleBody(
          title: 'Benarkan Urutan Angka',
          spacing: 64.0,
          showClue: value['SlidePuzzle']!,
          clue: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.clueWidgetTextList,
          ),
          body: SizedBox(
            width: widget.screenWidth * 0.25,
            child: Column(
              children: [
                GridView.builder(
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
                          FlameAudio.play('button_click.mp3', volume: 0.5);
                          List<int> newList = await _onTileClick(boardNumbers, await _getCurrentIndex(boardNumbers, boardNumbers[index]));
                          setState(() {
                            boardNumbers = newList;
                            if (_checkAnswer(boardNumbers, solution)) {
                              _win();
                            }
                            _isPuzzleDone = puzzleDone.value['SlidePuzzle']!;
                          });
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
                ),
                _gap,
                PuzzleStatus(
                  puzzleName: 'SlidePuzzle',
                  isDone: _isPuzzleDone
                ),
              ],
            )
          ),
        );
      }
    );
  }

  void _win() {
    puzzleDone.value['SlidePuzzle'] = true;
    if (!puzzleDone.value.containsValue(false)) {
      puzzleShowClue.value['MainPuzzle'] = true;
    }
    if (puzzles.length != widget.puzzleOrder) {
      puzzleShowClue.value[puzzles[widget.puzzleOrder].type] = true;
    }
    FlameAudio.play('answer_correct.mp3', volume: 0.5);
  }

  bool _checkAnswer(List<int> boardNumbers, List<int> solution) {
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