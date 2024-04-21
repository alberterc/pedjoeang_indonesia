import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/screen_game.dart';
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
                  'Game Paused',
                  style: TextStyle(
                    fontSize: constants.fontLarge,
                    color: Colors.white
                  ),
                ),
                _gap,
                ElevatedButton(
                  onPressed: () {
                    game.overlays.remove('PauseMenu');
                    GoRouter.of(context).pop();
                  },
                  child: const Text('Main Menu'),
                ),
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).push('/settings');
                  },
                  child: const Text('Settings'),
                ),
              ]
            ),
          ),
        ),
      )
    );
  }
}