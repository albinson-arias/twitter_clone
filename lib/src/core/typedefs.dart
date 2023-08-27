import 'package:multiple_result/multiple_result.dart';

import '../exceptions/app_exception.dart';

/// A [Future] that completes with a [Result] of [AppException] and [T].
typedef FutureResult<T> = Future<Result<T, AppException>>;

/// A [FutureResult] that completes with a [void] value.
typedef FutureResultVoid = FutureResult<Unit>;
