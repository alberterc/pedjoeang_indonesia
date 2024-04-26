import 'package:flutter/material.dart';

import '../../widgets/screen_game.dart';

class MainClue {
  const MainClue();
  
  Widget build(BuildContext context, PIGame game) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      onPopInvoked: (_) {
        game.overlays.remove('MainClue');
      },
      child: GestureDetector(
        onTap: () {
          game.overlays.remove('MainClue');
        },
        child: Container(
          color: const Color.fromARGB(117, 0, 0, 0),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              height: screenHeight * 0.6,
              width: screenWidth * 0.3,
              decoration: const BoxDecoration(
                // border: Border.all(color: Colors.black),
                image: DecorationImage(
                  image: AssetImage('assets/images/ui/old_paper.png'),
                  fit: BoxFit.fill
                )
              ),
              child: const Center(
                child: Text(
                  'Main Clue',
                  style: TextStyle(
                    color: Colors.black,
                  )
                )
              ),
            ),
          ),
        ),
      )
    );
  }
}