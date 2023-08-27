// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AppException {
  /// Code of the exception.
  String get code => throw _privateConstructorUsedError;

  /// Message of the exception.
  String get message => throw _privateConstructorUsedError;

  /// Stacktrace of the exception.
  StackTrace? get stackTrace => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppExceptionCopyWith<AppException> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppExceptionCopyWith<$Res> {
  factory $AppExceptionCopyWith(
          AppException value, $Res Function(AppException) then) =
      _$AppExceptionCopyWithImpl<$Res, AppException>;
  @useResult
  $Res call({String code, String message, StackTrace? stackTrace});
}

/// @nodoc
class _$AppExceptionCopyWithImpl<$Res, $Val extends AppException>
    implements $AppExceptionCopyWith<$Res> {
  _$AppExceptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
    Object? stackTrace = freezed,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      stackTrace: freezed == stackTrace
          ? _value.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AppExceptionCopyWith<$Res>
    implements $AppExceptionCopyWith<$Res> {
  factory _$$_AppExceptionCopyWith(
          _$_AppException value, $Res Function(_$_AppException) then) =
      __$$_AppExceptionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String code, String message, StackTrace? stackTrace});
}

/// @nodoc
class __$$_AppExceptionCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$_AppException>
    implements _$$_AppExceptionCopyWith<$Res> {
  __$$_AppExceptionCopyWithImpl(
      _$_AppException _value, $Res Function(_$_AppException) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
    Object? stackTrace = freezed,
  }) {
    return _then(_$_AppException(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      stackTrace: freezed == stackTrace
          ? _value.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ));
  }
}

/// @nodoc

class _$_AppException implements _AppException {
  const _$_AppException(
      {required this.code, required this.message, this.stackTrace});

  /// Code of the exception.
  @override
  final String code;

  /// Message of the exception.
  @override
  final String message;

  /// Stacktrace of the exception.
  @override
  final StackTrace? stackTrace;

  @override
  String toString() {
    return 'AppException(code: $code, message: $message, stackTrace: $stackTrace)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AppException &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, message, stackTrace);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AppExceptionCopyWith<_$_AppException> get copyWith =>
      __$$_AppExceptionCopyWithImpl<_$_AppException>(this, _$identity);
}

abstract class _AppException implements AppException {
  const factory _AppException(
      {required final String code,
      required final String message,
      final StackTrace? stackTrace}) = _$_AppException;

  @override

  /// Code of the exception.
  String get code;
  @override

  /// Message of the exception.
  String get message;
  @override

  /// Stacktrace of the exception.
  StackTrace? get stackTrace;
  @override
  @JsonKey(ignore: true)
  _$$_AppExceptionCopyWith<_$_AppException> get copyWith =>
      throw _privateConstructorUsedError;
}
