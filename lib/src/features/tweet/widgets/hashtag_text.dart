// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:twitter_clone/src/theme/palette.dart';

class HashTagText extends StatelessWidget {
  const HashTagText({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = text.split(' ').map((e) {
      if (e.startsWith('#')) {
        return TextSpan(
          text: '$e ',
          style: const TextStyle(
            color: Pallete.blueColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        );
      } else if (e.startsWith('@')) {
        return TextSpan(
          text: '$e ',
          style: const TextStyle(
            color: Pallete.blueColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        );
      } else if (e.startsWith('https://') || e.startsWith('www')) {
        return TextSpan(
          text: '$e ',
          style: const TextStyle(
            color: Pallete.blueColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        );
      }
      return TextSpan(
        text: '$e ',
        style: const TextStyle(
          color: Pallete.greyColor,
          fontSize: 18,
        ),
      );
    }).toList();

    return RichText(
      text: TextSpan(
        children: textSpans,
      ),
    );
  }
}
