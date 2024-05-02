import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../screens/partials/puzzle_status.dart';
import '../../../screens/screen_game.dart';
import '../../../constants/constants.dart' as constants;
import '../../../screens/partials/custom_close_button_icon.dart';
import '../../../screens/partials/puzzle_body.dart';

late bool _isPuzzleDone;

class PigpenCipher {
  const PigpenCipher({
    required this.order,
    required this.solution,
    required this.clueImages
  });

  final int order;
  final String solution;
  final List<String> clueImages;

  Widget build(BuildContext context, PIGame game) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    List<String> allSolution = solution.split(' ');
    List<String> solutionList = [];
    for(int i=0; i<5; i++) {
      var random = Random().nextInt(allSolution.length);
      solutionList.add(allSolution[random]);
      allSolution.remove(allSolution[random]);
    }

    List<Widget> clueImageWidgetList = [];
    for (var clue in clueImages) {
      clueImageWidgetList.add(
        Image(
          image: AssetImage(clue),
        )
      );
    }
    _PigpenCipher pigpenCipher = _PigpenCipher(
      puzzleOrder: order,
      solutionList: solutionList,
      clueImageWidgetList: clueImageWidgetList
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
            image: AssetImage('assets/images/ui/old_paper.png'),
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
                child: CustomCloseButtonIcon(
                  onPressed: () => game.overlays.remove('PigpenCipher'),
                )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Align(
                  alignment: Alignment.center,
                  child: pigpenCipher
                )
              )
            ]
          )
        )
      )
    );
  }
}

class _PigpenCipher extends StatefulWidget {
  const _PigpenCipher({
    required this.puzzleOrder,
    required this.solutionList,
    required this.clueImageWidgetList
  });

  final int puzzleOrder;
  final List<String> solutionList;
  final List<Widget> clueImageWidgetList;

  @override
  State<_PigpenCipher> createState() => _PigpenCipherState();
}

class _PigpenCipherState extends State<_PigpenCipher> {
  static const _gap = SizedBox(height: 24.0);

  @override
  void initState() {
    super.initState();
    _isPuzzleDone = puzzleDone.value['PigpenCipher']!;
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    _isPuzzleDone = puzzleDone.value['PigpenCipher']!;
  }
  
  @override
  Widget build(BuildContext context) {
    String submittedAnswer = "";
    
    return ValueListenableBuilder(
      valueListenable: puzzleShowClue,
      builder: (context, value, _) {
        return PuzzleBody(
          title: 'Dekripsi Teks',
          spacing: 16.0,
          showClue: value['PigpenCipher']!,
          clue: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.clueImageWidgetList,
          ),
          body: Column(
            children: [
              for (String word in widget.solutionList) 
                Text(
                  word,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: constants.fontSmall,
                    fontFamily: 'PigpenCipher',
                  ),
                  textDirection: TextDirection.ltr,
                  textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                    applyHeightToLastDescent: false
                  ),
                ),
              _gap,
              FractionallySizedBox(
                widthFactor: 0.5,
                child: TextField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(color: Colors.black)
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(color: Colors.black)
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(color: Colors.black)
                    ),
                    suffixIcon: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                      child: TextButton(
                        onPressed: () => setState(() => _checkAnswer(submittedAnswer, widget.solutionList.join(' '))),
                        child: Text(
                          'Kirim',
                          style: TextStyle(
                            fontSize: constants.fontTiny
                          ),
                        ),
                      ),
                    ),
                    suffixIconConstraints: BoxConstraints.tight(const Size(65, 35)),
                  ),
                  style: TextStyle(
                    fontSize: constants.fontTiny,
                  ),
                  textDirection: TextDirection.ltr,
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.black,
                  inputFormatters: [
                    FilteringTextInputFormatter.singleLineFormatter
                  ],
                  autocorrect: false,
                  onSubmitted: (input) => _checkAnswer(input, widget.solutionList.join(' ')),
                  onChanged: (input) => submittedAnswer = input,
                ),
              ),
              _gap,
              PuzzleStatus(
                puzzleName: 'PigpenCipher',
                isDone: _isPuzzleDone
              )
            ],
          ),
        );
      }
    );
  }

  void _checkAnswer(String input, String solution) {
    if (input.toUpperCase() == solution.toUpperCase()) {
      _win();
    }
    else {
      _lose();
    }
  }

  void _win() {
    puzzleDone.value['PigpenCipher'] = true;
    if (!puzzleDone.value.containsValue(false)) {
      puzzleShowClue.value['MainPuzzle'] = true;
    }
    if (puzzles.length != widget.puzzleOrder) {
      puzzleShowClue.value[puzzles[widget.puzzleOrder].type] = true;
    }
  }

  void _lose() {
    // TODO: add lose information
  }
}