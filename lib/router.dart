import 'package:flame/game.dart';
import 'package:go_router/go_router.dart';

import 'widgets/screen_title.dart';
import 'puzzle_game/dialog_screen.dart';
import 'widgets/screen_main_menu.dart';
import 'widgets/screen_settings.dart';

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
          builder: (context, state) => GameWidget(game: DialogScreen())
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) => const ScreenSettings(),
        )
      ]
    ),
  ],
);