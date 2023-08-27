import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/src/common_models/tweet_model.dart';
import 'package:twitter_clone/src/constants/appwrite_constants.dart';
import 'package:twitter_clone/src/repositories/tweet_repository.dart';

import '../../../repositories/repositories.dart';

final tweetListControllerProvider =
    StateNotifierProvider<TweetListController, AsyncValue<List<Tweet>>>((ref) {
  final tweetRepository = ref.watch(Repositories.tweet);
  final controller = TweetListController(tweetRepository: tweetRepository);
  controller.loadInitialData();
  return controller;
});

class TweetListController extends StateNotifier<AsyncValue<List<Tweet>>> {
  TweetListController({required ITweetRepository tweetRepository})
      : _tweetRepository = tweetRepository,
        super(const AsyncData([]));

  final ITweetRepository _tweetRepository;

  void getTweets() async {
    state = const AsyncLoading();
    final tweets = await _tweetRepository.getTweets();
    tweets.when(
      (tweets) {
        state = AsyncData(tweets);
      },
      (error) {
        state = AsyncError(error, StackTrace.current);
      },
    );
    listenToTweets();
  }

  void listenToTweets() {
    _tweetRepository.getLatestTweet().listen((event) {
      // In the event of a new tweet, we add it to the top of the list
      if (event.events.contains(
          'databases.*.collections.${AppWriteConstants.tweetsCollection}.documents.*.create')) {
        final newTweet = Tweet.fromMap(event.payload);
        state = AsyncData([newTweet, ...state.value!]);
        // In the event of a tweet update, we update the tweet in the list
      } else if (event.events.contains(
          'databases.*.collections.${AppWriteConstants.tweetsCollection}.documents.*.update')) {
        final updatedTweet = Tweet.fromMap(event.payload);
        final tweets = state.value!;
        final index =
            tweets.indexWhere((element) => element.id == updatedTweet.id);
        tweets[index] = updatedTweet;
        state = AsyncData(tweets);
      }
    });
  }

  void loadInitialData() {
    getTweets();
  }
}
