import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:twitter_clone/src/common_models/user_model.dart';
import 'package:twitter_clone/src/common_widgets/async_value_widgets.dart';
import 'package:twitter_clone/src/common_widgets/rounded_small_button.dart';
import 'package:twitter_clone/src/constants/assets_constants.dart';
import 'package:twitter_clone/src/core/core.dart';
import 'package:twitter_clone/src/exceptions/exceptions.dart';
import 'package:twitter_clone/src/l10n/app_localizations_context.dart';
import 'package:twitter_clone/src/theme/theme.dart';

import '../../../repositories/user_repository.dart';
import '../controllers/tweet_controller.dart';

class CreateTweetScreen extends ConsumerStatefulWidget {
  const CreateTweetScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateTweetScreenState();
}

class _CreateTweetScreenState extends ConsumerState<CreateTweetScreen> {
  final tweetTextController = TextEditingController();
  final List<File> images = [];

  @override
  void dispose() {
    tweetTextController.dispose();
    super.dispose();
  }

  void onPickImages() async {
    final result = await pickImages();
    if (result.isError()) {
      if (mounted) {
        showSnackBar(
            context, getLocalizedErrorMessage(context, result.tryGetError()!));
      }
      return;
    }
    setState(() {
      images.addAll(result.tryGetSuccess()!);
    });
  }

  void shareTweet() async {
    await ref.read(tweetControllerProvider.notifier).shareTweet(
          images: images,
          text: tweetTextController.text,
        );
    if (mounted) {
      ref.read(tweetControllerProvider).whenOrNull(
            error: (error, stackTrace) => showSnackBar(
              context,
              getLocalizedErrorMessage(context, error as AppException),
            ),
            data: (_) => context.pop(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider);
    final isLoading = ref.watch(tweetControllerProvider).isLoading;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.close,
            size: 30,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: RoundedSmallButton(
              label: context.loc.tweet,
              isLoading: currentUser.isLoading || isLoading,
              onPressed: () => shareTweet(),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: AsyncValueWidget<UserModel>(
          value: currentUser,
          data: (userData) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              CachedNetworkImageProvider(userData.profilePic),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: TextField(
                            controller: tweetTextController,
                            maxLines: null,
                            maxLength: 255,
                            style: const TextStyle(fontSize: 22),
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: context.loc.whatHappening,
                              hintStyle: const TextStyle(
                                fontSize: 22,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (images.isNotEmpty)
                    CarouselSlider(
                      items: images
                          .map(
                            (e) => Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Image.file(e),
                            ),
                          )
                          .toList(),
                      options: CarouselOptions(
                        height: 350,
                        enableInfiniteScroll: false,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Pallete.greyColor,
              width: 0.5,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: GestureDetector(
                  onTap: onPickImages,
                  child: SvgPicture.asset(
                    AssetsConstants.galleryIcon,
                    height: 28,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: SvgPicture.asset(
                  AssetsConstants.gifIcon,
                  height: 28,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: SvgPicture.asset(
                  AssetsConstants.emojiIcon,
                  height: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
