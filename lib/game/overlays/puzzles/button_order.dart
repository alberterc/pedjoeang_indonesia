import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedjoeang_indonesia/widgets/partials/custom_close_button_icon.dart';

import '../../../widgets/partials/puzzle_body.dart';
import '../../../widgets/screen_game.dart';
import '../../../constants/constants.dart' as constants;

late Map<int, Uint8List> solution;

class ButtonOrder {
  const ButtonOrder({
    required this.clueImage
  });

  final String clueImage;

  Widget build(BuildContext context, PIGame game) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                  child: FutureBuilder(
                    future: constants.splitImage(clueImage, 2, 7),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        solution = snapshot.data![Random().nextInt(snapshot.data!.length)];

                        _ButtonOrder buttonOrder = _ButtonOrder(
                          screenWidth: screenWidth,
                          clueImageWidget: Image(
                            image: AssetImage(clueImage),
                          )
                        );
                        
                        return buttonOrder;
                      }
                      else if (snapshot.hasError) {
                        return const Text('Failed to load puzzle data');
                      }
                      return Container();
                    }
                  ),
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
    required this.clueImageWidget
  });
  
  final double screenWidth;
  final Widget clueImageWidget;

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
          clue: widget.clueImageWidget,
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
                  child: SizedBox(
                    child: Image.memory(
                      solution[index + 1]!,
                      fit: BoxFit.fill,
                    ),
                  )
                );
              }
            ),
          )
        );
      }
    );
  }
}