import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

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
              width: 428,
              height: 143,
              child: Center(
                child: Text(
                  'Title',
                  style: TextStyle(
                    color: palette.fontMain.color,
                    fontSize: 64
                  ),
                ),
              )
            ),
            _gap,
            GestureDetector(
              onTap: () => GoRouter.of(context).push('/main_menu'),
              child: Container(
                color: palette.backgroundSecondary.color,
                child: const Text('Click to start'),
              ),
            )
          ],
        )
      ),
    );
  }
}