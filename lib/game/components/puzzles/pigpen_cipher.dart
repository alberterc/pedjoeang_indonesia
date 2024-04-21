import 'package:flutter/material.dart';

import '../../../widgets/screen_game.dart';
import '../../../constants/constants.dart' as constants;

class PigpenCipher {
  const PigpenCipher({required this.solution});

  final String solution;
  static const _gap = SizedBox(height: 24.0);
  
  Widget build(BuildContext context, PIGame game) {
    String submittedAnswer = "";
    List<String> solutionList = solution.split(' ');

    return Positioned(
      left: game.size.x * 0.08,
      top: game.size.y * 0.05,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: game.size.x - (game.size.x * 0.08 * 2),
        height: game.size.y - (game.size.y * 0.05 * 2),
        decoration: BoxDecoration(
          color: Colors.orange.shade800
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Decrypt the following text",
              style: TextStyle(
                color: Colors.black, 
                fontSize: constants.fontSmallLarge,
                fontWeight: FontWeight.w700
              ),
            ),
            _gap,
            for (String word in solutionList) 
              Text(
                word, 
                style: TextStyle(
                  color: Colors.black,
                  fontSize: constants.fontSmall,
                  fontFamily: 'PigpenCipher'
                )
              ),
            _gap,
            Wrap(
              runAlignment: WrapAlignment.center,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16.0,
              children: [
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(color: Colors.black)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(color: Colors.black)
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.all(8.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(color: Colors.black)
                      )
                    ),
                    style: TextStyle(
                      fontSize: constants.fontSmall
                    ),
                    cursorColor: Colors.black,
                    autocorrect: false,
                    enableSuggestions: false,
                    onSubmitted: (input) => checkInput(input),
                    onChanged: (input) => submittedAnswer = input,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    checkInput(submittedAnswer);
                  },
                  child: const Text(
                    'Submit'
                  ),
                )
              ],
            ),
          ],
        )
      ),
    );
  }

  void checkInput(String input) {
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