// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geofence_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GeofenceState {
  GeofenceService get geofenceService => throw _privateConstructorUsedError; //
  List<GeofenceCoordinate> get geofenceCoordinates =>
      throw _privateConstructorUsedError;
  GeofenceCoordinate get nearestCoordinates =>
      throw _privateConstructorUsedError;
  Location get currentLocation => throw _privateConstructorUsedError; //
  bool get isGetting => throw _privateConstructorUsedError;
  Option<Either<GeofenceFailure, List<GeofenceResponse>>>
      get failureOrSuccessOption =>
          throw _privateConstructorUsedError; // GEOFENCE STORAGE ACTIVITY
  Option<Either<GeofenceFailure, Unit>> get failureOrSuccessOptionStorage =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GeofenceStateCopyWith<GeofenceState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeofenceStateCopyWith<$Res> {
  factory $GeofenceStateCopyWith(
          GeofenceState value, $Res Function(GeofenceState) then) =
      _$GeofenceStateCopyWithImpl<$Res, GeofenceState>;
  @useResult
  $Res call(
      {GeofenceService geofenceService,
      List<GeofenceCoordinate> geofenceCoordinates,
      GeofenceCoordinate nearestCoordinates,
      Location currentLocation,
      bool isGetting,
      Option<Either<GeofenceFailure, List<GeofenceResponse>>>
          failureOrSuccessOption,
      Option<Either<GeofenceFailure, Unit>> failureOrSuccessOptionStorage});

  $GeofenceCoordinateCopyWith<$Res> get nearestCoordinates;
}

