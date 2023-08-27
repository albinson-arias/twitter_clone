import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:twitter_clone/src/core/core.dart';
import 'package:twitter_clone/src/exceptions/exceptions.dart';
import 'package:twitter_clone/src/repositories/repositories.dart';
import 'package:twitter_clone/src/repositories/storage_repository.dart';
import 'package:twitter_clone/src/repositories/tweet_repository.dart';

import '../../../common_models/tweet_model.dart';
import '../../../core/enums/tweet_type.dart';

final tweetControllerProvider =
    StateNotifierProvider<TweetController, AsyncValue<void>>((ref) {
  final userId = ref.watch(Repositories.auth).currentUser!.$id;
  final tweetRepository = ref.watch(Repositories.tweet);
  final storageRepository = ref.watch(Repositories.storage);
  return TweetController(
    userId: userId,
    tweetRepository: tweetRepository,
    storageRepository: storageRepository,
  );
});

class TweetController extends StateNotifier<AsyncValue<void>> {
  TweetController({
    required String userId,
    required ITweetRepository tweetRepository,
    required IStorageRepository storageRepository,
  })  : _userId = userId,
        _storageRepository = storageRepository,
        _tweetRepository = tweetRepository,
        super(const AsyncData(null));
  final ITweetRepository _tweetRepository;
  final IStorageRepository _storageRepository;
  final String _userId;

  Future<void> shareTweet({
    required List<File> images,
    required String text,
    String? replyTo,
  }) async {
    state = const AsyncLoading();
    if (text.isEmpty) {
      state = AsyncError(AppException.tweetTextEmpty, StackTrace.current);
    }

    if (images.isNotEmpty) {
      await _shareTweetWithImages(images: images, text: text, replyTo: replyTo);
    } else {
      await _shareTextTweet(text: text, replyTo: replyTo);
    }
  }

  Future<void> _shareTweetWithImages(
      {required List<File> images,
      required String text,
      String? replyTo}) async {
    final link = _getLinkFromText(text);
    final hashTags = _getHashTagsFromText(text);
    final imageLinks = await _storageRepository.uploadImages(images);
    if (imageLinks.isError()) {
      state = AsyncError(imageLinks.tryGetError()!, StackTrace.current);
      return;
    }
    final tweet = Tweet(
      id: '',
      text: text,
      hashTags: hashTags,
      link: link,
      imageLinks: imageLinks.tryGetSuccess()!,
      userId: _userId,
      type: TweetType.image,
      createdAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      retweetCount: 0,
      retweetedBy: '',
      replyTo: replyTo ?? '',
    );
    final result = await _tweetRepository.shareTweet(tweet);

    result.when(
      (value) {
        state = const AsyncData(null);
      },
      (error) {
        state = AsyncError(error, StackTrace.current);
      },
    );
  }

  Future<void> _shareTextTweet({required String text, String? replyTo}) async {
    final link = _getLinkFromText(text);
    final hashTags = _getHashTagsFromText(text);
    final tweet = Tweet(
      id: '',
      text: text,
      hashTags: hashTags,
      link: link,
      imageLinks: const [],
      userId: _userId,
      type: TweetType.text,
      createdAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      retweetCount: 0,
      retweetedBy: '',
      replyTo: replyTo ?? '',
    );
    final result = await _tweetRepository.shareTweet(tweet);

    result.when(
      (value) {
        state = const AsyncData(null);
      },
      (error) {
        state = AsyncError(error, StackTrace.current);
      },
    );
  }

  String _getLinkFromText(String text) {
    final link = text.split(' ').firstWhere(
      (element) {
        return element.startsWith('http') ||
            element.startsWith('www') ||
            element.startsWith('https');
      },
      orElse: () => '',
    );
    return link;
  }

  List<String> _getHashTagsFromText(String text) {
    final hashTags = text.split(' ').where((element) {
      return element.startsWith('#');
    }).toList();
    return hashTags;
  }

  Future<bool> likeTweet(Tweet tweet) async {
    final List<String> likes = tweet.likes;

    if (likes.contains(_userId)) {
      likes.remove(_userId);
    } else {
      likes.add(_userId);
    }

    final result =
        await _tweetRepository.likeTweet(tweet.copyWith(likes: likes));
    return result.when((success) => true, (error) => false);
  }

  FutureResultVoid reshareTweet(Tweet tweet) async {
    final retweet = tweet.copyWith(
      retweetedBy: _userId,
      likes: [],
      commentIds: [],
      retweetCount: tweet.retweetCount + 1,
    );

    final retweetCountResult =
        await _tweetRepository.updateRetweetCount(retweet);

    if (retweetCountResult.isError()) {
      return Error(retweetCountResult.tryGetError()!);
    }

    final result = await _tweetRepository.shareTweet(
      retweet.copyWith(
        id: ID.unique(),
        retweetCount: 0,
        createdAt: DateTime.now(),
      ),
    );

    return result.when(
      (success) => const Success(unit),
      (error) => Error(error),
    );
  }
}
