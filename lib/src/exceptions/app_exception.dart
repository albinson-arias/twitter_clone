import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_exception.freezed.dart';

@freezed
class AppException with _$AppException {
  /// Constructor.
  const factory AppException({
    /// Code of the exception.
    required String code,

    /// Message of the exception.
    required String message,

    /// Stacktrace of the exception.
    StackTrace? stackTrace,
  }) = _AppException;

  static const AppException usernameAlreadyInUse = AppException(
    code: 'username-already-in-use',
    message: 'Username already in use',
  );

  static const AppException weakPassword = AppException(
    code: 'weak-password',
    message: 'Password is too weak',
  );

  static const AppException wrongPassword = AppException(
    code: 'wrong-password',
    message: 'Password is incorrect',
  );

  static const AppException userNotFound = AppException(
    code: 'user-not-found',
    message: 'User not found',
  );

  static const AppException noNetworkConnectivity = AppException(
    code: 'no-network',
    message:
        'No Internet connection. Please check your connection and try again',
  );

  static const AppException serverError = AppException(
    code: 'server-error',
    message: 'Server error. Please try again later',
  );

  static const AppException unknown = AppException(
    code: 'unknown',
    message: 'Unknown error',
  );

  static const AppException tweetTextEmpty = AppException(
    code: 'tweet-text-empty',
    message: 'Tweet text cannot be empty',
  );
}
