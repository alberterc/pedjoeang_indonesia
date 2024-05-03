import 'dart:async';

import 'package:flame/components.dart';

import '../../../screens/screen_game.dart';

class LevelTable extends PositionComponent with HasGameReference<PIGame>, Snapshot {
  late Sprite sprite;

  @override
  FutureOr<void> onLoad() {
    final background = SpriteComponent()
      ..sprite = sprite
      ..size = size;

    add(background);
    return super.onLoad();
  }
}