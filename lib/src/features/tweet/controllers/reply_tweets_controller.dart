import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_models/tweet_model.dart';
import '../../../constants/appwrite_constants.dart';
import '../../../repositories/repositories.dart';
import '../../../repositories/tweet_repository.dart';

final repliedTweetListControllerProvider = StateNotifierProvider.autoDispose
    .family<RepliedTweetListController, AsyncValue<List<Tweet>>, String>(
        (ref, id) {
  final tweetRepository = ref.watch(Repositories.tweet);
  final controller =
      RepliedTweetListController(tweetRepository: tweetRepository, tweetId: id);
  controller.loadInitialData();
  return controller;
});

class RepliedTweetListController
    extends StateNotifier<AsyncValue<List<Tweet>>> {
  RepliedTweetListController(
      {required this.tweetId, required ITweetRepository tweetRepository})
      : _tweetRepository = tweetRepository,
        super(const AsyncData([]));

  final ITweetRepository _tweetRepository;
  final String tweetId;

  void getTweets() async {
    state = const AsyncLoading();
    final tweets = await _tweetRepository.getRepliesToTweet(tweetId);
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
        if (newTweet.replyTo == tweetId) {
          state = AsyncData([newTweet, ...state.value!]);
        }
        // In the event of a tweet update, we update the tweet in the list
      } else if (event.events.contains(
          'databases.*.collections.${AppWriteConstants.tweetsCollection}.documents.*.update')) {
        final updatedTweet = Tweet.fromMap(event.payload);
        if (updatedTweet.replyTo != tweetId) {
          return;
        }
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
