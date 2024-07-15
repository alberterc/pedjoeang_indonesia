import 'dart:math';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedjoeang_indonesia/screens/partials/unordered_list.dart';

import '../../../screens/partials/paper_close_button.dart';
import '../../../screens/partials/puzzle_body.dart';
import '../../../screens/partials/puzzle_status.dart';
import '../../../screens/screen_game.dart';
import '../../../constants/constants.dart' as constants;

late String solution;
late bool _isPuzzleDone;

class GuessTheNumber {
  const GuessTheNumber({
    required this.order,
    required this.solutions,
    required this.clueTexts
  });

  final int order;
  final List<String> solutions;
  final List<dynamic> clueTexts;

  Widget build(BuildContext context, PIGame game) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    var random = Random().nextInt(solutions.length);
    List<String> randomClue = clueTexts[random].cast<String>();

    solution = solutions[random];

    _GuessTheNumber guessTheNumber = _GuessTheNumber(
      puzzleOrder: order,
      clueTextList: randomClue
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
    required this.puzzleOrder,
    required this.clueTextList
  });

  final int puzzleOrder;
  final List<String> clueTextList;

  @override
  State<_GuessTheNumber> createState() => _GuessTheNumberState();
}

class _GuessTheNumberState extends State<_GuessTheNumber> {
  static const _gap = SizedBox(height: 24.0);
  final _textEditingController = List.generate(4, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    _isPuzzleDone = puzzleDone.value['GuessTheNumber']!;
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    _isPuzzleDone = puzzleDone.value['GuessTheNumber']!;
  }

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
            child: SingleChildScrollView(
              child: UnorderedList(
                texts: widget.clueTextList,
                fontSize: constants.fontTinyLarge
              ),
            ),
          ),
          body: Column(
            children: [
              Wrap(
                spacing: 16.0,
                children: List.generate(4, (index) {
                  return EachTextField(
                    textController: _textEditingController[index]
                  );
                }),
              ),
              _gap,
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: () => setState(() => _checkAnswer()),
                child: Text(
                  'Kirim',
                  style: TextStyle(
                    fontSize: constants.fontSmall
                  ),
                ),
              ),
              _gap,
              PuzzleStatus(
                puzzleName: 'GuessTheNumber',
                isDone: _isPuzzleDone
              ),
            ]
          ),
        );
      }
    );
  }

  void _checkAnswer() {
    final submittedAnswer = List.from(_textEditingController.map((e) => e.text)).join();
    if (submittedAnswer == solution) {
      _win();
    }
    else {
      _lose();
    }
  }

  void _win() {
    puzzleDone.value['GuessTheNumber'] = true;
    if (!puzzleDone.value.containsValue(false)) {
      puzzleShowClue.value['MainPuzzle'] = true;
    }
    if (puzzles.length != widget.puzzleOrder) {
      puzzleShowClue.value[puzzles[widget.puzzleOrder].type] = true;
    }
    FlameAudio.play('answer_correct.mp3', volume: 0.5);
  }

  void _lose() {
    FlameAudio.play('answer_wrong.mp3', volume: 0.3);
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