import 'dart:async';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:twitter_clone/src/core/core.dart';
import 'package:twitter_clone/src/exceptions/app_exception.dart';
import 'package:twitter_clone/src/l10n/app_localizations_context.dart';
import 'package:rxdart/rxdart.dart';

/// A function to show a snackbar with a message
void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

/// A function to validate the email field
/// and return a localized error message
String? validateEmail(BuildContext context, String? email) {
  if (email == null || email.isEmpty) {
    return context.loc.emailAddressRequired;
  }
  if (!email.contains(RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'))) {
    return context.loc.emailAddressInvalid;
  }
  return null;
}

/// A function to validate the password field
/// and return a localized error message
String? validatePassword(BuildContext context, String? password) {
  if (password == null || password.isEmpty) {
    return context.loc.passwordRequired;
  }
  if (password.length < 6) {
    return context.loc.passwordMinLength;
  } else if (password.length > 20) {
    return context.loc.passwordMaxLength;
  }
  return null;
}

extension AppwriteExceptionExtension on AppwriteException {
  /// An extension to convert Appwrite exceptions to AppExceptions
  AppException toAppException() {
    const exceptions = {
      'Connection refused': AppException.serverError,
      'Invalid credentials. Please check the email and password.':
          AppException.wrongPassword,
    };

    return exceptions[message] ??
        AppException.unknown.copyWith(
          code: code?.toString() ?? 'unknown',
          message: message ?? 'Unknown error',
        );
  }
}

/// An in-memory store backed by BehaviorSubject that can be used to
/// store the data.
class InMemoryStore<T> {
  InMemoryStore(T initial) : _subject = BehaviorSubject<T>.seeded(initial);

  /// The BehaviorSubject that holds the data
  final BehaviorSubject<T> _subject;

  /// The output stream that can be used to listen to the data
  Stream<T> get stream => _subject.stream;

  /// A synchronous getter for the current value
  T get value => _subject.value;

  /// A setter for updating the value
  set value(T value) => _subject.add(value);

  /// Don't forget to call this when done
  void close() => _subject.close();
}

/// A [ChangeNotifier] that listens to a [Stream]
/// and notifies its listeners
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// Returns the name from an email address
String getNameFromEmail(String email) {
  return email.split('@')[0];
}

/// Fetches the images from the gallery
/// and returns a list of [File]s
FutureResult<List<File>> pickImages() async {
  try {
    final List<File> images = [];

    final ImagePicker picker = ImagePicker();

    final imageFiles = await picker.pickMultiImage();

    for (final imageFile in imageFiles) {
      images.add(File(imageFile.path));
    }

    return Success(images);
  } catch (e, st) {
    return Error(
      AppException.unknown.copyWith(message: e.toString(), stackTrace: st),
    );
  }
}

/// A function to convert a url to a valid url
String turnToUrl(String url) {
  if (url.startsWith('http://') || url.startsWith('https://')) {
    return url;
  } else {
    return 'http://$url';
  }
}
