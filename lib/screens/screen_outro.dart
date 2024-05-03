
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../constants/constants.dart' as constants;
import '../game/style/palette.dart';
import '../models/game_data.dart';
import '../models/player.dart';
import '../main.dart';
import 'screen_main_menu.dart';

class ScreenOutro extends StatelessWidget {
  const ScreenOutro({super.key});

  static const _gap = SizedBox(height: 24.0);

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return FutureBuilder(
      future: getGameData(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          return _getOutroScreen(context, palette, snapshot.data!);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }

  Widget _getOutroScreen(BuildContext context, Palette palette, GameData gameData) {
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
                      child: Column(
                        children: [
                          Text(
                            gameData.narration.outro,
                            style: TextStyle(
                              color: palette.fontMain.color,
                              fontSize: constants.fontSmall
                            ),
                          ),
                          _gap,
                          Wrap(
                            spacing: 20.0,
                            children: [
                              TextButton(
                                onPressed: () {
                                  GoRouter.of(context).pushReplacement('/main_menu'); 
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(8.0),
                                  minimumSize: Size.zero
                                ),
                                child: Text(
                                  'Back To Main Menu',
                                  style: TextStyle(
                                    fontSize: constants.fontTiny
                                  ),
                                )
                              ),
                              TextButton(
                                onPressed: () {
                                  playerProvider.getPlayers().then((value) {
                                    Player playerData = value.first;  
                                    playerProvider.updatePlayer(
                                      Player(
                                        id: playerData.id,
                                        currLevel: 1,
                                        unlockedLevelCount: 1
                                      )
                                    );

                                    GoRouter.of(context).pushReplacement(
                                      '/main_menu',
                                    );
                                  });
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(8.0),
                                  minimumSize: Size.zero
                                ),
                                child: Text(
                                  'Reset Progress',
                                  style: TextStyle(
                                    fontSize: constants.fontTiny
                                  ),
                                )
                              )
                            ],
                          )
                        ],
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