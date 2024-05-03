import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../constants/constants.dart' as constants;
import '../game/style/palette.dart';
import '../models/game_data.dart';

class ScreenIntro extends StatelessWidget {
  const ScreenIntro({
    super.key,
    required this.gameData
  });

  final GameData gameData;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return _getIntroScreen(context, palette, gameData);
  }

  Widget _getIntroScreen(BuildContext context, Palette palette, GameData gameData) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          GoRouter.of(context).pushReplacement(
            '/game',
            extra: {
              'levelsData': gameData.levels
            }
          );
        },
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bricks.png'),
                  fit: BoxFit.fill
                )
              ),
            ),
            Center(
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.84,
                  height: MediaQuery.of(context).size.height * 0.9,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/old_paper.png'),
                      fit: BoxFit.fill
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        gameData.narration.intro,
                        style: TextStyle(
                          color: palette.fontMain.color,
                          fontSize: constants.fontSmall
                        )
                      ),
                    )
                  ),
                ),
            )
          ],
        ),
      )
    );
  }
}