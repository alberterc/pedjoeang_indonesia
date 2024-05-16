import 'dart:convert';

import 'package:flame/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../constants/constants.dart' as constants;
import '../game/style/palette.dart';
import '../main.dart';
import '../models/game_data.dart';

class ScreenMainMenu extends StatefulWidget {
  const ScreenMainMenu({super.key});

  @override
  State<ScreenMainMenu> createState() => _ScreenMainMenuState();
}

class _ScreenMainMenuState extends State<ScreenMainMenu> {
  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return FutureBuilder<GameData>(
      future: getGameData(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          return _getMainMenuScreen(palette, snapshot.data);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Widget _getMainMenuScreen(Palette palette, GameData? gameData) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/old_paper.png'),
            fit: BoxFit.fill
          )
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              Column(
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
                    child: Image.asset('assets/images/menu/published_text.png')
                  ),
                  const SizedBox(height: 8.0,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset('assets/images/menu/game_title.png')
                  ),
                ],
              ),
              const SizedBox(height: 4.0,),
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
              const SizedBox(height: 16.0,),
              SizedBox(
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 16.0,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5.1,
                      child: Column(
                        children: [
                          Image.asset('assets/images/menu/headline_1.png'),
                          const SizedBox(height: 8.0,),
                          Image.asset('assets/images/menu/dummy_text.png')
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 32.0,),
                        Container(
                          width: MediaQuery.of(context).size.width / 3.3,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 8.0
                            )
                          ),
                          child: _getGameMainMenu(palette, gameData)
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5.1,
                      child: Column(
                        children: [
                          Image.asset('assets/images/menu/dummy_text.png'),
                          const SizedBox(height: 8.0,),
                          Image.asset('assets/images/menu/headline_2.png')
                        ],
                      )
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  Widget _getGameMainMenu(Palette palette, GameData? gameData) {
    return Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      spacing: 12.0,
      direction: Axis.vertical,
      children: [
        _getTextButton('Mulai Main', () {
          playerProvider.getPlayers().then((value) {
            if (value[0].currLevel == -1) {
              GoRouter.of(context).push(
                '/outro'
              );
            }
            else {
              GoRouter.of(context).push(
                '/intro',
                extra: {
                  'gameData': gameData
                }
              );
            }
          });
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
            'assets/images/menu/selector_hand_sprite.png',
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
}
Future<GameData> getGameData() async {
  final gameDataJsonStr = await rootBundle.loadString('assets/game_data.json');
  final gameDataJson = jsonDecode(gameDataJsonStr);
  final parsedGameDataJson = GameData.fromJson(gameDataJson);

  return parsedGameDataJson;
}