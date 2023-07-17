// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auto_absen_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AutoAbsenState {
  bool get isProcessing => throw _privateConstructorUsedError;
  List<RecentAbsenState> get recentAbsens => throw _privateConstructorUsedError;
  List<BackgroundItemState> get backgroundSavedItems =>
      throw _privateConstructorUsedError;
  Map<String, List<BackgroundItemState>> get backgroundSavedItemsByDate =>
      throw _privateConstructorUsedError;
  Option<Either<AutoAbsenFailure, List<RecentAbsenState>>>
      get failureOrSuccessOptionRecentAbsen =>
          throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AutoAbsenStateCopyWith<AutoAbsenState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AutoAbsenStateCopyWith<$Res> {
  factory $AutoAbsenStateCopyWith(
          AutoAbsenState value, $Res Function(AutoAbsenState) then) =
      _$AutoAbsenStateCopyWithImpl<$Res, AutoAbsenState>;
  @useResult
  $Res call(
      {bool isProcessing,
      List<RecentAbsenState> recentAbsens,
      List<BackgroundItemState> backgroundSavedItems,
      Map<String, List<BackgroundItemState>> backgroundSavedItemsByDate,
      Option<Either<AutoAbsenFailure, List<RecentAbsenState>>>
          failureOrSuccessOptionRecentAbsen});
}

