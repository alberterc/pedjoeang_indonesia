import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../constants/constants.dart' as constants;
import '../style/palette.dart';

class ScreenTitle extends StatelessWidget {
  const ScreenTitle({super.key});
  
  static const _gap = SizedBox(height: 48);

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundMain.color,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: palette.backgroundSecondary.color,
              child: FittedBox(
                child: Center(
                  child: Text(
                    constants.gameName,
                    style: TextStyle(
                      color: palette.fontMain.color,
                      fontSize: 42.sp
                    ),
                  )
                )
              )
            ),
            _gap,
            GestureDetector(
              onTap: () => GoRouter.of(context).push('/main_menu'),
              child: Container(
                color: palette.backgroundSecondary.color,
                child: Text('Click to start',
                  style: TextStyle(
                    fontSize: constants.fontSmall
                  )),
              ),
            )
          ],
        )
      ),
    );
  }
}