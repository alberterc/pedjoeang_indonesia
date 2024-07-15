import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flame_audio/flame_audio.dart';

import 'constants/constants.dart' as constants;
import 'models/player.dart';
import 'provider/player_provider.dart';
import 'router.dart';
import 'app_lifecycle/app_lifecycle.dart';
import 'game/style/palette.dart';

late PlayerProvider playerProvider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  playerProvider = PlayerProvider(
    dbPath: join(await getDatabasesPath(), 'player_database.db'),
    dbVersion: 1
  );
  await playerProvider.ready;

  // playerProvider.deleteAll(); // delete all player data

  // load audio file to cache into memory
  await FlameAudio.audioCache.load('page_turn.mp3');

  // create new player data if it doesn't exist
  if ((await playerProvider.getPlayers()).isEmpty) {
    playerProvider.insertPlayer(Player(id: 0, currLevel: 1, unlockedLevelCount: 1));
  }

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  final List<String> _assets = const [
    'assets/images/old_paper.png',
    'assets/images/menu/game_title.png',
    'assets/images/menu/published_text.png',
    'assets/images/menu/headline_1.png',
    'assets/images/menu/headline_2.png',
    'assets/images/menu/dummy_text.png',
    'assets/images/menu/selector_hand_sprite.png'
  ];

  @override
  Widget build(BuildContext context) {
    _cacheImageAssets(_assets, context);
    return Sizer(
      builder: (context, orientation, deviceType) {
        return AppLifecycleObserver(
          child: MultiProvider(
            providers: [Provider(create: (context) => Palette())],
            child: Builder(
              builder: (context) {
                return MaterialApp.router(
                  title: constants.gameName,
                  routeInformationProvider: router.routeInformationProvider,
                  routeInformationParser: router.routeInformationParser,
                  routerDelegate: router.routerDelegate,
                  theme: ThemeData(
                    fontFamily: 'Pixeloid',
                    colorScheme: ThemeData().colorScheme.copyWith(primary: Colors.black),
                    textSelectionTheme: const TextSelectionThemeData(
                      selectionColor: Colors.white
                    ),
                    elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                        splashFactory: NoSplash.splashFactory,
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero
                          )
                        ),
                        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.white;
                            }
                            if (states.contains(MaterialState.focused)) {
                              return Colors.white;
                            }
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.white;
                            }
                            return Colors.black;
                          }
                        ),
                        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.black;
                            }
                            if (states.contains(MaterialState.focused)) {
                              return Colors.black;
                            }
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.black;
                            }
                            return Colors.white;
                          }
                        ),
                      ),
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                        splashFactory: NoSplash.splashFactory,
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero
                          )
                        ),
                        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.white;
                            }
                            if (states.contains(MaterialState.focused)) {
                              return Colors.black;
                            }
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.white;
                            }
                            return Colors.black;
                          }
                        ),
                        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.black;
                            }
                            if (states.contains(MaterialState.focused)) {
                              return Colors.white;
                            }
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.black;
                            }
                            return Colors.white;
                          }
                        ),
                      ),
                    ),
                  ),
                );
              }
            )
          )
        );
      }
    );
  }

  void _cacheImageAssets(List<String> assets, BuildContext context) {
    for (var asset in assets) {
      precacheImage(Image.asset(asset, gaplessPlayback: true).image, context);
    }
  }
}