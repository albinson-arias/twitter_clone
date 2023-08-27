import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';

import '../core/core.dart';
import '../exceptions/app_exception.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final account = ref.watch(accountProvider);
  return AuthRepository(account);
});

abstract class IAuthRepository {
  Stream<User?> authStateChanges();
  User? get currentUser;
  FutureResult<User> signUpWithEmailAndPassword(
    String email,
    String password,
  );
  FutureResult<Session> loginWithEmailAndPassword(
    String email,
    String password,
  );
  FutureResultVoid logout();
  FutureResultVoid signInWithStoredCredentials();
}

class AuthRepository implements IAuthRepository {
  final _authState = InMemoryStore<User?>(null);
  final Account _account;

  AuthRepository(this._account);

  @override
  FutureResult<User> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      final account = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );

      await _account.createEmailSession(email: email, password: password);

      _authState.value = await _account.get();
      return Result.success(account);
    } on AppwriteException catch (e, stackTrace) {
      return Result.error(
        e.toAppException().copyWith(
              stackTrace: stackTrace,
            ),
      );
    } catch (e, stackTrace) {
      return Result.error(
        AppException.unknown.copyWith(
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  FutureResult<Session> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final session = await _account.createEmailSession(
        email: email,
        password: password,
      );

      _authState.value = await _account.get();

      return Result.success(session);
    } on AppwriteException catch (e, stackTrace) {
      return Result.error(
        e.toAppException().copyWith(
              stackTrace: stackTrace,
            ),
      );
    } catch (e, stackTrace) {
      return Error(
        AppException.unknown.copyWith(
          message: e.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  FutureResultVoid logout() async {
    try {
      await _account.deleteSessions();
      _authState.value = null;
      return const Success(unit);
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
  Stream<User?> authStateChanges() => _authState.stream;

  @override
  User? get currentUser => _authState.value;

  @override
  FutureResultVoid signInWithStoredCredentials() async {
    try {
      final result = await _account.get();

      _authState.value = result;
      return const Success(unit);
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
