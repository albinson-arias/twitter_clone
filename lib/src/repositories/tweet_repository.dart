import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:twitter_clone/src/common_models/tweet_model.dart';
import 'package:twitter_clone/src/constants/appwrite_constants.dart';
import 'package:twitter_clone/src/core/core.dart';

import '../exceptions/app_exception.dart';

final tweetRepositoryProvider = Provider<ITweetRepository>((ref) {
  final databases = ref.watch(databasesProvider);
  final realtime = ref.watch(realtimeProvider);
  final repository = TweetRepository(databases, realtime);
  return repository;
});

final getTweetsProvider = FutureProvider<List<Tweet>>(
  (ref) async {
    final repository = ref.watch(tweetRepositoryProvider);
    final result = await repository.getTweets();
    return result.when(
      (data) => data,
      (e) => throw e,
    );
  },
);

final getTweetProvider =
    FutureProvider.autoDispose.family<Tweet, String>((ref, id) async {
  final repository = ref.watch(tweetRepositoryProvider);
  final result = await repository.getTweet(id);
  return result.when(
    (data) => data,
    (e) => throw e,
  );
});

final getLatestTweetProvider = StreamProvider<RealtimeMessage>((ref) {
  final repository = ref.watch(tweetRepositoryProvider);
  return repository.getLatestTweet();
});

abstract class ITweetRepository {
  FutureResult<Tweet> shareTweet(Tweet tweet);
  FutureResult<List<Tweet>> getTweets();
  FutureResult<Tweet> getTweet(String tweetId);
  Stream<RealtimeMessage> getLatestTweet();
  FutureResult<Tweet> likeTweet(Tweet tweet);
  FutureResult<Tweet> updateRetweetCount(Tweet tweet);
  FutureResult<List<Tweet>> getRepliesToTweet(String tweetId);
}

class TweetRepository implements ITweetRepository {
  final Databases _db;
  final Realtime _realtime;

  TweetRepository(this._db, this._realtime);

  @override
  FutureResult<Tweet> shareTweet(Tweet tweet) async {
    try {
      final result = await _db.createDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetsCollection,
        documentId: ID.unique(),
        data: tweet.toMap(),
      );

      return Success(Tweet.fromMap(result.data));
    } on AppwriteException catch (e, st) {
      return Error(
        e.toAppException().copyWith(
              stackTrace: st,
            ),
      );
    } catch (e, st) {
      return Error(
        AppException.unknown.copyWith(
          message: e.toString(),
          stackTrace: st,
        ),
      );
    }
  }

  @override
  FutureResult<List<Tweet>> getTweets() async {
    try {
      final documents = await _db.listDocuments(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetsCollection,
        queries: [
          Query.orderDesc('\$createdAt'),
        ],
      );
      return Success(
          documents.documents.map((e) => Tweet.fromMap(e.data)).toList());
    } on AppwriteException catch (e, st) {
      return Error(
        e.toAppException().copyWith(
              stackTrace: st,
            ),
      );
    } catch (e, st) {
      return Error(
        AppException.unknown.copyWith(
          message: e.toString(),
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Stream<RealtimeMessage> getLatestTweet() {
    return _realtime.subscribe([
      'databases.${AppWriteConstants.databaseId}.collections.${AppWriteConstants.tweetsCollection}.documents'
    ]).stream;
  }

  @override
  FutureResult<Tweet> likeTweet(Tweet tweet) async {
    try {
      final result = await _db.updateDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetsCollection,
        documentId: tweet.id,
        data: {
          'likes': tweet.likes,
        },
      );

      return Success(Tweet.fromMap(result.data));
    } on AppwriteException catch (e, st) {
      return Error(
        e.toAppException().copyWith(
              stackTrace: st,
            ),
      );
    } catch (e, st) {
      return Error(
        AppException.unknown.copyWith(
          message: e.toString(),
          stackTrace: st,
        ),
      );
    }
  }

  @override
  FutureResult<Tweet> updateRetweetCount(Tweet tweet) async {
    try {
      final result = await _db.updateDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetsCollection,
        documentId: tweet.id,
        data: {
          'retweetCount': tweet.retweetCount,
        },
      );

      return Success(Tweet.fromMap(result.data));
    } on AppwriteException catch (e, st) {
      return Error(
        e.toAppException().copyWith(
              stackTrace: st,
            ),
      );
    } catch (e, st) {
      return Error(
        AppException.unknown.copyWith(
          message: e.toString(),
          stackTrace: st,
        ),
      );
    }
  }

  @override
  FutureResult<Tweet> getTweet(String tweetId) async {
    try {
      final result = await _db.getDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetsCollection,
        documentId: tweetId,
      );

      return Success(Tweet.fromMap(result.data));
    } on AppwriteException catch (e, st) {
      return Error(
        e.toAppException().copyWith(
              stackTrace: st,
            ),
      );
    } catch (e, st) {
      return Error(
        AppException.unknown.copyWith(
          message: e.toString(),
          stackTrace: st,
        ),
      );
    }
  }

  @override
  FutureResult<List<Tweet>> getRepliesToTweet(String tweetId) async {
    try {
      final documents = await _db.listDocuments(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetsCollection,
        queries: [
          Query.orderDesc('\$createdAt'),
          Query.equal('replyTo', tweetId),
        ],
      );
      return Success(
          documents.documents.map((e) => Tweet.fromMap(e.data)).toList());
    } on AppwriteException catch (e, st) {
      return Error(
        e.toAppException().copyWith(
              stackTrace: st,
            ),
      );
    } catch (e, st) {
      return Error(
        AppException.unknown.copyWith(
          message: e.toString(),
          stackTrace: st,
        ),
      );
    }
  }
}
