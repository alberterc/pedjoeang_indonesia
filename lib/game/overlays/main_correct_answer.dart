import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../main.dart';
import '../../models/player.dart';
import '../../screens/screen_game.dart';
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
              height: screenHeight * 0.75,
              width: screenWidth * 0.65,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/old_paper.png'),
                  fit: BoxFit.fill
                )
              ),
              child: isMainPuzzleCorrect ? Wrap(
                alignment: WrapAlignment.spaceEvenly,
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  RawImage(
                    alignment: Alignment.bottomCenter,
                    image: mainPuzzleCellsBoxSnapshot,
                  ),
                  SizedBox(
                    width: screenWidth * 0.3,
                    child: Column(
                      children: [
                        Text(
                          question,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: constants.fontTinyLarge
                          )
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          solution,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: constants.fontTinyLarge
                          )
                        ),
                        playerData.unlockedLevelCount < levelsData.levels.length ? TextButton(
                          onPressed: () async {
                            game.overlays.remove('MainCorrectAnswer');

                            // update player data: unlocked next level
                            playerProvider.updatePlayer(
                              Player(
                                id: playerData.id,
                                currLevel: playerData.currLevel + 1,
                                unlockedLevelCount: playerData.currLevel + 1 > playerData.unlockedLevelCount ? playerData.unlockedLevelCount + 1 : playerData.unlockedLevelCount
                              )
                            );

                            GoRouter.of(context).pushReplacement(
                              '/game',
                              extra: {
                                'levelsData': levelsData,
                                'playerData': (await playerProvider.getPlayers()).first
                              }
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(8.0),
                            minimumSize: Size.zero,
                          ),
                          child: Text(
                            'Puzzle Berikutnya',
                            style: TextStyle(
                                fontSize: constants.fontTiny
                            )
                          ),
                        ) : Container()
                      ],
                    ),
                  )
                ],
              ) : Wrap (
                alignment: WrapAlignment.spaceEvenly,
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  RawImage(
                    image: mainPuzzleCellsBoxSnapshot,
                  ),
                  SizedBox(
                    width: screenWidth * 0.3,
                    child: Column(
                      children: [
                        Text(
                          question,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: constants.fontTinyLarge
                          )
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'Salah Bro, coba lagi :)',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: constants.fontTinyLarge
                          )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}