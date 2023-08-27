import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/src/constants/assets_constants.dart';
import 'package:twitter_clone/src/features/auth/controllers/auth_controller.dart';
import 'package:twitter_clone/src/features/tweet/widgets/tweet_list.dart';
import 'package:twitter_clone/src/theme/palette.dart';

class UiConstants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        colorFilter: const ColorFilter.mode(Pallete.blueColor, BlendMode.srcIn),
        height: 30,
      ),
      centerTitle: true,
    );
  }

  static List<Widget> bottomTabBarPages = [
    const TweetList(),
    const Center(child: Text('Search Screen')),
    const Center(child: Text('Notification Screen')),
  ];
}
