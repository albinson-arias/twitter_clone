import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:twitter_clone/src/core/core.dart';
import 'package:twitter_clone/src/exceptions/app_exception.dart';
import 'package:twitter_clone/src/repositories/repositories.dart';
import 'package:twitter_clone/src/repositories/user_repository.dart';

import '../../../common_models/user_model.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(
    ref.watch(Repositories.auth),
    ref.watch(Repositories.user),
  );
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(IAuthRepository authRepository, IUserRepository userRepository)
      : _authRepository = authRepository,
        _userRepository = userRepository,
        super(const AsyncData(null));
  final IAuthRepository _authRepository;
  final IUserRepository _userRepository;

  FutureResultVoid signUpWithEmailAndPassword(
      String email, String password) async {
    state = const AsyncLoading();
    final accountResult = await _authRepository.signUpWithEmailAndPassword(
      email,
      password,
    );

    if (accountResult.isError()) {
      state = AsyncError<AppException>(
          accountResult.tryGetError()!, StackTrace.current);
      return Error(accountResult.tryGetError()!);
    }

    final userResult = await _userRepository.saveUserData(
      UserModel(
        uid: accountResult.tryGetSuccess()!.$id,
        email: email,
        name: getNameFromEmail(email),
        followers: const [],
        following: const [],
        profilePic: '',
        bio: '',
        bannerPic: '',
        isTwitterBlue: false,
      ),
    );

    return userResult.when(
      (_) {
        state = const AsyncData(null);
        return const Success(unit);
      },
      (e) {
        state = AsyncError<AppException>(e, StackTrace.current);
        return Error(e);
      },
    );
  }

  FutureResultVoid loginWithEmailAndPassword(
      String email, String password) async {
    state = const AsyncLoading();
    final result = await _authRepository.loginWithEmailAndPassword(
      email,
      password,
    );
    return result.when(
      (_) {
        state = const AsyncData(null);
        return const Success(unit);
      },
      (e) {
        state = AsyncError<AppException>(e, StackTrace.current);
        return Error(e);
      },
    );
  }

  FutureResultVoid logout() async {
    return _authRepository.logout();
  }
}
