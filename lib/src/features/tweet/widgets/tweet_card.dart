import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:like_button/like_button.dart';
import 'package:twitter_clone/src/common_models/user_model.dart';
import 'package:twitter_clone/src/common_widgets/async_value_widgets.dart';
import 'package:twitter_clone/src/constants/assets_constants.dart';
import 'package:twitter_clone/src/core/core.dart';
import 'package:twitter_clone/src/core/enums/tweet_type.dart';
import 'package:twitter_clone/src/exceptions/exceptions.dart';
import 'package:twitter_clone/src/features/tweet/controllers/tweet_controller.dart';
import 'package:twitter_clone/src/features/tweet/widgets/carousel_image.dart';
import 'package:twitter_clone/src/features/tweet/widgets/hashtag_text.dart';
import 'package:twitter_clone/src/features/tweet/widgets/tweet_icon_button.dart';
import 'package:twitter_clone/src/l10n/app_localizations_context.dart';
import 'package:twitter_clone/src/repositories/repositories.dart';
import 'package:twitter_clone/src/repositories/user_repository.dart';
import 'package:twitter_clone/src/routing/app_router.dart';
import 'package:twitter_clone/src/theme/palette.dart';

import '../../../common_models/tweet_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class TweetCard extends ConsumerWidget {
  const TweetCard({
    super.key,
    required this.tweet,
  });
  final Tweet tweet;

  void onRetweet(BuildContext context, WidgetRef ref) async {
    final result =
        await ref.read(tweetControllerProvider.notifier).reshareTweet(tweet);

    result.when(
        (success) => showSnackBar(context, context.loc.retweeted),
        (error) =>
            showSnackBar(context, getLocalizedErrorMessage(context, error)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(userDetailsProvider(tweet.userId));
    return AsyncValueWidget(
      value: value,
      data: (userDetails) {
        return InkWell(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () => context
              .goNamed(AppRoute.tweet.name, pathParameters: {'id': tweet.id}),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(userDetails.profilePic),
                      radius: 35,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (tweet.retweetedBy.isNotEmpty)
                          AsyncValueWidget<UserModel>(
                            value: ref
                                .watch(userDetailsProvider(tweet.retweetedBy)),
                            data: (userData) {
                              return Row(
                                children: [
                                  SvgPicture.asset(
                                    AssetsConstants.retweetIcon,
                                    colorFilter: const ColorFilter.mode(
                                        Pallete.greyColor, BlendMode.srcIn),
                                    width: 20,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${userData.name} ${context.loc.retweeted}',
                                    style: const TextStyle(
                                      color: Pallete.greyColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Text(
                                userDetails.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                ),
                              ),
                            ),
                            Text(
                              '@${userDetails.name} • ${timeago.format(tweet.createdAt, locale: '${ref.watch(localeProvider).languageCode}_short')}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        // replied to
                        HashTagText(text: tweet.text),
                        if (tweet.type == TweetType.image)
                          CarouselImage(imageLinks: tweet.imageLinks),
                        if (tweet.link.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          AnyLinkPreview(
                            displayDirection: UIDirection.uiDirectionHorizontal,
                            link: turnToUrl(tweet.link),
                          )
                        ],
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            right: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TweetIconButton(
                                pathName: AssetsConstants.viewsIcon,
                                text: (tweet.commentIds.length +
                                        tweet.retweetCount +
                                        tweet.likes.length)
                                    .toString(),
                                onPressed: () {},
                              ),
                              TweetIconButton(
                                pathName: AssetsConstants.commentIcon,
                                text: tweet.commentIds.length.toString(),
                                onPressed: () {},
                              ),
                              TweetIconButton(
                                pathName: AssetsConstants.retweetIcon,
                                text: tweet.retweetCount.toString(),
                                onPressed: () => onRetweet(context, ref),
                              ),
                              LikeButton(
                                size: 25,
                                likeCount: tweet.likes.length,
                                isLiked: tweet.likes.contains(ref
                                    .read(Repositories.auth)
                                    .currentUser!
                                    .$id),
                                onTap: (isLiked) => ref
                                    .read(tweetControllerProvider.notifier)
                                    .likeTweet(tweet),
                                countBuilder: (likeCount, isLiked, text) {
                                  return Text(
                                    text,
                                    style: TextStyle(
                                      color: isLiked
                                          ? Pallete.redColor
                                          : Pallete.whiteColor,
                                      fontSize: 17,
                                    ),
                                  );
                                },
                                likeBuilder: (isLiked) {
                                  return isLiked
                                      ? SvgPicture.asset(
                                          AssetsConstants.likeFilledIcon,
                                          colorFilter: const ColorFilter.mode(
                                            Pallete.redColor,
                                            BlendMode.srcIn,
                                          ),
                                        )
                                      : SvgPicture.asset(
                                          AssetsConstants.likeOutlinedIcon,
                                          colorFilter: const ColorFilter.mode(
                                            Pallete.greyColor,
                                            BlendMode.srcIn,
                                          ),
                                        );
                                },
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.share_outlined,
                                  color: Pallete.greyColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 1),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(
                color: Pallete.greyColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
