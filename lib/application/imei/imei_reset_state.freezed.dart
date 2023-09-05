// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'imei_reset_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ImeiResetState {
  bool get isClearing => throw _privateConstructorUsedError;
  Option<Either<ImeiFailure, Unit?>> get failureOrSuccessOption =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ImeiResetStateCopyWith<ImeiResetState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImeiResetStateCopyWith<$Res> {
  factory $ImeiResetStateCopyWith(
          ImeiResetState value, $Res Function(ImeiResetState) then) =
      _$ImeiResetStateCopyWithImpl<$Res, ImeiResetState>;
  @useResult
  $Res call(
      {bool isClearing,
      Option<Either<ImeiFailure, Unit?>> failureOrSuccessOption});
}

/// @nodoc
class _$ImeiResetStateCopyWithImpl<$Res, $Val extends ImeiResetState>
    implements $ImeiResetStateCopyWith<$Res> {
  _$ImeiResetStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isClearing = null,
    Object? failureOrSuccessOption = null,
  }) {
    return _then(_value.copyWith(
      isClearing: null == isClearing
          ? _value.isClearing
          : isClearing // ignore: cast_nullable_to_non_nullable
              as bool,
      failureOrSuccessOption: null == failureOrSuccessOption
          ? _value.failureOrSuccessOption
          : failureOrSuccessOption // ignore: cast_nullable_to_non_nullable
              as Option<Either<ImeiFailure, Unit?>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ImeiResetStateCopyWith<$Res>
    implements $ImeiResetStateCopyWith<$Res> {
  factory _$$_ImeiResetStateCopyWith(
          _$_ImeiResetState value, $Res Function(_$_ImeiResetState) then) =
      __$$_ImeiResetStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isClearing,
      Option<Either<ImeiFailure, Unit?>> failureOrSuccessOption});
}

/// @nodoc
class __$$_ImeiResetStateCopyWithImpl<$Res>
    extends _$ImeiResetStateCopyWithImpl<$Res, _$_ImeiResetState>
    implements _$$_ImeiResetStateCopyWith<$Res> {
  __$$_ImeiResetStateCopyWithImpl(
      _$_ImeiResetState _value, $Res Function(_$_ImeiResetState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isClearing = null,
    Object? failureOrSuccessOption = null,
  }) {
    return _then(_$_ImeiResetState(
      isClearing: null == isClearing
          ? _value.isClearing
          : isClearing // ignore: cast_nullable_to_non_nullable
              as bool,
      failureOrSuccessOption: null == failureOrSuccessOption
          ? _value.failureOrSuccessOption
          : failureOrSuccessOption // ignore: cast_nullable_to_non_nullable
              as Option<Either<ImeiFailure, Unit?>>,
    ));
  }
}

/// @nodoc

class _$_ImeiResetState implements _ImeiResetState {
  const _$_ImeiResetState(
      {required this.isClearing, required this.failureOrSuccessOption});

  @override
  final bool isClearing;
  @override
  final Option<Either<ImeiFailure, Unit?>> failureOrSuccessOption;

  @override
  String toString() {
    return 'ImeiResetState(isClearing: $isClearing, failureOrSuccessOption: $failureOrSuccessOption)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ImeiResetState &&
            (identical(other.isClearing, isClearing) ||
                other.isClearing == isClearing) &&
            (identical(other.failureOrSuccessOption, failureOrSuccessOption) ||
                other.failureOrSuccessOption == failureOrSuccessOption));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isClearing, failureOrSuccessOption);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ImeiResetStateCopyWith<_$_ImeiResetState> get copyWith =>
      __$$_ImeiResetStateCopyWithImpl<_$_ImeiResetState>(this, _$identity);
}

abstract class _ImeiResetState implements ImeiResetState {
  const factory _ImeiResetState(
      {required final bool isClearing,
      required final Option<Either<ImeiFailure, Unit?>>
          failureOrSuccessOption}) = _$_ImeiResetState;

  @override
  bool get isClearing;
  @override
  Option<Either<ImeiFailure, Unit?>> get failureOrSuccessOption;
  @override
  @JsonKey(ignore: true)
  _$$_ImeiResetStateCopyWith<_$_ImeiResetState> get copyWith =>
      throw _privateConstructorUsedError;
}
