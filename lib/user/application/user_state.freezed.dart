// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$UserState {
  UserModelWithPassword get user => throw _privateConstructorUsedError;
  bool get isGetting => throw _privateConstructorUsedError;
  Option<Either<UserFailure, String?>> get failureOrSuccessOption =>
      throw _privateConstructorUsedError;
  Option<Either<AuthFailure, Unit?>> get failureOrSuccessOptionUpdate =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserStateCopyWith<UserState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStateCopyWith<$Res> {
  factory $UserStateCopyWith(UserState value, $Res Function(UserState) then) =
      _$UserStateCopyWithImpl<$Res, UserState>;
  @useResult
  $Res call(
      {UserModelWithPassword user,
      bool isGetting,
      Option<Either<UserFailure, String?>> failureOrSuccessOption,
      Option<Either<AuthFailure, Unit?>> failureOrSuccessOptionUpdate});

  $UserModelWithPasswordCopyWith<$Res> get user;
}

/// @nodoc
class _$UserStateCopyWithImpl<$Res, $Val extends UserState>
    implements $UserStateCopyWith<$Res> {
  _$UserStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? isGetting = null,
    Object? failureOrSuccessOption = null,
    Object? failureOrSuccessOptionUpdate = null,
  }) {
    return _then(_value.copyWith(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModelWithPassword,
      isGetting: null == isGetting
          ? _value.isGetting
          : isGetting // ignore: cast_nullable_to_non_nullable
              as bool,
      failureOrSuccessOption: null == failureOrSuccessOption
          ? _value.failureOrSuccessOption
          : failureOrSuccessOption // ignore: cast_nullable_to_non_nullable
              as Option<Either<UserFailure, String?>>,
      failureOrSuccessOptionUpdate: null == failureOrSuccessOptionUpdate
          ? _value.failureOrSuccessOptionUpdate
          : failureOrSuccessOptionUpdate // ignore: cast_nullable_to_non_nullable
              as Option<Either<AuthFailure, Unit?>>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserModelWithPasswordCopyWith<$Res> get user {
    return $UserModelWithPasswordCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_UserStateCopyWith<$Res> implements $UserStateCopyWith<$Res> {
  factory _$$_UserStateCopyWith(
          _$_UserState value, $Res Function(_$_UserState) then) =
      __$$_UserStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {UserModelWithPassword user,
      bool isGetting,
      Option<Either<UserFailure, String?>> failureOrSuccessOption,
      Option<Either<AuthFailure, Unit?>> failureOrSuccessOptionUpdate});

  @override
  $UserModelWithPasswordCopyWith<$Res> get user;
}

/// @nodoc
class __$$_UserStateCopyWithImpl<$Res>
    extends _$UserStateCopyWithImpl<$Res, _$_UserState>
    implements _$$_UserStateCopyWith<$Res> {
  __$$_UserStateCopyWithImpl(
      _$_UserState _value, $Res Function(_$_UserState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? isGetting = null,
    Object? failureOrSuccessOption = null,
    Object? failureOrSuccessOptionUpdate = null,
  }) {
    return _then(_$_UserState(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModelWithPassword,
      isGetting: null == isGetting
          ? _value.isGetting
          : isGetting // ignore: cast_nullable_to_non_nullable
              as bool,
      failureOrSuccessOption: null == failureOrSuccessOption
          ? _value.failureOrSuccessOption
          : failureOrSuccessOption // ignore: cast_nullable_to_non_nullable
              as Option<Either<UserFailure, String?>>,
      failureOrSuccessOptionUpdate: null == failureOrSuccessOptionUpdate
          ? _value.failureOrSuccessOptionUpdate
          : failureOrSuccessOptionUpdate // ignore: cast_nullable_to_non_nullable
              as Option<Either<AuthFailure, Unit?>>,
    ));
  }
}

/// @nodoc

class _$_UserState implements _UserState {
  const _$_UserState(
      {required this.user,
      required this.isGetting,
      required this.failureOrSuccessOption,
      required this.failureOrSuccessOptionUpdate});

  @override
  final UserModelWithPassword user;
  @override
  final bool isGetting;
  @override
  final Option<Either<UserFailure, String?>> failureOrSuccessOption;
  @override
  final Option<Either<AuthFailure, Unit?>> failureOrSuccessOptionUpdate;

  @override
  String toString() {
    return 'UserState(user: $user, isGetting: $isGetting, failureOrSuccessOption: $failureOrSuccessOption, failureOrSuccessOptionUpdate: $failureOrSuccessOptionUpdate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserState &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.isGetting, isGetting) ||
                other.isGetting == isGetting) &&
            (identical(other.failureOrSuccessOption, failureOrSuccessOption) ||
                other.failureOrSuccessOption == failureOrSuccessOption) &&
            (identical(other.failureOrSuccessOptionUpdate,
                    failureOrSuccessOptionUpdate) ||
                other.failureOrSuccessOptionUpdate ==
                    failureOrSuccessOptionUpdate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, isGetting,
      failureOrSuccessOption, failureOrSuccessOptionUpdate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserStateCopyWith<_$_UserState> get copyWith =>
      __$$_UserStateCopyWithImpl<_$_UserState>(this, _$identity);
}

abstract class _UserState implements UserState {
  const factory _UserState(
      {required final UserModelWithPassword user,
      required final bool isGetting,
      required final Option<Either<UserFailure, String?>>
          failureOrSuccessOption,
      required final Option<Either<AuthFailure, Unit?>>
          failureOrSuccessOptionUpdate}) = _$_UserState;

  @override
  UserModelWithPassword get user;
  @override
  bool get isGetting;
  @override
  Option<Either<UserFailure, String?>> get failureOrSuccessOption;
  @override
  Option<Either<AuthFailure, Unit?>> get failureOrSuccessOptionUpdate;
  @override
  @JsonKey(ignore: true)
  _$$_UserStateCopyWith<_$_UserState> get copyWith =>
      throw _privateConstructorUsedError;
}
