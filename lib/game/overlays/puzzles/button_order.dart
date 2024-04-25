import 'package:flutter/material.dart';
import 'package:pedjoeang_indonesia/widgets/partials/custom_close_button_icon.dart';

import '../../../widgets/partials/puzzle_body.dart';
import '../../../widgets/screen_game.dart';

late String solution;

class ButtonOrder {
  const ButtonOrder({
    required this.solutions,
    required this.clueImages
  });

  final List<dynamic> solutions;
  final List<String> clueImages;

  Widget build(BuildContext context, PIGame game) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    List<Widget> clueImageWidgetList = [];
    for (var clue in clueImages) {
      clueImageWidgetList.add(
        Image(
          image: AssetImage(clue),
        )
      );
    }

    solution = solutions[0];

    _ButtonOrder buttonOrder = _ButtonOrder(
      screenWidth: screenWidth,
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
                  onPressed: () => game.overlays.remove('ButtonOrder'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Align(
                  alignment: Alignment.center,
                  child: buttonOrder,
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
    required this.clueImageWidgetList
  });
  
  final double screenWidth;
  final List<Widget> clueImageWidgetList;

  @override
  State<_ButtonOrder> createState() => _ButtonOrderState();
}

class _ButtonOrderState extends State<_ButtonOrder> {
  final List<bool> _selectedButton = [false, false, false, false];

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
            children: widget.clueImageWidgetList
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
              itemBuilder: (context, index) {
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
                    setState(() {
                      _selectedButton[index] = !_selectedButton[index];
                    });
                  },
                  child: Image(image: AssetImage(solution)),
                );
              }
            ),
          )
        );
      }
    );
  }
}