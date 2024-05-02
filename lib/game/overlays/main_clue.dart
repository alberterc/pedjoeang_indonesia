import 'package:flutter/material.dart';

import '../../screens/screen_game.dart';

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
                image: DecorationImage(
                  image: AssetImage('assets/images/old_paper.png'),
                  fit: BoxFit.fill
                )
              ),
              child: ValueListenableBuilder(
                valueListenable: puzzleShowClue,
                builder: (context, value, _) {
                  return Center(
                    child: value['MainPuzzle']! ? Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        for (String coord in mainPuzzleShuffledSolutionCoords)
                          Text(coord)
                      ],
                    ) : const Text(
                      'Petunjuk Utama Tidak Tersedia',
                      style: TextStyle(
                        color: Colors.black,
                      )
                    )
                  );
                }
              ),
            ),
          ),
        ),
      )
    );
  }
}