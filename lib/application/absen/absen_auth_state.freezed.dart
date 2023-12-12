// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'absen_auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AbsenAuthState {
  bool get isSubmitting => throw _privateConstructorUsedError;
  SavedLocation get backgroundItemState => throw _privateConstructorUsedError;
  Option<Either<AbsenFailure, Unit>> get failureOrSuccessOption =>
      throw _privateConstructorUsedError;
  Option<Either<AbsenFailure, Unit>> get failureOrSuccessOptionSaved =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AbsenAuthStateCopyWith<AbsenAuthState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AbsenAuthStateCopyWith<$Res> {
  factory $AbsenAuthStateCopyWith(
          AbsenAuthState value, $Res Function(AbsenAuthState) then) =
      _$AbsenAuthStateCopyWithImpl<$Res, AbsenAuthState>;
  @useResult
  $Res call(
      {bool isSubmitting,
      SavedLocation backgroundItemState,
      Option<Either<AbsenFailure, Unit>> failureOrSuccessOption,
      Option<Either<AbsenFailure, Unit>> failureOrSuccessOptionSaved});

  $SavedLocationCopyWith<$Res> get backgroundItemState;
}

/// @nodoc
class _$AbsenAuthStateCopyWithImpl<$Res, $Val extends AbsenAuthState>
    implements $AbsenAuthStateCopyWith<$Res> {
  _$AbsenAuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSubmitting = null,
    Object? backgroundItemState = null,
    Object? failureOrSuccessOption = null,
    Object? failureOrSuccessOptionSaved = null,
  }) {
    return _then(_value.copyWith(
      isSubmitting: null == isSubmitting
          ? _value.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      backgroundItemState: null == backgroundItemState
          ? _value.backgroundItemState
          : backgroundItemState // ignore: cast_nullable_to_non_nullable
              as SavedLocation,
      failureOrSuccessOption: null == failureOrSuccessOption
          ? _value.failureOrSuccessOption
          : failureOrSuccessOption // ignore: cast_nullable_to_non_nullable
              as Option<Either<AbsenFailure, Unit>>,
      failureOrSuccessOptionSaved: null == failureOrSuccessOptionSaved
          ? _value.failureOrSuccessOptionSaved
          : failureOrSuccessOptionSaved // ignore: cast_nullable_to_non_nullable
              as Option<Either<AbsenFailure, Unit>>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SavedLocationCopyWith<$Res> get backgroundItemState {
    return $SavedLocationCopyWith<$Res>(_value.backgroundItemState, (value) {
      return _then(_value.copyWith(backgroundItemState: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_AbsenAuthCopyWith<$Res>
    implements $AbsenAuthStateCopyWith<$Res> {
  factory _$$_AbsenAuthCopyWith(
          _$_AbsenAuth value, $Res Function(_$_AbsenAuth) then) =
      __$$_AbsenAuthCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isSubmitting,
      SavedLocation backgroundItemState,
      Option<Either<AbsenFailure, Unit>> failureOrSuccessOption,
      Option<Either<AbsenFailure, Unit>> failureOrSuccessOptionSaved});

  @override
  $SavedLocationCopyWith<$Res> get backgroundItemState;
}

/// @nodoc
class __$$_AbsenAuthCopyWithImpl<$Res>
    extends _$AbsenAuthStateCopyWithImpl<$Res, _$_AbsenAuth>
    implements _$$_AbsenAuthCopyWith<$Res> {
  __$$_AbsenAuthCopyWithImpl(
      _$_AbsenAuth _value, $Res Function(_$_AbsenAuth) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSubmitting = null,
    Object? backgroundItemState = null,
    Object? failureOrSuccessOption = null,
    Object? failureOrSuccessOptionSaved = null,
  }) {
    return _then(_$_AbsenAuth(
      isSubmitting: null == isSubmitting
          ? _value.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      backgroundItemState: null == backgroundItemState
          ? _value.backgroundItemState
          : backgroundItemState // ignore: cast_nullable_to_non_nullable
              as SavedLocation,
      failureOrSuccessOption: null == failureOrSuccessOption
          ? _value.failureOrSuccessOption
          : failureOrSuccessOption // ignore: cast_nullable_to_non_nullable
              as Option<Either<AbsenFailure, Unit>>,
      failureOrSuccessOptionSaved: null == failureOrSuccessOptionSaved
          ? _value.failureOrSuccessOptionSaved
          : failureOrSuccessOptionSaved // ignore: cast_nullable_to_non_nullable
              as Option<Either<AbsenFailure, Unit>>,
    ));
  }
}

/// @nodoc

class _$_AbsenAuth implements _AbsenAuth {
  const _$_AbsenAuth(
      {required this.isSubmitting,
      required this.backgroundItemState,
      required this.failureOrSuccessOption,
      required this.failureOrSuccessOptionSaved});

  @override
  final bool isSubmitting;
  @override
  final SavedLocation backgroundItemState;
  @override
  final Option<Either<AbsenFailure, Unit>> failureOrSuccessOption;
  @override
  final Option<Either<AbsenFailure, Unit>> failureOrSuccessOptionSaved;

  @override
  String toString() {
    return 'AbsenAuthState(isSubmitting: $isSubmitting, backgroundItemState: $backgroundItemState, failureOrSuccessOption: $failureOrSuccessOption, failureOrSuccessOptionSaved: $failureOrSuccessOptionSaved)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AbsenAuth &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.backgroundItemState, backgroundItemState) ||
                other.backgroundItemState == backgroundItemState) &&
            (identical(other.failureOrSuccessOption, failureOrSuccessOption) ||
                other.failureOrSuccessOption == failureOrSuccessOption) &&
            (identical(other.failureOrSuccessOptionSaved,
                    failureOrSuccessOptionSaved) ||
                other.failureOrSuccessOptionSaved ==
                    failureOrSuccessOptionSaved));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isSubmitting,
      backgroundItemState, failureOrSuccessOption, failureOrSuccessOptionSaved);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AbsenAuthCopyWith<_$_AbsenAuth> get copyWith =>
      __$$_AbsenAuthCopyWithImpl<_$_AbsenAuth>(this, _$identity);
}

abstract class _AbsenAuth implements AbsenAuthState {
  const factory _AbsenAuth(
      {required final bool isSubmitting,
      required final SavedLocation backgroundItemState,
      required final Option<Either<AbsenFailure, Unit>> failureOrSuccessOption,
      required final Option<Either<AbsenFailure, Unit>>
          failureOrSuccessOptionSaved}) = _$_AbsenAuth;

  @override
  bool get isSubmitting;
  @override
  SavedLocation get backgroundItemState;
  @override
  Option<Either<AbsenFailure, Unit>> get failureOrSuccessOption;
  @override
  Option<Either<AbsenFailure, Unit>> get failureOrSuccessOptionSaved;
  @override
  @JsonKey(ignore: true)
  _$$_AbsenAuthCopyWith<_$_AbsenAuth> get copyWith =>
      throw _privateConstructorUsedError;
}
