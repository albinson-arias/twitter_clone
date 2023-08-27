import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/src/common_widgets/async_value_widgets.dart';
import 'package:twitter_clone/src/core/core.dart';
import 'package:twitter_clone/src/exceptions/exceptions.dart';
import 'package:twitter_clone/src/features/tweet/controllers/reply_tweets_controller.dart';
import 'package:twitter_clone/src/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/src/l10n/app_localizations_context.dart';
import 'package:twitter_clone/src/theme/palette.dart';

import '../../../common_models/tweet_model.dart';
import '../controllers/tweet_controller.dart';

class TweetReplyScreen extends ConsumerStatefulWidget {
  const TweetReplyScreen({super.key, required this.tweet});
  final Tweet tweet;

  @override
  ConsumerState<TweetReplyScreen> createState() => _TweetReplyScreenState();
}

class _TweetReplyScreenState extends ConsumerState<TweetReplyScreen> {
  final replyController = TextEditingController();

  @override
  void dispose() {
    replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      tweetControllerProvider,
      (_, next) {
        if (next is AsyncError) {
          showSnackBar(context,
              getLocalizedErrorMessage(context, next.error as AppException));
        } else if (next is AsyncData) {
          replyController.clear();
        }
      },
    );

    final value =
        ref.watch(repliedTweetListControllerProvider(widget.tweet.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.tweet),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              TweetCard(tweet: widget.tweet),
              AsyncValueWidget<List<Tweet>>(
                value: value,
                data: (data) => Column(
                  children: data.map((e) => TweetCard(tweet: e)).toList(),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Pallete.greyColor,
                    width: 0.5,
                  ),
                ),
                color: Pallete.backgroundColor,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 10.0,
                ),
                child: TextField(
                  controller: replyController,
                  onSubmitted: (value) async {
                    await ref.read(tweetControllerProvider.notifier).shareTweet(
                        images: [], text: value, replyTo: widget.tweet.id);
                  },
                  decoration: InputDecoration(
                    hintText: context.loc.tweetReplyHint,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
