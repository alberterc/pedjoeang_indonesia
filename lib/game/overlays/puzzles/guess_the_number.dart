import 'package:flutter/material.dart';
import 'package:pedjoeang_indonesia/widgets/partials/puzzle_body.dart';

import '../../../widgets/partials/custom_close_button_icon.dart';
import '../../../widgets/screen_game.dart';
import '../../../constants/constants.dart' as constants;

class GuessTheNumber {
  const GuessTheNumber({
    required this.solutions,
    required this.clueTexts
  });

  final List<int> solutions;
  final List<String> clueTexts;

  Widget build(BuildContext context, PIGame game) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    List<Widget> clueTextWidgetList = [];
    for (var clue in clueTexts) {
      clueTextWidgetList.add(
        Text(
          clue,
          style: TextStyle(fontSize: constants.fontTinyLarge)
        )
      );
    }

    int solution = solutions[0];

    _GuessTheNumber guessTheNumber = _GuessTheNumber(
      solution: solution,
      clueTextWidgetList: clueTextWidgetList
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
                  onPressed: () => game.overlays.remove('GuessTheNumber'),
                )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Align(
                  alignment: Alignment.center,
                  child: guessTheNumber
                )
              ),
            ]
          )
        )
      )
    );
  }
}

class _GuessTheNumber extends StatefulWidget {
  const _GuessTheNumber({
    required this.solution,
    required this.clueTextWidgetList
  });

  final int solution;
  final List<Widget> clueTextWidgetList;

  @override
  State<_GuessTheNumber> createState() => _GuessTheNumberState();
}

class _GuessTheNumberState extends State<_GuessTheNumber> {

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: puzzleShowClue,
      builder: (context, value, _) {
        return PuzzleBody(
          title: 'Guess The Number',
          spacing: 16.0,
          showClue: value['GuessTheNumber']!,
          clue: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.clueTextWidgetList,
          ),
          body: Container(),
        );
      }
    );
  }
}