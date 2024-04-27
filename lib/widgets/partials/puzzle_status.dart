import 'package:flutter/material.dart';

import '../screen_game.dart';

class PuzzleStatus extends StatefulWidget {
  const PuzzleStatus({
    super.key,
    required this.puzzleName
  });

  final String puzzleName;

  @override
  State<PuzzleStatus> createState() => _PuzzleStatusState();
}

class _PuzzleStatusState extends State<PuzzleStatus> {

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: puzzleDone,
      builder: (context, isDone, _) {
        print(isDone[widget.puzzleName]!);
        if (isDone[widget.puzzleName]!) {
          print('ijo');
          return Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.05,
            decoration: BoxDecoration(
              color: Colors.lightGreen, 
              border: Border.all(color: Colors.black)
            ),
          );
        }
        else {
          print('gak ijo');
          return Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.05,
            decoration: BoxDecoration(
              color: Colors.red, 
              border: Border.all(color: Colors.black)
            ),
          );
        }
      }
    );
  }
}