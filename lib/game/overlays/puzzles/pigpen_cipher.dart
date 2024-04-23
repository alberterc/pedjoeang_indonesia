import 'package:flutter/material.dart';

import '../../../widgets/screen_game.dart';
import '../../../constants/constants.dart' as constants;
import '../../../widgets/partials/custom_close_button_icon.dart';
import '../../../widgets/partials/puzzle_body.dart';

class PigpenCipher {
  const PigpenCipher({required this.solution, required this.clueImages});

  final String solution;
  final List<String> clueImages;

  Widget build(BuildContext context, PIGame game) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    List<String> solutionList = solution.split(' ');
    List<Widget> clueImageWidgetList = [];
    for (var clue in clueImages) {
      clueImageWidgetList.add(
        Image(
          image: AssetImage(clue),
        )
      );
    }
    _PigpenCipher pigpenCipher = _PigpenCipher(
      solutionList: solutionList,
      clueImageWidgetList: clueImageWidgetList,
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
  const _PigpenCipher({required this.solutionList, required this.clueImageWidgetList});

  final List<String> solutionList;
  final List<Widget> clueImageWidgetList;

  @override
  State<_PigpenCipher> createState() => _PigpenCipherState();
}

class _PigpenCipherState extends State<_PigpenCipher> {
  static const _gap = SizedBox(height: 24.0);
  bool isClueShow = false;
  
  @override
  Widget build(BuildContext context) {
    String submittedAnswer = "";
    
    return PuzzleBody(
      title: 'Dekripsi Teks',
      spacing: 16.0,
      showClue: isClueShow,
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
                    onPressed: () {
                      _checkAnswer(submittedAnswer, widget.solutionList.join(' '));
                    },
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
              autocorrect: false,
              onSubmitted: (input) => _checkAnswer(input, widget.solutionList.join(' ')),
              onChanged: (input) => submittedAnswer = input,
            ),
          ),
        ],
      ),
    );
  }
  
  void showClue(bool show) {
    if (show) {
      setState(() {
        isClueShow = true;
      });
    }
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
    print('you win!');
  }

  void _lose() {
    print('you lose!');
  }
}