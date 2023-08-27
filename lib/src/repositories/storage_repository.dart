import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:twitter_clone/src/constants/appwrite_constants.dart';

import '../core/core.dart';
import '../exceptions/app_exception.dart';

final storageRepositoryProvider = Provider<IStorageRepository>((ref) {
  final storage = ref.watch(storageProvider);
  return StorageRepository(storage);
});

abstract class IStorageRepository {
  FutureResult<List<String>> uploadImages(List<File> images);
}

class StorageRepository implements IStorageRepository {
  final Storage _storage;

  StorageRepository(this._storage);
  @override
  FutureResult<List<String>> uploadImages(List<File> images) async {
    try {
      final List<String> imageLinks = [];

      for (final image in images) {
        final uploadedImage = await _storage.createFile(
          bucketId: AppWriteConstants.imagesBucket,
          fileId: ID.unique(),
          file: InputFile.fromPath(path: image.path),
        );
        imageLinks.add(AppWriteConstants.imageUrl(uploadedImage.$id));
      }

      return Success(imageLinks);
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
