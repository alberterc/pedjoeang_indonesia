import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../constants/constants.dart' as constants;
import '../game/style/palette.dart';

class ScreenMainMenu extends StatefulWidget {
  const ScreenMainMenu({super.key});

  @override
  State<ScreenMainMenu> createState() => _ScreenMainMenuState();
}

class _ScreenMainMenuState extends State<ScreenMainMenu> {
  static final double _eachMenuBoxHeight = 5.h;
  static final double _eachMenuBoxWidth = 51.w;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundMain.color,
      body: Center(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/menu/main_menu_bg.png'),
                  fit: BoxFit.contain
                )
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.45,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: getGameMainMenu(context, palette),
              ),
            )
          ],
        ),
      )
    );
  }

  Widget getGameMainMenu(BuildContext context, Palette palette) {
    return Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      spacing: 16.0,
      direction: Axis.vertical,
      children: [
        TextButton(
          onPressed: () {
            GoRouter.of(context).push('/game');
          },
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all<Size>(Size(_eachMenuBoxWidth, _eachMenuBoxHeight)),
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
                return constants.backgroundColorPrimary;
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
                'Mulai Main',
                style: TextStyle(
                  fontSize: constants.fontSmallLarge,
                  fontWeight: FontWeight.w700
                ),
              ),
            ]
          )
        ),
        TextButton(
          onPressed: () {
            GoRouter.of(context).push('/settings');
          },
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all<Size>(Size(_eachMenuBoxWidth, _eachMenuBoxHeight)),
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
                return constants.backgroundColorPrimary;
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
                'Pengaturan',
                style: TextStyle(
                  fontSize: constants.fontSmallLarge,
                  fontWeight: FontWeight.w700
                ),
              ),
            ],
          )
        ),
        TextButton(
          onPressed: () {
            GoRouter.of(context).go('/');
          },
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all<Size>(Size(_eachMenuBoxWidth, _eachMenuBoxHeight)),
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
                return constants.backgroundColorPrimary;
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
                'Keluar',
                style: TextStyle(
                  fontSize: constants.fontSmallLarge,
                  fontWeight: FontWeight.w700
                ),
              ),
            ],
          )
        ),
      ],
    );
  }
}