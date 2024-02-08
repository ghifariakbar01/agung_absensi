// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AuthResponse {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(UserModelWithPassword user) withUser,
    required TResult Function(int? errorCode, String? message) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(UserModelWithPassword user)? withUser,
    TResult? Function(int? errorCode, String? message)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(UserModelWithPassword user)? withUser,
    TResult Function(int? errorCode, String? message)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WithUser value) withUser,
    required TResult Function(_Failure value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_WithUser value)? withUser,
    TResult? Function(_Failure value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WithUser value)? withUser,
    TResult Function(_Failure value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthResponseCopyWith<$Res> {
  factory $AuthResponseCopyWith(
          AuthResponse value, $Res Function(AuthResponse) then) =
      _$AuthResponseCopyWithImpl<$Res, AuthResponse>;
}

/// @nodoc
class _$AuthResponseCopyWithImpl<$Res, $Val extends AuthResponse>
    implements $AuthResponseCopyWith<$Res> {
  _$AuthResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_WithUserCopyWith<$Res> {
  factory _$$_WithUserCopyWith(
          _$_WithUser value, $Res Function(_$_WithUser) then) =
      __$$_WithUserCopyWithImpl<$Res>;
  @useResult
  $Res call({UserModelWithPassword user});

  $UserModelWithPasswordCopyWith<$Res> get user;
}

/// @nodoc
class __$$_WithUserCopyWithImpl<$Res>
    extends _$AuthResponseCopyWithImpl<$Res, _$_WithUser>
    implements _$$_WithUserCopyWith<$Res> {
  __$$_WithUserCopyWithImpl(
      _$_WithUser _value, $Res Function(_$_WithUser) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
  }) {
    return _then(_$_WithUser(
      null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModelWithPassword,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $UserModelWithPasswordCopyWith<$Res> get user {
    return $UserModelWithPasswordCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value));
    });
  }
}

/// @nodoc

class _$_WithUser extends _WithUser {
  const _$_WithUser(this.user) : super._();

  @override
  final UserModelWithPassword user;

  @override
  String toString() {
    return 'AuthResponse.withUser(user: $user)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_WithUser &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_WithUserCopyWith<_$_WithUser> get copyWith =>
      __$$_WithUserCopyWithImpl<_$_WithUser>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(UserModelWithPassword user) withUser,
    required TResult Function(int? errorCode, String? message) failure,
  }) {
    return withUser(user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(UserModelWithPassword user)? withUser,
    TResult? Function(int? errorCode, String? message)? failure,
  }) {
    return withUser?.call(user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(UserModelWithPassword user)? withUser,
    TResult Function(int? errorCode, String? message)? failure,
    required TResult orElse(),
  }) {
    if (withUser != null) {
      return withUser(user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WithUser value) withUser,
    required TResult Function(_Failure value) failure,
  }) {
    return withUser(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_WithUser value)? withUser,
    TResult? Function(_Failure value)? failure,
  }) {
    return withUser?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WithUser value)? withUser,
    TResult Function(_Failure value)? failure,
    required TResult orElse(),
  }) {
    if (withUser != null) {
      return withUser(this);
    }
    return orElse();
  }
}

abstract class _WithUser extends AuthResponse {
  const factory _WithUser(final UserModelWithPassword user) = _$_WithUser;
  const _WithUser._() : super._();

  UserModelWithPassword get user;
  @JsonKey(ignore: true)
  _$$_WithUserCopyWith<_$_WithUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_FailureCopyWith<$Res> {
  factory _$$_FailureCopyWith(
          _$_Failure value, $Res Function(_$_Failure) then) =
      __$$_FailureCopyWithImpl<$Res>;
  @useResult
  $Res call({int? errorCode, String? message});
}

/// @nodoc
class __$$_FailureCopyWithImpl<$Res>
    extends _$AuthResponseCopyWithImpl<$Res, _$_Failure>
    implements _$$_FailureCopyWith<$Res> {
  __$$_FailureCopyWithImpl(_$_Failure _value, $Res Function(_$_Failure) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errorCode = freezed,
    Object? message = freezed,
  }) {
    return _then(_$_Failure(
      errorCode: freezed == errorCode
          ? _value.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as int?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_Failure extends _Failure {
  const _$_Failure({this.errorCode, this.message}) : super._();

  @override
  final int? errorCode;
  @override
  final String? message;

  @override
  String toString() {
    return 'AuthResponse.failure(errorCode: $errorCode, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Failure &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errorCode, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FailureCopyWith<_$_Failure> get copyWith =>
      __$$_FailureCopyWithImpl<_$_Failure>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(UserModelWithPassword user) withUser,
    required TResult Function(int? errorCode, String? message) failure,
  }) {
    return failure(errorCode, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(UserModelWithPassword user)? withUser,
    TResult? Function(int? errorCode, String? message)? failure,
  }) {
    return failure?.call(errorCode, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(UserModelWithPassword user)? withUser,
    TResult Function(int? errorCode, String? message)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(errorCode, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WithUser value) withUser,
    required TResult Function(_Failure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_WithUser value)? withUser,
    TResult? Function(_Failure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WithUser value)? withUser,
    TResult Function(_Failure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class _Failure extends AuthResponse {
  const factory _Failure({final int? errorCode, final String? message}) =
      _$_Failure;
  const _Failure._() : super._();

  int? get errorCode;
  String? get message;
  @JsonKey(ignore: true)
  _$$_FailureCopyWith<_$_Failure> get copyWith =>
      throw _privateConstructorUsedError;
}
