// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'password_expired_notifier_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PasswordExpiredNotifierState {
  bool get isExpired => throw _privateConstructorUsedError;
  Option<Either<PasswordExpiredFailure, Unit>> get failureOrSuccessOption =>
      throw _privateConstructorUsedError;
  Option<Either<PasswordExpiredFailure, Unit>>
      get failureOrSuccessOptionClear => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PasswordExpiredNotifierStateCopyWith<PasswordExpiredNotifierState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordExpiredNotifierStateCopyWith<$Res> {
  factory $PasswordExpiredNotifierStateCopyWith(
          PasswordExpiredNotifierState value,
          $Res Function(PasswordExpiredNotifierState) then) =
      _$PasswordExpiredNotifierStateCopyWithImpl<$Res,
          PasswordExpiredNotifierState>;
  @useResult
  $Res call(
      {bool isExpired,
      Option<Either<PasswordExpiredFailure, Unit>> failureOrSuccessOption,
      Option<Either<PasswordExpiredFailure, Unit>>
          failureOrSuccessOptionClear});
}

/// @nodoc
class _$PasswordExpiredNotifierStateCopyWithImpl<$Res,
        $Val extends PasswordExpiredNotifierState>
    implements $PasswordExpiredNotifierStateCopyWith<$Res> {
  _$PasswordExpiredNotifierStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isExpired = null,
    Object? failureOrSuccessOption = null,
    Object? failureOrSuccessOptionClear = null,
  }) {
    return _then(_value.copyWith(
      isExpired: null == isExpired
          ? _value.isExpired
          : isExpired // ignore: cast_nullable_to_non_nullable
              as bool,
      failureOrSuccessOption: null == failureOrSuccessOption
          ? _value.failureOrSuccessOption
          : failureOrSuccessOption // ignore: cast_nullable_to_non_nullable
              as Option<Either<PasswordExpiredFailure, Unit>>,
      failureOrSuccessOptionClear: null == failureOrSuccessOptionClear
          ? _value.failureOrSuccessOptionClear
          : failureOrSuccessOptionClear // ignore: cast_nullable_to_non_nullable
              as Option<Either<PasswordExpiredFailure, Unit>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PasswordExpiredNotifierStateCopyWith<$Res>
    implements $PasswordExpiredNotifierStateCopyWith<$Res> {
  factory _$$_PasswordExpiredNotifierStateCopyWith(
          _$_PasswordExpiredNotifierState value,
          $Res Function(_$_PasswordExpiredNotifierState) then) =
      __$$_PasswordExpiredNotifierStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isExpired,
      Option<Either<PasswordExpiredFailure, Unit>> failureOrSuccessOption,
      Option<Either<PasswordExpiredFailure, Unit>>
          failureOrSuccessOptionClear});
}

/// @nodoc
class __$$_PasswordExpiredNotifierStateCopyWithImpl<$Res>
    extends _$PasswordExpiredNotifierStateCopyWithImpl<$Res,
        _$_PasswordExpiredNotifierState>
    implements _$$_PasswordExpiredNotifierStateCopyWith<$Res> {
  __$$_PasswordExpiredNotifierStateCopyWithImpl(
      _$_PasswordExpiredNotifierState _value,
      $Res Function(_$_PasswordExpiredNotifierState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isExpired = null,
    Object? failureOrSuccessOption = null,
    Object? failureOrSuccessOptionClear = null,
  }) {
    return _then(_$_PasswordExpiredNotifierState(
      isExpired: null == isExpired
          ? _value.isExpired
          : isExpired // ignore: cast_nullable_to_non_nullable
              as bool,
      failureOrSuccessOption: null == failureOrSuccessOption
          ? _value.failureOrSuccessOption
          : failureOrSuccessOption // ignore: cast_nullable_to_non_nullable
              as Option<Either<PasswordExpiredFailure, Unit>>,
      failureOrSuccessOptionClear: null == failureOrSuccessOptionClear
          ? _value.failureOrSuccessOptionClear
          : failureOrSuccessOptionClear // ignore: cast_nullable_to_non_nullable
              as Option<Either<PasswordExpiredFailure, Unit>>,
    ));
  }
}

/// @nodoc

class _$_PasswordExpiredNotifierState implements _PasswordExpiredNotifierState {
  const _$_PasswordExpiredNotifierState(
      {required this.isExpired,
      required this.failureOrSuccessOption,
      required this.failureOrSuccessOptionClear});

  @override
  final bool isExpired;
  @override
  final Option<Either<PasswordExpiredFailure, Unit>> failureOrSuccessOption;
  @override
  final Option<Either<PasswordExpiredFailure, Unit>>
      failureOrSuccessOptionClear;

  @override
  String toString() {
    return 'PasswordExpiredNotifierState(isExpired: $isExpired, failureOrSuccessOption: $failureOrSuccessOption, failureOrSuccessOptionClear: $failureOrSuccessOptionClear)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PasswordExpiredNotifierState &&
            (identical(other.isExpired, isExpired) ||
                other.isExpired == isExpired) &&
            (identical(other.failureOrSuccessOption, failureOrSuccessOption) ||
                other.failureOrSuccessOption == failureOrSuccessOption) &&
            (identical(other.failureOrSuccessOptionClear,
                    failureOrSuccessOptionClear) ||
                other.failureOrSuccessOptionClear ==
                    failureOrSuccessOptionClear));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isExpired,
      failureOrSuccessOption, failureOrSuccessOptionClear);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PasswordExpiredNotifierStateCopyWith<_$_PasswordExpiredNotifierState>
      get copyWith => __$$_PasswordExpiredNotifierStateCopyWithImpl<
          _$_PasswordExpiredNotifierState>(this, _$identity);
}

abstract class _PasswordExpiredNotifierState
    implements PasswordExpiredNotifierState {
  const factory _PasswordExpiredNotifierState(
      {required final bool isExpired,
      required final Option<Either<PasswordExpiredFailure, Unit>>
          failureOrSuccessOption,
      required final Option<Either<PasswordExpiredFailure, Unit>>
          failureOrSuccessOptionClear}) = _$_PasswordExpiredNotifierState;

  @override
  bool get isExpired;
  @override
  Option<Either<PasswordExpiredFailure, Unit>> get failureOrSuccessOption;
  @override
  Option<Either<PasswordExpiredFailure, Unit>> get failureOrSuccessOptionClear;
  @override
  @JsonKey(ignore: true)
  _$$_PasswordExpiredNotifierStateCopyWith<_$_PasswordExpiredNotifierState>
      get copyWith => throw _privateConstructorUsedError;
}
