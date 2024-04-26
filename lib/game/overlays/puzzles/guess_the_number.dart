import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedjoeang_indonesia/widgets/partials/puzzle_body.dart';

import '../../../widgets/partials/custom_close_button_icon.dart';
import '../../../widgets/screen_game.dart';
import '../../../constants/constants.dart' as constants;

late String solution;

class GuessTheNumber {
  const GuessTheNumber({
    required this.solutions,
    required this.clueTexts
  });

  final List<String> solutions;
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

    solution = solutions[0];

    _GuessTheNumber guessTheNumber = _GuessTheNumber(
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
    required this.clueTextWidgetList
  });

  final List<Widget> clueTextWidgetList;

  @override
  State<_GuessTheNumber> createState() => _GuessTheNumberState();
}

class _GuessTheNumberState extends State<_GuessTheNumber> {
  static const _gap = SizedBox(height: 24.0);
  var textEditingController = List.generate(4, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: puzzleShowClue,
      builder: (context, value, _) {
        return PuzzleBody(
          title: 'Tebak Angka',
          spacing: 32.0,
          showClue: value['GuessTheNumber']!,
          clue: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.clueTextWidgetList,
            ),
          ),
          body: Column(
            children: [
              Wrap(
                spacing: 16.0,
                children: List.generate(4, (index) {
                  return EachTextField(
                    textController: textEditingController[index]
                  );
                }),
              ),
              _gap,
              TextButton(
                onPressed: () => _checkAnswer(),
                child: Text(
                  'Kirim',
                  style: TextStyle(
                    fontSize: constants.fontSmall
                  ),
                )
              )
            ]
          ),
        );
      }
    );
  }

  void _checkAnswer() {
    final submittedAnswer = List.from(textEditingController.map((e) => e.text)).join();
    if (submittedAnswer == solution) {
      _win();
    }
    else {
      _lose();
    }
  }

  void _win() {
    // TODO: add win information
    puzzleShowClue.value['ButtonOrder'] = true;
  }

  void _lose() {
    // TODO: add lose information
  }
}

class EachTextField extends StatelessWidget {
  const EachTextField({super.key, required this.textController});
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1.0,
          style: BorderStyle.solid
        ),
        borderRadius: BorderRadius.zero
      ),
      width: 45.0,
      child: TextField(
        controller: textController,
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
          suffixIconConstraints: BoxConstraints.tight(const Size(65, 35)),
        ),
        style: TextStyle(
          fontSize: constants.fontSmallLarge
        ),
        textDirection: TextDirection.ltr,
        keyboardType: TextInputType.number,
        cursorColor: Colors.black,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1)
        ],
        autocorrect: false,
        textAlign: TextAlign.center,
        textInputAction: TextInputAction.next,
        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
        onChanged: (input) {
          FocusScope.of(context).nextFocus();
        }
      ),
    );
  }
}