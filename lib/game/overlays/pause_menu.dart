import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens/screen_game.dart';
import '../../constants/constants.dart' as constants;

class PauseMenu {
  const PauseMenu();

  static const _gap = SizedBox(height: 30.0);
  
  Widget build(BuildContext context, PIGame game) {
    game.pauseEngine();
    return PopScope(
      canPop: false,
      onPopInvoked: (_) {
        game.overlays.remove('PauseMenu');
        game.resumeEngine();
      },
      child: GestureDetector(
        onTap: () {
          game.overlays.remove('PauseMenu');
          game.resumeEngine();
        },
        child: Container(
          color: const Color.fromARGB(117, 0, 0, 0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Permainan Dijeda',
                  style: TextStyle(
                    fontSize: constants.fontLarge,
                    color: Colors.white
                  ),
                ),
                _gap,
                ElevatedButton(
                  style: ButtonStyle(
                    side: MaterialStateProperty.resolveWith<BorderSide>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return const BorderSide(
                              color: Colors.black,
                              width: 2.0
                            );
                          }
                          if (states.contains(MaterialState.focused)) {
                            return const BorderSide(
                              color: Colors.black,
                              width: 2.0
                            );
                          }
                          if (states.contains(MaterialState.pressed)) {
                            return const BorderSide(
                              color: Colors.black,
                              width: 2.0
                            );
                          }
                          return const BorderSide(
                            color: Colors.white,
                            width: 2.0
                          );
                        }
                      )
                  ),
                  onPressed: () {
                    FlameAudio.play('button_click.mp3', volume: 0.5);
                    game.overlays.remove('PauseMenu');
                    GoRouter.of(context).pop();
                  },
                  child: const Text('Menu Utama'),
                ),
              ]
            ),
          ),
        ),
      )
    );
  }
}