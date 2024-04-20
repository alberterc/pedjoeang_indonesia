import 'package:flame/palette.dart';

import '../constants/constants.dart' as constants;

class Palette {
    PaletteEntry get backgroundMain => PaletteEntry(constants.backgroundColorPrimary);
    PaletteEntry get backgroundSecondary => PaletteEntry(constants.backgroundColorSecondary);
    PaletteEntry get fontMain => PaletteEntry(constants.fontColorMain);
}