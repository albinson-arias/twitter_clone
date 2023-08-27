import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:twitter_clone/src/common_models/user_model.dart';
import 'package:twitter_clone/src/constants/appwrite_constants.dart';
import 'package:twitter_clone/src/repositories/repositories.dart';

import '../core/core.dart';
import '../exceptions/app_exception.dart';

final userRepositoryProvider = Provider<IUserRepository>((ref) {
  final repository = UserRepository(ref.watch(databasesProvider));
  return repository;
});

final userDetailsProvider =
    FutureProvider.family<UserModel, String>((ref, id) async {
  final result = await ref.watch(userRepositoryProvider).getUserData(id);
  return result.when(
    (data) => data,
    (error) => throw error,
  );
});

final currentUserDetailsProvider = FutureProvider<UserModel>((ref) {
  final userId = ref.watch(Repositories.auth).currentUser!.$id;
  final result = ref.watch(userDetailsProvider(userId));
  return result.when(
    data: (data) => data,
    loading: () => throw const AsyncLoading(),
    error: (error, _) => throw error,
  );
});

abstract class IUserRepository {
  FutureResultVoid saveUserData(UserModel userModel);
  FutureResult<UserModel> getUserData(String userId);
}

class UserRepository implements IUserRepository {
  final Databases db;

  UserRepository(this.db);

  @override
  FutureResultVoid saveUserData(UserModel userModel) async {
    try {
      await db.createDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.usersCollection,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return const Success(unit);
    } catch (e, stackTrace) {
      return Error(
        AppException.unknown.copyWith(
          stackTrace: stackTrace,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  FutureResult<UserModel> getUserData(String userId) async {
    try {
      final response = await db.getDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.usersCollection,
        documentId: userId,
      );
      return Success(UserModel.fromMap(response.data));
    } catch (e, stackTrace) {
      return Error(
        AppException.unknown.copyWith(
          stackTrace: stackTrace,
          message: e.toString(),
        ),
      );
    }
  }
}
