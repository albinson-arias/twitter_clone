import 'package:flutter/material.dart';
import 'package:twitter_clone/src/l10n/app_localizations_context.dart';

import 'app_exception.dart';

String getLocalizedErrorMessage(BuildContext context, AppException exception) {
  final exceptions = {
    'user-not-found': context.loc.invalidUsernameOrPassword,
    'wrong-password': context.loc.invalidUsernameOrPassword,
    'username-already-in-use': context.loc.usernameAlreadyExists,
    'no-network': context.loc.networkRequestFailed,
    'invalid-username': context.loc.invalidUsername,
    'weak-password': context.loc.weakPassword,
    'unknown': context.loc.unknownError,
    'tweet-text-empty': context.loc.tweetTextEmpty,
  };

  return exceptions[exception.code] ?? exception.message;
}
