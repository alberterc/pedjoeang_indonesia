import 'dart:convert';

import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../constants/constants.dart' as constants;
import '../game/style/palette.dart';
import '../models/levels.dart';

class ScreenMainMenu extends StatefulWidget {
  const ScreenMainMenu({super.key});

  @override
  State<ScreenMainMenu> createState() => _ScreenMainMenuState();
}

class _ScreenMainMenuState extends State<ScreenMainMenu> {
  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return FutureBuilder<Levels>(
      future: _getLevelsData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _getMainMenuScreen(palette, snapshot.data);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Widget _getMainMenuScreen(Palette palette, Levels? levels) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/old_paper.png'),
            fit: BoxFit.fill
          )
        ),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 4.0
                          )
                        )
                      ),
                      child: Image.asset('assets/images/ui/menu/published_text.png')
                    ),
                    const SizedBox(height: 8.0,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset('assets/images/ui/menu/game_title.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 16.0,
                  color: Colors.black
                ),
                const SizedBox(height: 8.0,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 8.0,
                  color: Colors.black
                ),
                const SizedBox(height: 24.0,),
                Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 16.0,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3.5,
                      child: Image.asset('assets/images/ui/menu/dummy_text.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3.5,
                      decoration: const BoxDecoration(
                        border: Border.symmetric(
                          vertical: BorderSide(
                            color: Colors.black,
                            width: 4.0
                          ),
                          horizontal: BorderSide(
                            color: Colors.black,
                            width: 8.0
                          )
                        )
                      ),
                      child: _getGameMainMenu(palette, levels)
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3.5,
                      child: Image.asset('assets/images/ui/menu/dummy_text.png', 
                        fit: BoxFit.contain
                      )
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget _getGameMainMenu(Palette palette, Levels? levels) {
    return Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      spacing: 32.0,
      direction: Axis.vertical,
      children: [
        _getTextButton('Mulai Main', () {
          GoRouter.of(context).push(
            '/game',
            extra: {
              'levels': levels
            }
          );
        }),
        _getTextButton('Pengaturan', () {
          GoRouter.of(context).push('/settings');
        }),
        _getTextButton('Keluar', () {
          GoRouter.of(context).go('/');
        })
      ],
    );
  }

  Widget _getTextButton(String text, Function onTap) {
    return TextButton(
      onPressed: () => onTap(),
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all<Size>(Size.fromWidth(MediaQuery.of(context).size.width / 3.8)),
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          )
        ),
        splashFactory: NoSplash.splashFactory,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return constants.backgroundColorPrimary.darken(0.3);
            }
            if (states.contains(MaterialState.focused)) {
              return constants.backgroundColorPrimary.darken(0.3);
            }
            if (states.contains(MaterialState.pressed)) {
              return constants.invertColor(constants.backgroundColorPrimary);
            }
            return Colors.transparent;
          }
        ),
        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return constants.fontColorMain;
            }
            if (states.contains(MaterialState.focused)) {
              return constants.fontColorMain;
            }
            if (states.contains(MaterialState.pressed)) {
              return constants.invertColor(constants.fontColorMain);
            }
            return constants.fontColorMain;
          }
        )
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/ui/menu/selector_hand_sprite.png',
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: constants.fontSmallLarge,
              fontWeight: FontWeight.w700
            ),
          ),
        ]
      )
    );
  }

  Future<Levels> _getLevelsData() async {
    final levelsJsonStr = await rootBundle.loadString('assets/levels.json');
    final levelsJson = jsonDecode(levelsJsonStr);
    final parsedLevelsJson = Levels.fromJson(levelsJson);

    return parsedLevelsJson;
  }
}