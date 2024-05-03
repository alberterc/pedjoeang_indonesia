import 'package:go_router/go_router.dart';

import 'screens/screen_outro.dart';
import 'screens/screen_title.dart';
import 'screens/screen_main_menu.dart';
import 'screens/screen_intro.dart';
import 'screens/screen_game.dart';

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
            Map<String, dynamic> data = state.extra as Map<String, dynamic>;
            return ScreenIntro(
              gameData: data['gameData']!
            );
          },
        ),
        GoRoute(
          path: 'game',
          builder: (context, state) {
            Map<String, dynamic> data = state.extra as Map<String, dynamic>;
            return ScreenGame(
              levelsData: data['levelsData']!
            );
          },
        ),
        GoRoute(
          path: 'outro',
          builder: (context, state) {
            return const ScreenOutro();
          },
        )
      ]
    ),
  ],
);