/// @nodoc
class _$AutoAbsenStateCopyWithImpl<$Res, $Val extends AutoAbsenState>
    implements $AutoAbsenStateCopyWith<$Res> {
  _$AutoAbsenStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isProcessing = null,
    Object? recentAbsens = null,
    Object? backgroundSavedItems = null,
    Object? backgroundSavedItemsByDate = null,
    Object? failureOrSuccessOptionRecentAbsen = null,
  }) {
    return _then(_value.copyWith(
      isProcessing: null == isProcessing
          ? _value.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      recentAbsens: null == recentAbsens
          ? _value.recentAbsens
          : recentAbsens // ignore: cast_nullable_to_non_nullable
              as List<RecentAbsenState>,
      backgroundSavedItems: null == backgroundSavedItems
          ? _value.backgroundSavedItems
          : backgroundSavedItems // ignore: cast_nullable_to_non_nullable
              as List<BackgroundItemState>,
      backgroundSavedItemsByDate: null == backgroundSavedItemsByDate
          ? _value.backgroundSavedItemsByDate
          : backgroundSavedItemsByDate // ignore: cast_nullable_to_non_nullable
              as Map<String, List<BackgroundItemState>>,
      failureOrSuccessOptionRecentAbsen: null ==
              failureOrSuccessOptionRecentAbsen
          ? _value.failureOrSuccessOptionRecentAbsen
          : failureOrSuccessOptionRecentAbsen // ignore: cast_nullable_to_non_nullable
              as Option<Either<AutoAbsenFailure, List<RecentAbsenState>>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AutoAbsenStateCopyWith<$Res>
    implements $AutoAbsenStateCopyWith<$Res> {
  factory _$$_AutoAbsenStateCopyWith(
          _$_AutoAbsenState value, $Res Function(_$_AutoAbsenState) then) =
      __$$_AutoAbsenStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isProcessing,
      List<RecentAbsenState> recentAbsens,
      List<BackgroundItemState> backgroundSavedItems,
      Map<String, List<BackgroundItemState>> backgroundSavedItemsByDate,
      Option<Either<AutoAbsenFailure, List<RecentAbsenState>>>
          failureOrSuccessOptionRecentAbsen});
}

/// @nodoc
class __$$_AutoAbsenStateCopyWithImpl<$Res>
    extends _$AutoAbsenStateCopyWithImpl<$Res, _$_AutoAbsenState>
    implements _$$_AutoAbsenStateCopyWith<$Res> {
  __$$_AutoAbsenStateCopyWithImpl(
      _$_AutoAbsenState _value, $Res Function(_$_AutoAbsenState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isProcessing = null,
    Object? recentAbsens = null,
    Object? backgroundSavedItems = null,
    Object? backgroundSavedItemsByDate = null,
    Object? failureOrSuccessOptionRecentAbsen = null,
  }) {
    return _then(_$_AutoAbsenState(
      isProcessing: null == isProcessing
          ? _value.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      recentAbsens: null == recentAbsens
          ? _value._recentAbsens
          : recentAbsens // ignore: cast_nullable_to_non_nullable
              as List<RecentAbsenState>,
      backgroundSavedItems: null == backgroundSavedItems
          ? _value._backgroundSavedItems
          : backgroundSavedItems // ignore: cast_nullable_to_non_nullable
              as List<BackgroundItemState>,
      backgroundSavedItemsByDate: null == backgroundSavedItemsByDate
          ? _value._backgroundSavedItemsByDate
          : backgroundSavedItemsByDate // ignore: cast_nullable_to_non_nullable
              as Map<String, List<BackgroundItemState>>,
      failureOrSuccessOptionRecentAbsen: null ==
              failureOrSuccessOptionRecentAbsen
          ? _value.failureOrSuccessOptionRecentAbsen
          : failureOrSuccessOptionRecentAbsen // ignore: cast_nullable_to_non_nullable
              as Option<Either<AutoAbsenFailure, List<RecentAbsenState>>>,
    ));
  }
}

/// @nodoc

class _$_AutoAbsenState implements _AutoAbsenState {
  const _$_AutoAbsenState(
      {required this.isProcessing,
      required final List<RecentAbsenState> recentAbsens,
      required final List<BackgroundItemState> backgroundSavedItems,
      required final Map<String, List<BackgroundItemState>>
          backgroundSavedItemsByDate,
      required this.failureOrSuccessOptionRecentAbsen})
      : _recentAbsens = recentAbsens,
        _backgroundSavedItems = backgroundSavedItems,
        _backgroundSavedItemsByDate = backgroundSavedItemsByDate;

  @override
  final bool isProcessing;
  final List<RecentAbsenState> _recentAbsens;
  @override
  List<RecentAbsenState> get recentAbsens {
    if (_recentAbsens is EqualUnmodifiableListView) return _recentAbsens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentAbsens);
  }

  final List<BackgroundItemState> _backgroundSavedItems;
  @override
  List<BackgroundItemState> get backgroundSavedItems {
    if (_backgroundSavedItems is EqualUnmodifiableListView)
      return _backgroundSavedItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_backgroundSavedItems);
  }

  final Map<String, List<BackgroundItemState>> _backgroundSavedItemsByDate;
  @override
  Map<String, List<BackgroundItemState>> get backgroundSavedItemsByDate {
    if (_backgroundSavedItemsByDate is EqualUnmodifiableMapView)
      return _backgroundSavedItemsByDate;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_backgroundSavedItemsByDate);
  }

  @override
  final Option<Either<AutoAbsenFailure, List<RecentAbsenState>>>
      failureOrSuccessOptionRecentAbsen;

  @override
  String toString() {
    return 'AutoAbsenState(isProcessing: $isProcessing, recentAbsens: $recentAbsens, backgroundSavedItems: $backgroundSavedItems, backgroundSavedItemsByDate: $backgroundSavedItemsByDate, failureOrSuccessOptionRecentAbsen: $failureOrSuccessOptionRecentAbsen)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AutoAbsenState &&
            (identical(other.isProcessing, isProcessing) ||
                other.isProcessing == isProcessing) &&
            const DeepCollectionEquality()
                .equals(other._recentAbsens, _recentAbsens) &&
            const DeepCollectionEquality()
                .equals(other._backgroundSavedItems, _backgroundSavedItems) &&
            const DeepCollectionEquality().equals(
                other._backgroundSavedItemsByDate,
                _backgroundSavedItemsByDate) &&
            (identical(other.failureOrSuccessOptionRecentAbsen,
                    failureOrSuccessOptionRecentAbsen) ||
                other.failureOrSuccessOptionRecentAbsen ==
                    failureOrSuccessOptionRecentAbsen));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isProcessing,
      const DeepCollectionEquality().hash(_recentAbsens),
      const DeepCollectionEquality().hash(_backgroundSavedItems),
      const DeepCollectionEquality().hash(_backgroundSavedItemsByDate),
      failureOrSuccessOptionRecentAbsen);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AutoAbsenStateCopyWith<_$_AutoAbsenState> get copyWith =>
      __$$_AutoAbsenStateCopyWithImpl<_$_AutoAbsenState>(this, _$identity);
}

abstract class _AutoAbsenState implements AutoAbsenState {
  const factory _AutoAbsenState(
      {required final bool isProcessing,
      required final List<RecentAbsenState> recentAbsens,
      required final List<BackgroundItemState> backgroundSavedItems,
      required final Map<String, List<BackgroundItemState>>
          backgroundSavedItemsByDate,
      required final Option<Either<AutoAbsenFailure, List<RecentAbsenState>>>
          failureOrSuccessOptionRecentAbsen}) = _$_AutoAbsenState;

  @override
  bool get isProcessing;
  @override
  List<RecentAbsenState> get recentAbsens;
  @override
  List<BackgroundItemState> get backgroundSavedItems;
  @override
  Map<String, List<BackgroundItemState>> get backgroundSavedItemsByDate;
  @override
  Option<Either<AutoAbsenFailure, List<RecentAbsenState>>>
      get failureOrSuccessOptionRecentAbsen;
  @override
  @JsonKey(ignore: true)
  _$$_AutoAbsenStateCopyWith<_$_AutoAbsenState> get copyWith =>
      throw _privateConstructorUsedError;
}