/// @nodoc
class _$GeofenceStateCopyWithImpl<$Res, $Val extends GeofenceState>
    implements $GeofenceStateCopyWith<$Res> {
  _$GeofenceStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? geofenceService = null,
    Object? geofenceCoordinates = null,
    Object? nearestCoordinates = null,
    Object? currentLocation = null,
    Object? isGetting = null,
    Object? failureOrSuccessOption = null,
    Object? failureOrSuccessOptionStorage = null,
  }) {
    return _then(_value.copyWith(
      geofenceService: null == geofenceService
          ? _value.geofenceService
          : geofenceService // ignore: cast_nullable_to_non_nullable
              as GeofenceService,
      geofenceCoordinates: null == geofenceCoordinates
          ? _value.geofenceCoordinates
          : geofenceCoordinates // ignore: cast_nullable_to_non_nullable
              as List<GeofenceCoordinate>,
      nearestCoordinates: null == nearestCoordinates
          ? _value.nearestCoordinates
          : nearestCoordinates // ignore: cast_nullable_to_non_nullable
              as GeofenceCoordinate,
      currentLocation: null == currentLocation
          ? _value.currentLocation
          : currentLocation // ignore: cast_nullable_to_non_nullable
              as Location,
      isGetting: null == isGetting
          ? _value.isGetting
          : isGetting // ignore: cast_nullable_to_non_nullable
              as bool,
      failureOrSuccessOption: null == failureOrSuccessOption
          ? _value.failureOrSuccessOption
          : failureOrSuccessOption // ignore: cast_nullable_to_non_nullable
              as Option<Either<GeofenceFailure, List<GeofenceResponse>>>,
      failureOrSuccessOptionStorage: null == failureOrSuccessOptionStorage
          ? _value.failureOrSuccessOptionStorage
          : failureOrSuccessOptionStorage // ignore: cast_nullable_to_non_nullable
              as Option<Either<GeofenceFailure, Unit>>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $GeofenceCoordinateCopyWith<$Res> get nearestCoordinates {
    return $GeofenceCoordinateCopyWith<$Res>(_value.nearestCoordinates,
        (value) {
      return _then(_value.copyWith(nearestCoordinates: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_GeofenceStateCopyWith<$Res>
    implements $GeofenceStateCopyWith<$Res> {
  factory _$$_GeofenceStateCopyWith(
          _$_GeofenceState value, $Res Function(_$_GeofenceState) then) =
      __$$_GeofenceStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {GeofenceService geofenceService,
      List<GeofenceCoordinate> geofenceCoordinates,
      GeofenceCoordinate nearestCoordinates,
      Location currentLocation,
      bool isGetting,
      Option<Either<GeofenceFailure, List<GeofenceResponse>>>
          failureOrSuccessOption,
      Option<Either<GeofenceFailure, Unit>> failureOrSuccessOptionStorage});

  @override
  $GeofenceCoordinateCopyWith<$Res> get nearestCoordinates;
}

/// @nodoc
class __$$_GeofenceStateCopyWithImpl<$Res>
    extends _$GeofenceStateCopyWithImpl<$Res, _$_GeofenceState>
    implements _$$_GeofenceStateCopyWith<$Res> {
  __$$_GeofenceStateCopyWithImpl(
      _$_GeofenceState _value, $Res Function(_$_GeofenceState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? geofenceService = null,
    Object? geofenceCoordinates = null,
    Object? nearestCoordinates = null,
    Object? currentLocation = null,
    Object? isGetting = null,
    Object? failureOrSuccessOption = null,
    Object? failureOrSuccessOptionStorage = null,
  }) {
    return _then(_$_GeofenceState(
      geofenceService: null == geofenceService
          ? _value.geofenceService
          : geofenceService // ignore: cast_nullable_to_non_nullable
              as GeofenceService,
      geofenceCoordinates: null == geofenceCoordinates
          ? _value._geofenceCoordinates
          : geofenceCoordinates // ignore: cast_nullable_to_non_nullable
              as List<GeofenceCoordinate>,
      nearestCoordinates: null == nearestCoordinates
          ? _value.nearestCoordinates
          : nearestCoordinates // ignore: cast_nullable_to_non_nullable
              as GeofenceCoordinate,
      currentLocation: null == currentLocation
          ? _value.currentLocation
          : currentLocation // ignore: cast_nullable_to_non_nullable
              as Location,
      isGetting: null == isGetting
          ? _value.isGetting
          : isGetting // ignore: cast_nullable_to_non_nullable
              as bool,
      failureOrSuccessOption: null == failureOrSuccessOption
          ? _value.failureOrSuccessOption
          : failureOrSuccessOption // ignore: cast_nullable_to_non_nullable
              as Option<Either<GeofenceFailure, List<GeofenceResponse>>>,
      failureOrSuccessOptionStorage: null == failureOrSuccessOptionStorage
          ? _value.failureOrSuccessOptionStorage
          : failureOrSuccessOptionStorage // ignore: cast_nullable_to_non_nullable
              as Option<Either<GeofenceFailure, Unit>>,
    ));
  }
}

/// @nodoc

class _$_GeofenceState implements _GeofenceState {
  const _$_GeofenceState(
      {required this.geofenceService,
      required final List<GeofenceCoordinate> geofenceCoordinates,
      required this.nearestCoordinates,
      required this.currentLocation,
      required this.isGetting,
      required this.failureOrSuccessOption,
      required this.failureOrSuccessOptionStorage})
      : _geofenceCoordinates = geofenceCoordinates;

  @override
  final GeofenceService geofenceService;
//
  final List<GeofenceCoordinate> _geofenceCoordinates;
//
  @override
  List<GeofenceCoordinate> get geofenceCoordinates {
    if (_geofenceCoordinates is EqualUnmodifiableListView)
      return _geofenceCoordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_geofenceCoordinates);
  }

  @override
  final GeofenceCoordinate nearestCoordinates;
  @override
  final Location currentLocation;
//
  @override
  final bool isGetting;
  @override
  final Option<Either<GeofenceFailure, List<GeofenceResponse>>>
      failureOrSuccessOption;
// GEOFENCE STORAGE ACTIVITY
  @override
  final Option<Either<GeofenceFailure, Unit>> failureOrSuccessOptionStorage;

  @override
  String toString() {
    return 'GeofenceState(geofenceService: $geofenceService, geofenceCoordinates: $geofenceCoordinates, nearestCoordinates: $nearestCoordinates, currentLocation: $currentLocation, isGetting: $isGetting, failureOrSuccessOption: $failureOrSuccessOption, failureOrSuccessOptionStorage: $failureOrSuccessOptionStorage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GeofenceState &&
            (identical(other.geofenceService, geofenceService) ||
                other.geofenceService == geofenceService) &&
            const DeepCollectionEquality()
                .equals(other._geofenceCoordinates, _geofenceCoordinates) &&
            (identical(other.nearestCoordinates, nearestCoordinates) ||
                other.nearestCoordinates == nearestCoordinates) &&
            (identical(other.currentLocation, currentLocation) ||
                other.currentLocation == currentLocation) &&
            (identical(other.isGetting, isGetting) ||
                other.isGetting == isGetting) &&
            (identical(other.failureOrSuccessOption, failureOrSuccessOption) ||
                other.failureOrSuccessOption == failureOrSuccessOption) &&
            (identical(other.failureOrSuccessOptionStorage,
                    failureOrSuccessOptionStorage) ||
                other.failureOrSuccessOptionStorage ==
                    failureOrSuccessOptionStorage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      geofenceService,
      const DeepCollectionEquality().hash(_geofenceCoordinates),
      nearestCoordinates,
      currentLocation,
      isGetting,
      failureOrSuccessOption,
      failureOrSuccessOptionStorage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GeofenceStateCopyWith<_$_GeofenceState> get copyWith =>
      __$$_GeofenceStateCopyWithImpl<_$_GeofenceState>(this, _$identity);
}

abstract class _GeofenceState implements GeofenceState {
  const factory _GeofenceState(
      {required final GeofenceService geofenceService,
      required final List<GeofenceCoordinate> geofenceCoordinates,
      required final GeofenceCoordinate nearestCoordinates,
      required final Location currentLocation,
      required final bool isGetting,
      required final Option<Either<GeofenceFailure, List<GeofenceResponse>>>
          failureOrSuccessOption,
      required final Option<Either<GeofenceFailure, Unit>>
          failureOrSuccessOptionStorage}) = _$_GeofenceState;

  @override
  GeofenceService get geofenceService;
  @override //
  List<GeofenceCoordinate> get geofenceCoordinates;
  @override
  GeofenceCoordinate get nearestCoordinates;
  @override
  Location get currentLocation;
  @override //
  bool get isGetting;
  @override
  Option<Either<GeofenceFailure, List<GeofenceResponse>>>
      get failureOrSuccessOption;
  @override // GEOFENCE STORAGE ACTIVITY
  Option<Either<GeofenceFailure, Unit>> get failureOrSuccessOptionStorage;
  @override
  @JsonKey(ignore: true)
  _$$_GeofenceStateCopyWith<_$_GeofenceState> get copyWith =>
      throw _privateConstructorUsedError;
}
