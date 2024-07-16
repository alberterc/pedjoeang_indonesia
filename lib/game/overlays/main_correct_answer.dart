import 'package:flame_audio/flame_audio.dart';
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

    if (isMainPuzzleCorrect) {
      FlameAudio.play('answer_correct.mp3');
    }
    else {
      FlameAudio.play('answer_wrong.mp3', volume: 0.3);
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (_) {
        FlameAudio.play('page_turn.mp3');
        game.overlays.remove('MainCorrectAnswer');
      },
      child: GestureDetector(
        onTap: () {
          FlameAudio.play('page_turn.mp3');
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
                            FlameAudio.play('button_click.mp3', volume: 0.5);
                            game.overlays.remove('MainCorrectAnswer');

                            // update player data: unlocked next level
                            playerProvider.updatePlayer(
                              Player(
                                id: playerData.id,
                                currLevel: playerData.currLevel + 1,
                                unlockedLevelCount: playerData.currLevel != -1 ? playerData.unlockedLevelCount + 1 : playerData.unlockedLevelCount
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
                        ) : TextButton(
                          onPressed: () async {
                            FlameAudio.play('button_click.mp3', volume: 0.5);
                            game.overlays.remove('MainCorrectAnswer');

                            playerProvider.updatePlayer(
                              Player(
                                id: playerData.id,
                                currLevel: -1,
                                unlockedLevelCount: playerData.currLevel != -1 ? playerData.unlockedLevelCount + 1 : playerData.unlockedLevelCount
                              )
                            );

                            GoRouter.of(context).go(
                              '/outro'
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(8.0),
                            minimumSize: Size.zero,
                          ),
                          child: Text(
                            'Selesai',
                            style: TextStyle(
                                fontSize: constants.fontTiny
                            )
                          )
                        )
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
                          'Jawaban salah, coba lagi',
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