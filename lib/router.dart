import 'package:go_router/go_router.dart';

import 'models/game_data.dart';
import 'models/levels.dart';
import 'widgets/screen_title.dart';
import 'widgets/screen_main_menu.dart';
import 'widgets/screen_intro.dart';
import 'widgets/screen_game.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ScreenTitle(),
      routes: [
        GoRoute(
          path: 'main_menu',
          builder: (context, state) => const ScreenMainMenu(),
        ),
        GoRoute(
          path: 'intro',
          builder: (context, state) {
            Map<String, GameData?> data = state.extra as Map<String, GameData?>;
            return ScreenIntro(gameData: data['gameData']!);
          },
        ),
        GoRoute(
          path: 'game',
          builder: (context, state) {
            Map<String, Levels?> levels = state.extra as Map<String, Levels?>;
            return ScreenGame(levelData: levels['levels']!);
          },
        )
      ]
    ),
  ],
);