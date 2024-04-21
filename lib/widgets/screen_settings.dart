import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../constants/constants.dart' as constants;
import '../style/palette.dart';

class ScreenSettings extends StatefulWidget {
  const ScreenSettings({super.key});

  @override
  State<ScreenSettings> createState() => ScreenSettingsState();
}

class ScreenSettingsState extends State<ScreenSettings> {
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
      backgroundColor: palette.backgroundMain.color,
      body: Center(
        child: AspectRatio(
          aspectRatio: constants.forceAspectRatio,
          child: FractionallySizedBox(
            widthFactor: 0.8,
            heightFactor: 0.8,
            child: Container(
              color: palette.backgroundSecondary.color,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getSettingsTitle(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getSettingsFirst(),
                      getSettingsSecond()
                    ],
                  ),
                  getSettingsBack()
                ],
              ),
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

  Widget getSettingsSecond() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getSettingsDialogSkip(),
      ],
    );
  }

  // Widgets for first row
  Widget getSettingsMusic() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Music Volume',
          style: TextStyle(
            color: palette.fontMain.color,
            fontSize: 14.sp
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
            fontSize: 14.sp
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

  // Widgets for second row
  Widget getSettingsDialogSkip() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skip',
            style: TextStyle(
              color: palette.fontMain.color,
              fontSize: 14.sp
            )
          ),
          SizedBox(
            width: _eachMenuBoxWidth,
            child: CheckboxListTile(
              value: skipUnseenText,
              title: Text(
                'Unseen Text',
                style: TextStyle(
                  color: palette.fontMain.color,
                  fontSize: constants.fontSmall
                ),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? newValue) {
                SharedPreferences.getInstance().then((value) => value.setBool('skipUnseenText', newValue!));
                setState(() => skipUnseenText = newValue!);
              },
            ),
          )
        ]
      ),
    );
  }

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
          width: _eachMenuBoxWidth,
          height: _eachMenuBoxHeight,
          child: Center(
            child: Text(
              'Back',
              style: TextStyle(
                color: palette.fontMain.color,
                fontSize: 16.sp
              ),
            ),
          )
        ),
      )
    );
  }
}