import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../constants/constants.dart' as constants;
import '../style/palette.dart';

class ScreenMainMenu extends StatefulWidget {
  const ScreenMainMenu({super.key});

  @override
  State<ScreenMainMenu> createState() => _ScreenMainMenuState();
}

class _ScreenMainMenuState extends State<ScreenMainMenu> {
  late Color menuColor;
  late Color menuTextColor;
  static final double _eachMenuBoxHeight = 5.h;
  static final double _eachMenuBoxWidth = 51.w;
  // static double _eachMenuBoxHeight = 68.0;
  // static double _eachMenuBoxWidth = 426.0;

  @override
  void initState() {
    menuColor = constants.backgroundColorPrimary;
    menuTextColor = constants.fontColorMain;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundMain.color,
      body: Center(
        child: AspectRatio(
          aspectRatio: constants.forceAspectRatio,
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/menu/main_menu_bg.png'),
                    fit: BoxFit.fill
                  )
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 15.h),
                child: getGameMainMenu(context, palette),
              )
              // SizedBox(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       getGameTitle(palette),
              //       getGameMainMenu(context, palette),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      )
    );
  }

  Widget getGameTitle(Palette palette) {
    return Padding(
      padding: const EdgeInsets.all(0),
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
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            // onTapDown: (_) {
            //   setState(() {
            //     menuColor = constants.invertColor(menuColor);
            //     menuTextColor = constants.invertColor(menuTextColor);
            //   });
            // },
            // onTapUp: (_) {
            //   setState(() {
            //     menuColor = constants.invertColor(menuColor);
            //     menuTextColor = constants.invertColor(menuTextColor);
            //   });
            // },
            // onTapCancel: () {
            //   setState(() {
            //     menuColor = constants.invertColor(menuColor);
            //     menuTextColor = constants.invertColor(menuTextColor);
            //   });
            // },
            onTap: () {
              GoRouter.of(context).push('/game');
            },
            child: Container(
              color: menuColor,
              margin: const EdgeInsets.only(bottom: 16.0),
              width: _eachMenuBoxWidth,
              height: _eachMenuBoxHeight,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/menu/selector_hand_sprite.png',
                  ),
                  Text(
                    'Start Game',
                    style: TextStyle(
                      color: menuTextColor,
                      fontSize: constants.fontMedium,
                      fontFamily: 'Pixeloid',
                      fontWeight: FontWeight.w700
                    ),
                  ),
                ]
              )
            ),
          ),
          GestureDetector(
            // onTapDown: (_) {
            //   setState(() {
            //     menuColor = constants.invertColor(menuColor);
            //     menuTextColor = constants.invertColor(menuTextColor);
            //   });
            // },
            // onTapUp: (_) {
            //   setState(() {
            //     menuColor = constants.invertColor(menuColor);
            //     menuTextColor = constants.invertColor(menuTextColor);
            //   });
            // },
            // onTapCancel: () {
            //   setState(() {
            //     menuColor = constants.invertColor(menuColor);
            //     menuTextColor = constants.invertColor(menuTextColor);
            //   });
            // },
            onTap: () {
              GoRouter.of(context).push('/settings');
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              width: _eachMenuBoxWidth,
              height: _eachMenuBoxHeight,
              child: Center(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/menu/selector_hand_sprite.png',
                    ),
                    Text(
                      'Settings',
                      style: TextStyle(
                        color: menuTextColor,
                        fontSize: constants.fontMedium,
                        fontFamily: 'Pixeloid',
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ],
                )
              )
            ),
          ),
          GestureDetector(
            // onTapDown: (_) {
            //   setState(() {
            //     menuColor = constants.invertColor(menuColor);
            //     menuTextColor = constants.invertColor(menuTextColor);
            //   });
            // },
            // onTapUp: (_) {
            //   setState(() {
            //     menuColor = constants.invertColor(menuColor);
            //     menuTextColor = constants.invertColor(menuTextColor);
            //   });
            // },
            // onTapCancel: () {
            //   setState(() {
            //     menuColor = constants.invertColor(menuColor);
            //     menuTextColor = constants.invertColor(menuTextColor);
            //   });
            // },
            onTap: () {
              GoRouter.of(context).go('/');
            },
            child: SizedBox(
              width: _eachMenuBoxWidth,
              height: _eachMenuBoxHeight,
              child: Center(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/menu/selector_hand_sprite.png',
                    ),
                    Text(
                      'Exit',
                      style: TextStyle(
                        color: menuTextColor,
                        fontSize: constants.fontMedium,
                        fontFamily: 'Pixeloid',
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ],
                )
              )
            ),
          ),
        ],
      ),
    );
  }
}