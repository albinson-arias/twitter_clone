import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/src/theme/theme.dart';

class TweetIconButton extends StatelessWidget {
  const TweetIconButton(
      {super.key,
      required this.pathName,
      required this.text,
      required this.onPressed});
  final String pathName;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          SvgPicture.asset(
            pathName,
            colorFilter: const ColorFilter.mode(
              Pallete.greyColor,
              BlendMode.srcIn,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
