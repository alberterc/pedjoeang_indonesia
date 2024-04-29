import 'dart:async';

import 'package:flame/components.dart';

import '../../../widgets/screen_game.dart';

class LevelTable extends PositionComponent with HasGameReference<PIGame>, Snapshot {
  late SpriteComponent background;
  late Sprite sprite;

  @override
  FutureOr<void> onLoad() {
    background = SpriteComponent()
      ..sprite = sprite
      ..size = size;

    add(background);
    return super.onLoad();
  }
}