import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class PaperCloseButton extends StatelessWidget {
  const PaperCloseButton({super.key, this.onPressed});

  final VoidCallback? onPressed;
  
  @override
  Widget build(BuildContext context) {
    return CloseButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero
          )
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.white;
            }
            if (states.contains(MaterialState.focused)) {
              return Colors.white;
            }
            if (states.contains(MaterialState.pressed)) {
              return Colors.white;
            }
            return Colors.black;
          }
        ),
        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.black;
            }
            if (states.contains(MaterialState.focused)) {
              return Colors.black;
            }
            if (states.contains(MaterialState.pressed)) {
              return Colors.black;
            }
            return Colors.white;
          }
        ),
      ),
      color: Colors.white,
      onPressed: () {
        FlameAudio.play('page_turn.mp3');
        if (onPressed != null) {
          onPressed!();
        }
        else {
          Navigator.maybePop(context);
        }
      },
    );
  }
}