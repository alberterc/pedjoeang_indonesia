import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../constants/constants.dart' as constants;
import '../game/style/palette.dart';
import '../models/game_data.dart';
import '../models/levels.dart';

class ScreenIntro extends StatefulWidget {
  const ScreenIntro({
    super.key,
    required this.gameData
  });

  final GameData gameData; 

  @override
  State<ScreenIntro> createState() => _ScreenIntroState();
}

class _ScreenIntroState extends State<ScreenIntro> {
  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return _getIntroScreen(palette, widget.gameData.levels);
  }

  Widget _getIntroScreen(Palette palette, Levels? levels) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          GoRouter.of(context).pushReplacement(
            '/game',
            extra: {
              'levels': levels
            }
          );
        },
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.fill
                )
              ),
            ),
            Center(
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.84,
                  height: MediaQuery.of(context).size.height * 0.9,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/ui/old_paper.png'),
                      fit: BoxFit.fill
                    )
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        'Di dalam ruang penyimpanan yang redup di sebuah museum yang terlupakan, seorang sejarawan menemukan sebuah artefak yang hilang dari waktu—sebuah buku yang sudah tua terikat dengan kulit kuno, halamannya menceritakan kisah-kisah peradaban yang telah lama hilang. Saat ia dengan hati-hati membersihkan debu dari masa lalu, tulisan kriptik di dalamnya bergerak di depan mata, menunjukkan adanya rahasia yang tersembunyi di dalamnya. Didorong oleh keinginan untuk mengetahui lebih banyak, sejarawan itu memulai perjalanan penemuan, setiap halaman adalah teka-teki yang menunggu untuk dipecahkan.',
                        // 'Namun, perjalanan ini tidaklah mudah, karena buku itu menjaga pengetahuannya dengan teka-teki yang rumit. Melalui kabut zaman, teka-teki pertama muncul, solusinya menjadi kunci untuk membuka lapisan pengetahuan kuno berikutnya. Dengan setiap petunjuk yang berhasil dipecahkan, sang sejarawan semakin dalam menyelami labirin sejarah, menyusun pecahan-pecahan dari pengetahuan yang telah lama terlupakan. Saat ia mengungkap misteri dari empat teka-teki, jalan menuju teka-teki utama menjadi semakin jelas. Dengan tekad sebagai penuntunnya, sejarawan itu menavigasi kedalaman sejarah yang penuh misteri, membuka pintu menuju harta karun pengetahuan kuno yang menanti untuk ditemukan.',
                        style: TextStyle(
                          color: palette.fontMain.color,
                          fontSize: constants.fontSmall
                        ),
                      ),
                    )
                    // child: widget.introText
                  ),
                ),
            )
          ],
        ),
      )
    );
  }

  Future<Levels> _getLevelsData() async {
    final levelsJsonStr = await rootBundle.loadString('assets/data.json');
    final levelsJson = jsonDecode(levelsJsonStr);
    final parsedLevelsJson = Levels.fromJson(levelsJson);

    return parsedLevelsJson;
  }
}