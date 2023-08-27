import 'package:twitter_clone/src/repositories/storage_repository.dart';
import 'package:twitter_clone/src/repositories/tweet_repository.dart';
import 'package:twitter_clone/src/repositories/user_repository.dart';

import 'auth_repository.dart';

export 'preferences_repository.dart';
export 'auth_repository.dart';

abstract class Repositories {
  static final auth = authRepositoryProvider;
  static final user = userRepositoryProvider;
  static final tweet = tweetRepositoryProvider;
  static final storage = storageRepositoryProvider;
}
