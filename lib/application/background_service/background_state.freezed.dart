// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'background_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$BackgroundState {
  List<BackgroundItemState> get savedBackgroundItems =>
      throw _privateConstructorUsedError;
  bool get isGetting => throw _privateConstructorUsedError;
  Option<Either<BackgroundFailure, List<SavedLocation>>>
      get failureOrSuccessOption => throw _privateConstructorUsedError;
  Option<Either<BackgroundFailure, Unit>> get failureOrSuccessOptionSave =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BackgroundStateCopyWith<BackgroundState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackgroundStateCopyWith<$Res> {
  factory $BackgroundStateCopyWith(
          BackgroundState value, $Res Function(BackgroundState) then) =
      _$BackgroundStateCopyWithImpl<$Res, BackgroundState>;
  @useResult
  $Res call(
      {List<BackgroundItemState> savedBackgroundItems,
      bool isGetting,
      Option<Either<BackgroundFailure, List<SavedLocation>>>
          failureOrSuccessOption,
      Option<Either<BackgroundFailure, Unit>> failureOrSuccessOptionSave});
}

/// @nodoc
class _$BackgroundStateCopyWithImpl<$Res, $Val extends BackgroundState>
    implements $BackgroundStateCopyWith<$Res> {
  _$BackgroundStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? savedBackgroundItems = null,
    Object? isGetting = null,
    Object? failureOrSuccessOption = null,
    Object? failureOrSuccessOptionSave = null,
  }) {
    return _then(_value.copyWith(
      savedBackgroundItems: null == savedBackgroundItems
          ? _value.savedBackgroundItems
          : savedBackgroundItems // ignore: cast_nullable_to_non_nullable
              as List<BackgroundItemState>,
      isGetting: null == isGetting
          ? _value.isGetting
          : isGetting // ignore: cast_nullable_to_non_nullable
              as bool,
      failureOrSuccessOption: null == failureOrSuccessOption
          ? _value.failureOrSuccessOption
          : failureOrSuccessOption // ignore: cast_nullable_to_non_nullable
              as Option<Either<BackgroundFailure, List<SavedLocation>>>,
      failureOrSuccessOptionSave: null == failureOrSuccessOptionSave
          ? _value.failureOrSuccessOptionSave
          : failureOrSuccessOptionSave // ignore: cast_nullable_to_non_nullable
              as Option<Either<BackgroundFailure, Unit>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_BackgroundStateCopyWith<$Res>
    implements $BackgroundStateCopyWith<$Res> {
  factory _$$_BackgroundStateCopyWith(
          _$_BackgroundState value, $Res Function(_$_BackgroundState) then) =
      __$$_BackgroundStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<BackgroundItemState> savedBackgroundItems,
      bool isGetting,
      Option<Either<BackgroundFailure, List<SavedLocation>>>
          failureOrSuccessOption,
      Option<Either<BackgroundFailure, Unit>> failureOrSuccessOptionSave});
}

/// @nodoc
class __$$_BackgroundStateCopyWithImpl<$Res>
    extends _$BackgroundStateCopyWithImpl<$Res, _$_BackgroundState>
    implements _$$_BackgroundStateCopyWith<$Res> {
  __$$_BackgroundStateCopyWithImpl(
      _$_BackgroundState _value, $Res Function(_$_BackgroundState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? savedBackgroundItems = null,
    Object? isGetting = null,
    Object? failureOrSuccessOption = null,
    Object? failureOrSuccessOptionSave = null,
  }) {
    return _then(_$_BackgroundState(
      savedBackgroundItems: null == savedBackgroundItems
          ? _value._savedBackgroundItems
          : savedBackgroundItems // ignore: cast_nullable_to_non_nullable
              as List<BackgroundItemState>,
      isGetting: null == isGetting
          ? _value.isGetting
          : isGetting // ignore: cast_nullable_to_non_nullable
              as bool,
      failureOrSuccessOption: null == failureOrSuccessOption
          ? _value.failureOrSuccessOption
          : failureOrSuccessOption // ignore: cast_nullable_to_non_nullable
              as Option<Either<BackgroundFailure, List<SavedLocation>>>,
      failureOrSuccessOptionSave: null == failureOrSuccessOptionSave
          ? _value.failureOrSuccessOptionSave
          : failureOrSuccessOptionSave // ignore: cast_nullable_to_non_nullable
              as Option<Either<BackgroundFailure, Unit>>,
    ));
  }
}

/// @nodoc

class _$_BackgroundState implements _BackgroundState {
  const _$_BackgroundState(
      {required final List<BackgroundItemState> savedBackgroundItems,
      required this.isGetting,
      required this.failureOrSuccessOption,
      required this.failureOrSuccessOptionSave})
      : _savedBackgroundItems = savedBackgroundItems;

  final List<BackgroundItemState> _savedBackgroundItems;
  @override
  List<BackgroundItemState> get savedBackgroundItems {
    if (_savedBackgroundItems is EqualUnmodifiableListView)
      return _savedBackgroundItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_savedBackgroundItems);
  }

  @override
  final bool isGetting;
  @override
  final Option<Either<BackgroundFailure, List<SavedLocation>>>
      failureOrSuccessOption;
  @override
  final Option<Either<BackgroundFailure, Unit>> failureOrSuccessOptionSave;

  @override
  String toString() {
    return 'BackgroundState(savedBackgroundItems: $savedBackgroundItems, isGetting: $isGetting, failureOrSuccessOption: $failureOrSuccessOption, failureOrSuccessOptionSave: $failureOrSuccessOptionSave)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BackgroundState &&
            const DeepCollectionEquality()
                .equals(other._savedBackgroundItems, _savedBackgroundItems) &&
            (identical(other.isGetting, isGetting) ||
                other.isGetting == isGetting) &&
            (identical(other.failureOrSuccessOption, failureOrSuccessOption) ||
                other.failureOrSuccessOption == failureOrSuccessOption) &&
            (identical(other.failureOrSuccessOptionSave,
                    failureOrSuccessOptionSave) ||
                other.failureOrSuccessOptionSave ==
                    failureOrSuccessOptionSave));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_savedBackgroundItems),
      isGetting,
      failureOrSuccessOption,
      failureOrSuccessOptionSave);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BackgroundStateCopyWith<_$_BackgroundState> get copyWith =>
      __$$_BackgroundStateCopyWithImpl<_$_BackgroundState>(this, _$identity);
}

abstract class _BackgroundState implements BackgroundState {
  const factory _BackgroundState(
      {required final List<BackgroundItemState> savedBackgroundItems,
      required final bool isGetting,
      required final Option<Either<BackgroundFailure, List<SavedLocation>>>
          failureOrSuccessOption,
      required final Option<Either<BackgroundFailure, Unit>>
          failureOrSuccessOptionSave}) = _$_BackgroundState;

  @override
  List<BackgroundItemState> get savedBackgroundItems;
  @override
  bool get isGetting;
  @override
  Option<Either<BackgroundFailure, List<SavedLocation>>>
      get failureOrSuccessOption;
  @override
  Option<Either<BackgroundFailure, Unit>> get failureOrSuccessOptionSave;
  @override
  @JsonKey(ignore: true)
  _$$_BackgroundStateCopyWith<_$_BackgroundState> get copyWith =>
      throw _privateConstructorUsedError;
}
