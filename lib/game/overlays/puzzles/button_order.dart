import 'dart:math';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import '../../../screens/partials/paper_close_button.dart';
import '../../../screens/partials/puzzle_body.dart';
import '../../../screens/partials/puzzle_status.dart';
import '../../../screens/screen_game.dart';

late Map<int, Widget> solution;
final List<int> _selectedButtonText = [];
bool _isCorrectOrder = true;
late bool _isPuzzleDone;

class ButtonOrder {
  const ButtonOrder({
    required this.order,
    required this.clueImage
  });

  final int order;
  final String clueImage;

  Widget build(BuildContext context, PIGame game) {
    _selectedButtonText.clear();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    solution = buttonOrderClueMap.value;

    _ButtonOrder buttonOrder = _ButtonOrder(
      puzzleOrder: order,
      screenWidth: screenWidth,
      clueList: solution,
      clueImageWidget: Image(
        image: AssetImage(clueImage),
      )
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
                  onPressed: () => game.overlays.remove('ButtonOrder'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Align(
                  alignment: Alignment.center,
                  child: buttonOrder
                )
              )
            ]
          ),
        ),
      )
    );
  }
}

class _ButtonOrder extends StatefulWidget {
  const _ButtonOrder({
    required this.puzzleOrder,
    required this.screenWidth,
    required this.clueList,
    required this.clueImageWidget
  });
  
  final int puzzleOrder;
  final double screenWidth;
  final Map<int, Widget> clueList;
  final Widget clueImageWidget;

  @override
  State<_ButtonOrder> createState() => _ButtonOrderState();
}

class _ButtonOrderState extends State<_ButtonOrder> {
  late List<bool> _selectedButton;
  late List<bool> _isButtonDisabled;
  late List<int> _pickedItems;

  final Map<int, Widget> _orderList = solution;
  final Map<int, Widget> _questionOrderList = {};
  final List<int> _keys = solution.keys.toList();

  static const _gap = SizedBox(height: 24.0);

  @override
  void initState() {
    super.initState();
    _selectedButton = [false, false, false, false];
    _isButtonDisabled = [false, false, false, false];
    _isPuzzleDone = puzzleDone.value['ButtonOrder']!;

    for (int i = 0; i < 4; i++) {
      var keyIndex = Random().nextInt(_keys.length);
      var pickedKey = _keys[keyIndex];
      _questionOrderList[pickedKey] = _orderList[pickedKey]!;
      _keys.remove(pickedKey);
    }
    _pickedItems = _questionOrderList.keys.toList();
  }

  void _checkButtonOrder(int selectedButton, int selectedItem) {
    setState(() {
      _isButtonDisabled[selectedButton] = true;
      _selectedButton[selectedButton] = true;
      if (_selectedButtonText.isNotEmpty) {
        if (selectedItem < _selectedButtonText.last) {
          _isCorrectOrder = false;
        }
      }
      _selectedButtonText.add(selectedItem);
      _checkAnswer();
      _isPuzzleDone = puzzleDone.value['ButtonOrder']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: puzzleShowClue,
      builder: (context, value, _) {
        return PuzzleBody(
          title: 'Urutan Tombol yang Benar',
          spacing: 64.0,
          showClue: value['ButtonOrder']!,
          clue: Container(
            child: widget.clueImageWidget
          ),
          body: SizedBox(
            width: widget.screenWidth * 0.25,
            child: Column(
              children: [
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0
                  ),
                  itemCount: _selectedButton.length,
                  itemBuilder: (_, index) {
                    return TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: _selectedButton[index] ? Colors.white : Colors.black,
                        foregroundColor: _selectedButton[index] ? Colors.black : Colors.white,
                        side: BorderSide(
                          color: _selectedButton[index] ? Colors.black : Colors.white,
                          width: 2.0
                        ),
                      ),
                      onPressed: () {
                        FlameAudio.play('button_click.mp3', volume: 0.5);
                        _isButtonDisabled[index] ? null : _checkButtonOrder(index, _pickedItems[index]);
                      },
                      child: SizedBox(
                        child: _questionOrderList[_pickedItems[index]]!
                      )
                    );
                  }
                ),
                _gap,
                PuzzleStatus(
                  puzzleName: 'ButtonOrder',
                  isDone: _isPuzzleDone
                ),
              ],
            ),
          )
        );
      }
    );
  }

  void _win() {
    puzzleDone.value['ButtonOrder'] = true;
    if (!puzzleDone.value.containsValue(false)) {
      puzzleShowClue.value['MainPuzzle'] = true;
    }
    if (puzzles.length != widget.puzzleOrder) {
      puzzleShowClue.value[puzzles[widget.puzzleOrder].type] = true;
    }
    FlameAudio.play('answer_correct.mp3', volume: 0.3);
  }

  void _lose() {
    _reset();
    FlameAudio.play('answer_wrong.mp3', volume: 0.3);
  }

  void _reset() {
    _selectedButtonText.clear();
    for (int i = 0; i < _selectedButton.length; i++) {
      _selectedButton[i] = false;
      _isButtonDisabled[i] = false;
    }
    _isCorrectOrder = true;
  }

  void _checkAnswer() {
    if (_selectedButtonText.length == 4) {
      if (_isCorrectOrder) {
        _win();
      }
      else {
        _lose();
      }
    }
  }
}