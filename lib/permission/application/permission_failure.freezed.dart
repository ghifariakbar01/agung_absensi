// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'permission_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PermissionFailure {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) withMessage,
    required TResult Function() unkown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? withMessage,
    TResult? Function()? unkown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? withMessage,
    TResult Function()? unkown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_FailureMessage value) withMessage,
    required TResult Function(_Unknown value) unkown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_FailureMessage value)? withMessage,
    TResult? Function(_Unknown value)? unkown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_FailureMessage value)? withMessage,
    TResult Function(_Unknown value)? unkown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PermissionFailureCopyWith<$Res> {
  factory $PermissionFailureCopyWith(
          PermissionFailure value, $Res Function(PermissionFailure) then) =
      _$PermissionFailureCopyWithImpl<$Res, PermissionFailure>;
}

/// @nodoc
class _$PermissionFailureCopyWithImpl<$Res, $Val extends PermissionFailure>
    implements $PermissionFailureCopyWith<$Res> {
  _$PermissionFailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_FailureMessageCopyWith<$Res> {
  factory _$$_FailureMessageCopyWith(
          _$_FailureMessage value, $Res Function(_$_FailureMessage) then) =
      __$$_FailureMessageCopyWithImpl<$Res>;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$_FailureMessageCopyWithImpl<$Res>
    extends _$PermissionFailureCopyWithImpl<$Res, _$_FailureMessage>
    implements _$$_FailureMessageCopyWith<$Res> {
  __$$_FailureMessageCopyWithImpl(
      _$_FailureMessage _value, $Res Function(_$_FailureMessage) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$_FailureMessage(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_FailureMessage implements _FailureMessage {
  const _$_FailureMessage({this.message});

  @override
  final String? message;

  @override
  String toString() {
    return 'PermissionFailure.withMessage(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FailureMessage &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FailureMessageCopyWith<_$_FailureMessage> get copyWith =>
      __$$_FailureMessageCopyWithImpl<_$_FailureMessage>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) withMessage,
    required TResult Function() unkown,
  }) {
    return withMessage(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? withMessage,
    TResult? Function()? unkown,
  }) {
    return withMessage?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? withMessage,
    TResult Function()? unkown,
    required TResult orElse(),
  }) {
    if (withMessage != null) {
      return withMessage(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_FailureMessage value) withMessage,
    required TResult Function(_Unknown value) unkown,
  }) {
    return withMessage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_FailureMessage value)? withMessage,
    TResult? Function(_Unknown value)? unkown,
  }) {
    return withMessage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_FailureMessage value)? withMessage,
    TResult Function(_Unknown value)? unkown,
    required TResult orElse(),
  }) {
    if (withMessage != null) {
      return withMessage(this);
    }
    return orElse();
  }
}

abstract class _FailureMessage implements PermissionFailure {
  const factory _FailureMessage({final String? message}) = _$_FailureMessage;

  String? get message;
  @JsonKey(ignore: true)
  _$$_FailureMessageCopyWith<_$_FailureMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_UnknownCopyWith<$Res> {
  factory _$$_UnknownCopyWith(
          _$_Unknown value, $Res Function(_$_Unknown) then) =
      __$$_UnknownCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_UnknownCopyWithImpl<$Res>
    extends _$PermissionFailureCopyWithImpl<$Res, _$_Unknown>
    implements _$$_UnknownCopyWith<$Res> {
  __$$_UnknownCopyWithImpl(_$_Unknown _value, $Res Function(_$_Unknown) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_Unknown implements _Unknown {
  const _$_Unknown();

  @override
  String toString() {
    return 'PermissionFailure.unkown()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_Unknown);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) withMessage,
    required TResult Function() unkown,
  }) {
    return unkown();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? withMessage,
    TResult? Function()? unkown,
  }) {
    return unkown?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? withMessage,
    TResult Function()? unkown,
    required TResult orElse(),
  }) {
    if (unkown != null) {
      return unkown();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_FailureMessage value) withMessage,
    required TResult Function(_Unknown value) unkown,
  }) {
    return unkown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_FailureMessage value)? withMessage,
    TResult? Function(_Unknown value)? unkown,
  }) {
    return unkown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_FailureMessage value)? withMessage,
    TResult Function(_Unknown value)? unkown,
    required TResult orElse(),
  }) {
    if (unkown != null) {
      return unkown(this);
    }
    return orElse();
  }
}

abstract class _Unknown implements PermissionFailure {
  const factory _Unknown() = _$_Unknown;
}
