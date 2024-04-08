import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:provider/provider.dart';

import 'constants/constants.dart' as constants;
import 'router.dart';
import 'app_lifecycle/app_lifecycle.dart';
import 'style/palette.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  // pre-load bgm audio file
  // await FlameAudio.audioCache.load('music/bgm.mp3');

  runApp(const Game());
}

class Game extends StatelessWidget {
  const Game({super.key});

  @override
  Widget build(BuildContext context) {   
    return AppLifecycleObserver(
      child: MultiProvider(
        providers: [Provider(create: (context) => Palette())],
        child: Builder(
          builder: (context) {
            return MaterialApp.router(
              title: constants.gameName,
              routeInformationProvider: router.routeInformationProvider,
              routeInformationParser: router.routeInformationParser,
              routerDelegate: router.routerDelegate
            );
          }
        )
      ),
    );
  }
}