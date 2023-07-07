// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'imei_auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ImeiAuthState {
  String get imei => throw _privateConstructorUsedError;
  bool get isGetting => throw _privateConstructorUsedError;
  Option<Either<ImeiFailure, String?>> get failureOrSuccessOption =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ImeiAuthStateCopyWith<ImeiAuthState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImeiAuthStateCopyWith<$Res> {
  factory $ImeiAuthStateCopyWith(
          ImeiAuthState value, $Res Function(ImeiAuthState) then) =
      _$ImeiAuthStateCopyWithImpl<$Res, ImeiAuthState>;
  @useResult
  $Res call(
      {String imei,
      bool isGetting,
      Option<Either<ImeiFailure, String?>> failureOrSuccessOption});
}

/// @nodoc
class _$ImeiAuthStateCopyWithImpl<$Res, $Val extends ImeiAuthState>
    implements $ImeiAuthStateCopyWith<$Res> {
  _$ImeiAuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imei = null,
    Object? isGetting = null,
    Object? failureOrSuccessOption = null,
  }) {
    return _then(_value.copyWith(
      imei: null == imei
          ? _value.imei
          : imei // ignore: cast_nullable_to_non_nullable
              as String,
      isGetting: null == isGetting
          ? _value.isGetting
          : isGetting // ignore: cast_nullable_to_non_nullable
              as bool,
      failureOrSuccessOption: null == failureOrSuccessOption
          ? _value.failureOrSuccessOption
          : failureOrSuccessOption // ignore: cast_nullable_to_non_nullable
              as Option<Either<ImeiFailure, String?>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ImeiAuthStateCopyWith<$Res>
    implements $ImeiAuthStateCopyWith<$Res> {
  factory _$$_ImeiAuthStateCopyWith(
          _$_ImeiAuthState value, $Res Function(_$_ImeiAuthState) then) =
      __$$_ImeiAuthStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String imei,
      bool isGetting,
      Option<Either<ImeiFailure, String?>> failureOrSuccessOption});
}

/// @nodoc
class __$$_ImeiAuthStateCopyWithImpl<$Res>
    extends _$ImeiAuthStateCopyWithImpl<$Res, _$_ImeiAuthState>
    implements _$$_ImeiAuthStateCopyWith<$Res> {
  __$$_ImeiAuthStateCopyWithImpl(
      _$_ImeiAuthState _value, $Res Function(_$_ImeiAuthState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imei = null,
    Object? isGetting = null,
    Object? failureOrSuccessOption = null,
  }) {
    return _then(_$_ImeiAuthState(
      imei: null == imei
          ? _value.imei
          : imei // ignore: cast_nullable_to_non_nullable
              as String,
      isGetting: null == isGetting
          ? _value.isGetting
          : isGetting // ignore: cast_nullable_to_non_nullable
              as bool,
      failureOrSuccessOption: null == failureOrSuccessOption
          ? _value.failureOrSuccessOption
          : failureOrSuccessOption // ignore: cast_nullable_to_non_nullable
              as Option<Either<ImeiFailure, String?>>,
    ));
  }
}

/// @nodoc

class _$_ImeiAuthState implements _ImeiAuthState {
  const _$_ImeiAuthState(
      {required this.imei,
      required this.isGetting,
      required this.failureOrSuccessOption});

  @override
  final String imei;
  @override
  final bool isGetting;
  @override
  final Option<Either<ImeiFailure, String?>> failureOrSuccessOption;

  @override
  String toString() {
    return 'ImeiAuthState(imei: $imei, isGetting: $isGetting, failureOrSuccessOption: $failureOrSuccessOption)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ImeiAuthState &&
            (identical(other.imei, imei) || other.imei == imei) &&
            (identical(other.isGetting, isGetting) ||
                other.isGetting == isGetting) &&
            (identical(other.failureOrSuccessOption, failureOrSuccessOption) ||
                other.failureOrSuccessOption == failureOrSuccessOption));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, imei, isGetting, failureOrSuccessOption);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ImeiAuthStateCopyWith<_$_ImeiAuthState> get copyWith =>
      __$$_ImeiAuthStateCopyWithImpl<_$_ImeiAuthState>(this, _$identity);
}

abstract class _ImeiAuthState implements ImeiAuthState {
  const factory _ImeiAuthState(
      {required final String imei,
      required final bool isGetting,
      required final Option<Either<ImeiFailure, String?>>
          failureOrSuccessOption}) = _$_ImeiAuthState;

  @override
  String get imei;
  @override
  bool get isGetting;
  @override
  Option<Either<ImeiFailure, String?>> get failureOrSuccessOption;
  @override
  @JsonKey(ignore: true)
  _$$_ImeiAuthStateCopyWith<_$_ImeiAuthState> get copyWith =>
      throw _privateConstructorUsedError;
}
