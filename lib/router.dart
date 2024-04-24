import 'package:go_router/go_router.dart';

import 'models/levels.dart';
import 'widgets/screen_title.dart';
import 'widgets/screen_main_menu.dart';
import 'widgets/screen_settings.dart';
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
          path: 'game',
          builder: (context, state) {
            Map<String, Levels?> levels = state.extra as Map<String, Levels?>;
            return ScreenGame(levelData: levels['levels']!);
          },
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) => const ScreenSettings(),
        )
      ]
    ),
  ],
);