// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geofence_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GeofenceFailure {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int? errorCode, String? message) server,
    required TResult Function() passwordExpired,
    required TResult Function() wrongFormat,
    required TResult Function() noConnection,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int? errorCode, String? message)? server,
    TResult? Function()? passwordExpired,
    TResult? Function()? wrongFormat,
    TResult? Function()? noConnection,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int? errorCode, String? message)? server,
    TResult Function()? passwordExpired,
    TResult Function()? wrongFormat,
    TResult Function()? noConnection,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Server value) server,
    required TResult Function(_PasswordExpired value) passwordExpired,
    required TResult Function(_WrongFormat value) wrongFormat,
    required TResult Function(_NoConnection value) noConnection,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Server value)? server,
    TResult? Function(_PasswordExpired value)? passwordExpired,
    TResult? Function(_WrongFormat value)? wrongFormat,
    TResult? Function(_NoConnection value)? noConnection,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Server value)? server,
    TResult Function(_PasswordExpired value)? passwordExpired,
    TResult Function(_WrongFormat value)? wrongFormat,
    TResult Function(_NoConnection value)? noConnection,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeofenceFailureCopyWith<$Res> {
  factory $GeofenceFailureCopyWith(
          GeofenceFailure value, $Res Function(GeofenceFailure) then) =
      _$GeofenceFailureCopyWithImpl<$Res, GeofenceFailure>;
}

/// @nodoc
class _$GeofenceFailureCopyWithImpl<$Res, $Val extends GeofenceFailure>
    implements $GeofenceFailureCopyWith<$Res> {
  _$GeofenceFailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_ServerCopyWith<$Res> {
  factory _$$_ServerCopyWith(_$_Server value, $Res Function(_$_Server) then) =
      __$$_ServerCopyWithImpl<$Res>;
  @useResult
  $Res call({int? errorCode, String? message});
}

/// @nodoc
class __$$_ServerCopyWithImpl<$Res>
    extends _$GeofenceFailureCopyWithImpl<$Res, _$_Server>
    implements _$$_ServerCopyWith<$Res> {
  __$$_ServerCopyWithImpl(_$_Server _value, $Res Function(_$_Server) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errorCode = freezed,
    Object? message = freezed,
  }) {
    return _then(_$_Server(
      freezed == errorCode
          ? _value.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_Server implements _Server {
  const _$_Server([this.errorCode, this.message]);

  @override
  final int? errorCode;
  @override
  final String? message;

  @override
  String toString() {
    return 'GeofenceFailure.server(errorCode: $errorCode, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Server &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errorCode, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ServerCopyWith<_$_Server> get copyWith =>
      __$$_ServerCopyWithImpl<_$_Server>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int? errorCode, String? message) server,
    required TResult Function() passwordExpired,
    required TResult Function() wrongFormat,
    required TResult Function() noConnection,
  }) {
    return server(errorCode, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int? errorCode, String? message)? server,
    TResult? Function()? passwordExpired,
    TResult? Function()? wrongFormat,
    TResult? Function()? noConnection,
  }) {
    return server?.call(errorCode, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int? errorCode, String? message)? server,
    TResult Function()? passwordExpired,
    TResult Function()? wrongFormat,
    TResult Function()? noConnection,
    required TResult orElse(),
  }) {
    if (server != null) {
      return server(errorCode, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Server value) server,
    required TResult Function(_PasswordExpired value) passwordExpired,
    required TResult Function(_WrongFormat value) wrongFormat,
    required TResult Function(_NoConnection value) noConnection,
  }) {
    return server(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Server value)? server,
    TResult? Function(_PasswordExpired value)? passwordExpired,
    TResult? Function(_WrongFormat value)? wrongFormat,
    TResult? Function(_NoConnection value)? noConnection,
  }) {
    return server?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Server value)? server,
    TResult Function(_PasswordExpired value)? passwordExpired,
    TResult Function(_WrongFormat value)? wrongFormat,
    TResult Function(_NoConnection value)? noConnection,
    required TResult orElse(),
  }) {
    if (server != null) {
      return server(this);
    }
    return orElse();
  }
}

abstract class _Server implements GeofenceFailure {
  const factory _Server([final int? errorCode, final String? message]) =
      _$_Server;

  int? get errorCode;
  String? get message;
  @JsonKey(ignore: true)
  _$$_ServerCopyWith<_$_Server> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_PasswordExpiredCopyWith<$Res> {
  factory _$$_PasswordExpiredCopyWith(
          _$_PasswordExpired value, $Res Function(_$_PasswordExpired) then) =
      __$$_PasswordExpiredCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_PasswordExpiredCopyWithImpl<$Res>
    extends _$GeofenceFailureCopyWithImpl<$Res, _$_PasswordExpired>
    implements _$$_PasswordExpiredCopyWith<$Res> {
  __$$_PasswordExpiredCopyWithImpl(
      _$_PasswordExpired _value, $Res Function(_$_PasswordExpired) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_PasswordExpired implements _PasswordExpired {
  const _$_PasswordExpired();

  @override
  String toString() {
    return 'GeofenceFailure.passwordExpired()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_PasswordExpired);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int? errorCode, String? message) server,
    required TResult Function() passwordExpired,
    required TResult Function() wrongFormat,
    required TResult Function() noConnection,
  }) {
    return passwordExpired();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int? errorCode, String? message)? server,
    TResult? Function()? passwordExpired,
    TResult? Function()? wrongFormat,
    TResult? Function()? noConnection,
  }) {
    return passwordExpired?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int? errorCode, String? message)? server,
    TResult Function()? passwordExpired,
    TResult Function()? wrongFormat,
    TResult Function()? noConnection,
    required TResult orElse(),
  }) {
    if (passwordExpired != null) {
      return passwordExpired();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Server value) server,
    required TResult Function(_PasswordExpired value) passwordExpired,
    required TResult Function(_WrongFormat value) wrongFormat,
    required TResult Function(_NoConnection value) noConnection,
  }) {
    return passwordExpired(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Server value)? server,
    TResult? Function(_PasswordExpired value)? passwordExpired,
    TResult? Function(_WrongFormat value)? wrongFormat,
    TResult? Function(_NoConnection value)? noConnection,
  }) {
    return passwordExpired?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Server value)? server,
    TResult Function(_PasswordExpired value)? passwordExpired,
    TResult Function(_WrongFormat value)? wrongFormat,
    TResult Function(_NoConnection value)? noConnection,
    required TResult orElse(),
  }) {
    if (passwordExpired != null) {
      return passwordExpired(this);
    }
    return orElse();
  }
}

