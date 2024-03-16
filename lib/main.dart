import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:provider/provider.dart';

import 'router.dart';
import 'app_lifecycle/app_lifecycle.dart';
import 'style/palette.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  // pre-load bgm audio file
  // await FlameAudio.audioCache.load('music/bgm.mp3');

  runApp(const MyGame());
}

class MyGame extends StatelessWidget {
  const MyGame({super.key});

  @override
  Widget build(BuildContext context) {   
    return AppLifecycleObserver(
      child: MultiProvider(
        providers: [Provider(create: (context) => Palette())],
        child: Builder(
          builder: (context) {
            return MaterialApp.router(
              title: 'My Game',
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