import 'package:flutter/material.dart';

import '../../widgets/screen_game.dart';
import '../../constants/constants.dart' as constants;

class MainCorrectAnswer {
  const MainCorrectAnswer({
    required this.question,
    required this.solution
  });

  final String question;
  final String solution;

  Widget build(BuildContext context, PIGame game) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      onPopInvoked: (_) {
        game.overlays.remove('MainCorrectAnswer');
      },
      child: GestureDetector(
        onTap: () {
          game.overlays.remove('MainCorrectAnswer');
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
                  image: AssetImage('assets/images/ui/old_paper.png'),
                  fit: BoxFit.fill
                )
              ),
              child: Column(
                children: [
                  Text(
                    question,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: constants.fontTinyLarge
                    )
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    solution,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: constants.fontTinyLarge
                    )
                  )
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}