import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../constants/constants.dart' as constants;
import '../style/palette.dart';

class ScreenMainMenu extends StatelessWidget {
  const ScreenMainMenu({super.key});

  static double eachMenuBoxHeight = 34.sp;
  static double eachMenuBoxWidth = 213.sp;
  // static double eachMenuBoxHeight = 68.0;
  // static double eachMenuBoxWidth = 426.0;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundMain.color,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getGameTitle(palette),
            getGameMainMenu(context, palette),
          ],
        ),
      ),
    );
  }

  Widget getGameTitle(Palette palette) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: palette.backgroundSecondary.color,
        child: FittedBox(
          child: Center(
            child: Text(
              constants.gameName,
              style: TextStyle(
                color: palette.fontMain.color,
                fontSize: constants.fontLarge
              ),
            )
          )
        )
      ),
    );
  }

  Widget getGameMainMenu(BuildContext context, Palette palette) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 40.0, 0, 0),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              GoRouter.of(context).push('/game');
            },
            child: Container(
              color: palette.backgroundSecondary.color,
              width: eachMenuBoxWidth,
              height: eachMenuBoxHeight,
              child: Center(
                child: Text(
                  'Start Game',
                  style: TextStyle(
                    color: palette.fontMain.color,
                    fontSize: constants.fontMedium
                  ),
                ),
              )
            ),
          )
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              GoRouter.of(context).push('/settings');
            },
            child: Container(
              color: palette.backgroundSecondary.color,
              width: eachMenuBoxWidth,
              height: eachMenuBoxHeight,
              child: Center(
                child: Text(
                  'Options',
                  style: TextStyle(
                    color: palette.fontMain.color,
                    fontSize: constants.fontMedium
                  ),
                ),
              )
            ),
          )
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              GoRouter.of(context).go('/');
            },
            child: Container(
              color: palette.backgroundSecondary.color,
              width: eachMenuBoxWidth,
              height: eachMenuBoxHeight,
              child: Center(
                child: Text(
                  'Exit',
                  style: TextStyle(
                    color: palette.fontMain.color,
                    fontSize: constants.fontMedium
                  ),
                ),
              )
            ),
          )
        ),
      ],
      )
    );
  }
}