abstract class _PasswordExpired implements GeofenceFailure {
  const factory _PasswordExpired() = _$_PasswordExpired;
}

/// @nodoc
abstract class _$$_WrongFormatCopyWith<$Res> {
  factory _$$_WrongFormatCopyWith(
          _$_WrongFormat value, $Res Function(_$_WrongFormat) then) =
      __$$_WrongFormatCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_WrongFormatCopyWithImpl<$Res>
    extends _$GeofenceFailureCopyWithImpl<$Res, _$_WrongFormat>
    implements _$$_WrongFormatCopyWith<$Res> {
  __$$_WrongFormatCopyWithImpl(
      _$_WrongFormat _value, $Res Function(_$_WrongFormat) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_WrongFormat implements _WrongFormat {
  const _$_WrongFormat();

  @override
  String toString() {
    return 'GeofenceFailure.wrongFormat()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_WrongFormat);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int? errorCode, String? message) server,
    required TResult Function() passwordExpired,
    required TResult Function() wrongFormat,
    required TResult Function() noConnection,
  }) {
    return wrongFormat();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int? errorCode, String? message)? server,
    TResult? Function()? passwordExpired,
    TResult? Function()? wrongFormat,
    TResult? Function()? noConnection,
  }) {
    return wrongFormat?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int? errorCode, String? message)? server,
    TResult Function()? passwordExpired,
    TResult Function()? wrongFormat,
    TResult Function()? noConnection,
    required TResult orElse(),
  }) {
    if (wrongFormat != null) {
      return wrongFormat();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Server value) server,
    required TResult Function(_PasswordExpired value) passwordExpired,
    required TResult Function(_WrongFormat value) wrongFormat,
    required TResult Function(_NoConnection value) noConnection,
  }) {
    return wrongFormat(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Server value)? server,
    TResult? Function(_PasswordExpired value)? passwordExpired,
    TResult? Function(_WrongFormat value)? wrongFormat,
    TResult? Function(_NoConnection value)? noConnection,
  }) {
    return wrongFormat?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Server value)? server,
    TResult Function(_PasswordExpired value)? passwordExpired,
    TResult Function(_WrongFormat value)? wrongFormat,
    TResult Function(_NoConnection value)? noConnection,
    required TResult orElse(),
  }) {
    if (wrongFormat != null) {
      return wrongFormat(this);
    }
    return orElse();
  }
}

abstract class _WrongFormat implements GeofenceFailure {
  const factory _WrongFormat() = _$_WrongFormat;
}

/// @nodoc
abstract class _$$_NoConnectionCopyWith<$Res> {
  factory _$$_NoConnectionCopyWith(
          _$_NoConnection value, $Res Function(_$_NoConnection) then) =
      __$$_NoConnectionCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_NoConnectionCopyWithImpl<$Res>
    extends _$GeofenceFailureCopyWithImpl<$Res, _$_NoConnection>
    implements _$$_NoConnectionCopyWith<$Res> {
  __$$_NoConnectionCopyWithImpl(
      _$_NoConnection _value, $Res Function(_$_NoConnection) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_NoConnection implements _NoConnection {
  const _$_NoConnection();

  @override
  String toString() {
    return 'GeofenceFailure.noConnection()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_NoConnection);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int? errorCode, String? message) server,
    required TResult Function() passwordExpired,
    required TResult Function() wrongFormat,
    required TResult Function() noConnection,
  }) {
    return noConnection();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int? errorCode, String? message)? server,
    TResult? Function()? passwordExpired,
    TResult? Function()? wrongFormat,
    TResult? Function()? noConnection,
  }) {
    return noConnection?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int? errorCode, String? message)? server,
    TResult Function()? passwordExpired,
    TResult Function()? wrongFormat,
    TResult Function()? noConnection,
    required TResult orElse(),
  }) {
    if (noConnection != null) {
      return noConnection();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Server value) server,
    required TResult Function(_PasswordExpired value) passwordExpired,
    required TResult Function(_WrongFormat value) wrongFormat,
    required TResult Function(_NoConnection value) noConnection,
  }) {
    return noConnection(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Server value)? server,
    TResult? Function(_PasswordExpired value)? passwordExpired,
    TResult? Function(_WrongFormat value)? wrongFormat,
    TResult? Function(_NoConnection value)? noConnection,
  }) {
    return noConnection?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Server value)? server,
    TResult Function(_PasswordExpired value)? passwordExpired,
    TResult Function(_WrongFormat value)? wrongFormat,
    TResult Function(_NoConnection value)? noConnection,
    required TResult orElse(),
  }) {
    if (noConnection != null) {
      return noConnection(this);
    }
    return orElse();
  }
}

abstract class _NoConnection implements GeofenceFailure {
  const factory _NoConnection() = _$_NoConnection;
}
