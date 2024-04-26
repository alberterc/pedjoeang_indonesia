import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../constants/constants.dart' as constants;
import '../game/style/palette.dart';

class ScreenTitle extends StatelessWidget {
  const ScreenTitle({super.key});
  
  static const _gap = SizedBox(height: 48);

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ui/old_paper.png'),
            fit: BoxFit.fill
          )
        ),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 8.0
                  )
                ),
                child: Image.asset('assets/images/ui/menu/game_title.png')
              ),
              _gap,
              GestureDetector(
                onTap: () => GoRouter.of(context).push('/main_menu'),
                child: SizedBox(
                  child: Text('Click to start',
                    style: TextStyle(
                      color: palette.fontMain.color,
                      fontSize: constants.fontSmall
                    )
                  ),
                ),
              )
            ],
          )
        ),
      )
    );
  }
}