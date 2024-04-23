import 'package:flutter/material.dart';

import '../../constants/constants.dart' as constants;

class PuzzleBody extends StatelessWidget {
  const PuzzleBody({
    super.key,
    required this.title,
    required this.body,
    this.spacing,
    this.clue,
    this.showClue = false
  });

  final String title;
  final Widget body;
  final double? spacing;
  final Widget? clue;
  final bool showClue;
  static const _gap = SizedBox(height: 24.0);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black, 
            fontSize: constants.fontSmall,
            fontWeight: FontWeight.w700
          ),
        ),
        _gap,
        Wrap(
          alignment: WrapAlignment.spaceAround,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: spacing ?? 8.0,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              height: screenHeight * 0.6,
              width: screenWidth * 0.3,
              decoration: BoxDecoration(
                color: constants.backgroundColorPrimary,
                border: Border.all(color: Colors.black),
              ),
              child: showClue ? 
                clue ?? Center(
                  child: Text(
                    'Petunjuk Tidak Tersedia',
                    style: TextStyle(
                      fontSize: constants.fontTiny,
                    )
                  )
                ) : Center(
                  child: Text(
                    'Petunjuk Tidak Tersedia',
                    style: TextStyle(
                      fontSize: constants.fontTiny,
                    ),
                  ),
                )
            ),
            body
          ],
        ),
      ],
    );
  }
}