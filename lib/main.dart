import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
  await Flame.device.setLandscapeRightOnly();
  
  // pre-load bgm audio file
  // await FlameAudio.audioCache.load('music/bgm.mp3');

  playerProvider = PlayerProvider(
    dbPath: join(await getDatabasesPath(), 'player_database.db'),
    dbVersion: 1
  );
  await playerProvider.ready;

  // playerProvider.deleteAll(); // delete all player data

  // create new player data if it doesn't exist
  if ((await playerProvider.getPlayers()).isEmpty) {
    playerProvider.insertPlayer(Player(id: 0, currLevel: 1, unlockedLevelCount: 1));
  }

  runApp(const Game());
}

class Game extends StatelessWidget {
  const Game({super.key});

  @override
  Widget build(BuildContext context) {   
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
}