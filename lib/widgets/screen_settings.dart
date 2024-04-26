import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../constants/constants.dart' as constants;
import '../game/style/palette.dart';

class ScreenSettings extends StatefulWidget {
  const ScreenSettings({super.key});

  @override
  State<ScreenSettings> createState() => _ScreenSettingsState();
}

class _ScreenSettingsState extends State<ScreenSettings> {
  late Palette palette;

  static final double _eachMenuBoxHeight = 34.sp;
  static final double _eachMenuBoxWidth = 213.sp;
  // static double _eachMenuBoxHeight = 68.0;
  // static double _eachMenuBoxWidth = 426.0;

  var musicVolume = 25.0;
  var soundEffectVolume = 25.0;
  var skipUnseenText = false;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance()
      .then((value) => value.getDouble('musicVolume') ?? 25.0)
      .then((savedValue) => setState(() => musicVolume = savedValue));
    SharedPreferences.getInstance()
      .then((value) => value.getDouble('soundEffectVolume') ?? 25.0)
      .then((savedValue) => setState(() => soundEffectVolume = savedValue));
    SharedPreferences.getInstance()
      .then((value) => value.getBool('skipUnseenText') ?? false)
      .then((savedValue) => setState(() => skipUnseenText = savedValue));
  }

  @override
  Widget build(BuildContext context) {
    palette = context.watch<Palette>();

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
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
                  child: FittedBox(
                    child: Center(
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          color: palette.fontMain.color,
                          fontSize: constants.fontLarge
                        ),
                      )
                    )
                  )
                ),
                SizedBox(
                  height: 100.0,
                  child: Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 16.0,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3.75,
                        child: Column(
                          children: [
                            Image.asset('assets/images/ui/menu/headline_1.png'),
                            const SizedBox(height: 8.0,),
                            Image.asset('assets/images/ui/menu/dummy_text.png')
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 3.3,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 8.0
                          )
                        ),
                        child: Column(
                          children: [
                            getSettingsFirst(),
                            getSettingsBack()
                          ],
                        ),
                        
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3.75,
                        child: Column(
                          children: [
                            Image.asset('assets/images/ui/menu/dummy_text.png'),
                            const SizedBox(height: 8.0,),
                            Image.asset('assets/images/ui/menu/headline_2.png')
                          ],
                        )
                      ),
                    ],
                  )
                )
              ],
            ),
          ),
        ),
      )
    );
  }

  // Widgets for settings screen title
  Widget getSettingsTitle() {
    return SizedBox(
        child: FittedBox(
          child: Center(
            child: Text(
              'Settings',
              style: TextStyle(
                color: palette.fontMain.color,
                fontSize: constants.fontLarge
              ),
            )
          )
        )
    );
  }

  // Widgets for first, second, etc row
  Widget getSettingsFirst() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getSettingsMusic(),
          getSettingsSoundEffect()
        ],
      ),
    );
  }

  // Widget getSettingsSecond() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       getSettingsDialogSkip(),
  //     ],
  //   );
  // }

  // Widgets for first row
  Widget getSettingsMusic() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Music Volume',
          style: TextStyle(
            color: palette.fontMain.color,
            fontSize: constants.fontTinyLarge
          ),
        ),
        SizedBox(
          height: 30.0,
          width: 200.0,
          child: Slider(
            value: musicVolume,
            min: 0.0,
            max: 100.0,
            label: '${musicVolume.round()}',
            divisions: 5,
            onChanged: (double newValue) {
              SharedPreferences.getInstance().then((value) => value.setDouble('musicVolume', newValue));
              
              // below function can be used elsewhere to change audio volume
              // just need to pass the new volume from the slider through SharedPreferences
              // FlameAudio.bgm.play('music/bgm.mp3', volume: newValue / 100.0);

              setState(() => musicVolume = newValue);
            }
          ),
        )
      ],
    );
  }

  Widget getSettingsSoundEffect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sound Effect Volume',
          style: TextStyle(
            color: palette.fontMain.color,
            fontSize: constants.fontTinyLarge
          ),
        ),
        SizedBox(
          height: 30.0,
          width: 200.0,
          child: Slider(
            value: soundEffectVolume,
            min: 0.0,
            max: 100.0,
            label: '${soundEffectVolume.round()}',
            divisions: 5,
            onChanged: (double newValue) {
              SharedPreferences.getInstance().then((value) => value.setDouble('soundEffectVolume', newValue));
              
              // below function can be used elsewhere to change audio volume
              // just need to pass the new volume from the slider through SharedPreferences
              // FlameAudio.bgm.play('music/bgm.mp3', volume: newValue / 100.0);

              setState(() => soundEffectVolume = newValue);
            }
          ),
        )
      ],
    );
  }

  // // Widgets for second row
  // Widget getSettingsDialogSkip() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Skip',
  //           style: TextStyle(
  //             color: palette.fontMain.color,
  //             fontSize: constants.fontSmallLarge
  //           )
  //         ),
  //         SizedBox(
  //           width: _eachMenuBoxWidth,
  //           child: CheckboxListTile(
  //             value: skipUnseenText,
  //             title: Text(
  //               'Unseen Text',
  //               style: TextStyle(
  //                 color: palette.fontMain.color,
  //                 fontSize: constants.fontSmall
  //               ),
  //             ),
  //             controlAffinity: ListTileControlAffinity.leading,
  //             onChanged: (bool? newValue) {
  //               SharedPreferences.getInstance().then((value) => value.setBool('skipUnseenText', newValue!));
  //               setState(() => skipUnseenText = newValue!);
  //             },
  //           ),
  //         )
  //       ]
  //     ),
  //   );
  // }

  // Widgets for going back to main menu
  Widget getSettingsBack() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          GoRouter.of(context).pop();
        },
        child: Container(
          color: palette.backgroundSecondary.color,
          width: _eachMenuBoxWidth / 2,
          height: _eachMenuBoxHeight / 1.5,
          child: Center(
            child: Text(
              'Back',
              style: TextStyle(
                color: palette.fontMain.color,
                fontSize: constants.fontSmall
              ),
            ),
          )
        ),
      )
    );
  }
}