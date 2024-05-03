import 'package:flutter/material.dart';

class UnorderedList extends StatelessWidget {
  const UnorderedList({super.key, required this.texts, required this.fontSize, this.fontFamily});
  final List<String> texts;
  final double fontSize;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    for (var text in texts) {
      widgetList.add(UnorderedListItem(text: text, fontSize: fontSize, fontFamily: fontFamily));
      if (texts.last != text) {
        widgetList.add(const SizedBox(height: 8.0));
      }
    }

    return Column(children: widgetList);
  }
}

class UnorderedListItem extends StatelessWidget {
  const UnorderedListItem({super.key, required this.text, required this.fontSize, this.fontFamily});
  final String text;
  final double fontSize;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• ',
          style: TextStyle(
            fontFamily: fontFamily ?? 'Pixeloid',
            fontSize: fontSize
          ),
        ),
        Expanded(child: Text(
          text,
          style: TextStyle(
            fontFamily: fontFamily ?? 'Pixeloid',
            fontSize: fontSize
          ),
        ))
      ],
    );
  }
}