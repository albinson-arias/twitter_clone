import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/src/common_models/tweet_model.dart';
import 'package:twitter_clone/src/common_widgets/async_value_widgets.dart';
import 'package:twitter_clone/src/features/tweet/widgets/tweet_card.dart';

import '../controllers/tweet_list_controller.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(tweetListControllerProvider);
    return AsyncValueWidget<List<Tweet>>(
      value: value,
      data: (tweets) {
        return ListView.builder(
          itemCount: tweets.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final tweet = tweets[index];
            return TweetCard(tweet: tweet);
          },
        );
      },
    );
  }
}
