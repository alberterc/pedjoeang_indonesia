import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pedjoeang_indonesia/widgets/partials/custom_close_button_icon.dart';

import '../../../widgets/partials/puzzle_body.dart';
import '../../../widgets/screen_game.dart';

late Map<int, Widget> solution;
final List<int> _selectedButtonText = [];
bool _isCorrectOrder = true;

class ButtonOrder {
  const ButtonOrder({
    required this.clueImage
  });

  final String clueImage;

  Widget build(BuildContext context, PIGame game) {
    _selectedButtonText.clear();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    solution = buttonOrderClueMap.value;

    _ButtonOrder buttonOrder = _ButtonOrder(
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
    required this.screenWidth,
    required this.clueList,
    required this.clueImageWidget
  });
  
  final double screenWidth;
  final Map<int, Widget> clueList;
  final Widget clueImageWidget;

  @override
  State<_ButtonOrder> createState() => _ButtonOrderState();
}

class _ButtonOrderState extends State<_ButtonOrder> {
  late List<bool> _selectedButton;
  late List<bool> _isButtonDisabled;

  Map<int, Widget> orderList = solution;
  Map<int, Widget> questionOrderList = {};
  List<int> keys = solution.keys.toList();
  late List<int> pickedItems;

  @override
  void initState() {
    super.initState();
    _selectedButton = [false, false, false, false];
    _isButtonDisabled = [false, false, false, false];

    for (int i = 0; i < 4; i++) {
      var keyIndex = Random().nextInt(keys.length);
      var pickedKey = keys[keyIndex];
      questionOrderList[pickedKey] = orderList[pickedKey]!;
      keys.remove(pickedKey);
    }
    pickedItems = questionOrderList.keys.toList();
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
          clue: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.clueImageWidget
            ],
          ),
          body: SizedBox(
            width: widget.screenWidth * 0.25,
            child: GridView.builder(
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
                    _isButtonDisabled[index] ? null : _checkButtonOrder(index, pickedItems[index]);
                  },
                  child: SizedBox(
                    child: questionOrderList[pickedItems[index]]!
                  )
                );
              }
            ),
          )
        );
      }
    );
  }

  void _win() {
    // TODO: add win information
    // puzzleShowClue.value['MainQuestion'] = true;
    debugPrint('win');
  }

  void _lose() {
    // TODO: add lose information
    _reset();
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