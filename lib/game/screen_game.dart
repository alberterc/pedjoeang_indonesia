import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:jenny/jenny.dart';

import 'components/visual_novel_view.dart';
import '../style/palette.dart';

class ScreenGame extends FlameGame {
  Palette get palette => Palette();
  set palette(Palette palette) => Palette();

  late Vector2 uiButtonSize;
  late Sprite yuriSprite;
  late Sprite mikoSprite;
  YarnProject yarnProject = YarnProject();
  VisualNovelView visualNovelView = VisualNovelView();
  
  @override
  Future<void> onLoad() async {
    uiButtonSize = Vector2(size.x * 0.05, size.x * 0.05);
    
    yuriSprite = await loadSprite('yuri.png');
    mikoSprite = await loadSprite('miko.png');

    String startDialogueData = await rootBundle.loadString('assets/dialogue.yarn');
    yarnProject.parse(startDialogueData);
    var dialogueRunner = DialogueRunner(yarnProject: yarnProject, dialogueViews: [visualNovelView]);
    
    dialogueRunner.startDialogue('Library_Meeting');
    add(visualNovelView);

    return super.onLoad();
  }
}