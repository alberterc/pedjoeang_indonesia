import 'package:flutter/material.dart';

class PuzzleStatus extends StatelessWidget {
  const PuzzleStatus({
    super.key,
    required this.puzzleName,
    required this.isDone
  });

  final String puzzleName;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.05,
      decoration: BoxDecoration(
        color: isDone ? Colors.lightGreen : Colors.red, 
        border: Border.all(color: Colors.black)
      ),
    );
  }
}