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
  List<GeofenceCoordinate> get geofenceCoordinates =>
      throw _privateConstructorUsedError;
  GeofenceCoordinate get nearestCoordinates =>
      throw _privateConstructorUsedError;
  Location get currentLocation => throw _privateConstructorUsedError; //
  List<GeofenceCoordinate> get geofenceCoordinatesSaved =>
      throw _privateConstructorUsedError;
  List<GeofenceCoordinate> get nearestCoordinatesSaved =>
      throw _privateConstructorUsedError; //
  bool get isGetting => throw _privateConstructorUsedError;
  Option<Either<GeofenceFailure, List<GeofenceResponse>>>
      get failureOrSuccessOption => throw _privateConstructorUsedError;

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
      {List<GeofenceCoordinate> geofenceCoordinates,
      GeofenceCoordinate nearestCoordinates,
      Location currentLocation,
      List<GeofenceCoordinate> geofenceCoordinatesSaved,
      List<GeofenceCoordinate> nearestCoordinatesSaved,
      bool isGetting,
      Option<Either<GeofenceFailure, List<GeofenceResponse>>>
          failureOrSuccessOption});

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
    Object? geofenceCoordinates = null,
    Object? nearestCoordinates = null,
    Object? currentLocation = null,
    Object? geofenceCoordinatesSaved = null,
    Object? nearestCoordinatesSaved = null,
    Object? isGetting = null,
    Object? failureOrSuccessOption = null,
  }) {
    return _then(_value.copyWith(
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
      geofenceCoordinatesSaved: null == geofenceCoordinatesSaved
          ? _value.geofenceCoordinatesSaved
          : geofenceCoordinatesSaved // ignore: cast_nullable_to_non_nullable
              as List<GeofenceCoordinate>,
      nearestCoordinatesSaved: null == nearestCoordinatesSaved
          ? _value.nearestCoordinatesSaved
          : nearestCoordinatesSaved // ignore: cast_nullable_to_non_nullable
              as List<GeofenceCoordinate>,
      isGetting: null == isGetting
          ? _value.isGetting
          : isGetting // ignore: cast_nullable_to_non_nullable
              as bool,
      failureOrSuccessOption: null == failureOrSuccessOption
          ? _value.failureOrSuccessOption
          : failureOrSuccessOption // ignore: cast_nullable_to_non_nullable
              as Option<Either<GeofenceFailure, List<GeofenceResponse>>>,
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
      {List<GeofenceCoordinate> geofenceCoordinates,
      GeofenceCoordinate nearestCoordinates,
      Location currentLocation,
      List<GeofenceCoordinate> geofenceCoordinatesSaved,
      List<GeofenceCoordinate> nearestCoordinatesSaved,
      bool isGetting,
      Option<Either<GeofenceFailure, List<GeofenceResponse>>>
          failureOrSuccessOption});

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
    Object? geofenceCoordinates = null,
    Object? nearestCoordinates = null,
    Object? currentLocation = null,
    Object? geofenceCoordinatesSaved = null,
    Object? nearestCoordinatesSaved = null,
    Object? isGetting = null,
    Object? failureOrSuccessOption = null,
  }) {
    return _then(_$_GeofenceState(
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
      geofenceCoordinatesSaved: null == geofenceCoordinatesSaved
          ? _value._geofenceCoordinatesSaved
          : geofenceCoordinatesSaved // ignore: cast_nullable_to_non_nullable
              as List<GeofenceCoordinate>,
      nearestCoordinatesSaved: null == nearestCoordinatesSaved
          ? _value._nearestCoordinatesSaved
          : nearestCoordinatesSaved // ignore: cast_nullable_to_non_nullable
              as List<GeofenceCoordinate>,
      isGetting: null == isGetting
          ? _value.isGetting
          : isGetting // ignore: cast_nullable_to_non_nullable
              as bool,
      failureOrSuccessOption: null == failureOrSuccessOption
          ? _value.failureOrSuccessOption
          : failureOrSuccessOption // ignore: cast_nullable_to_non_nullable
              as Option<Either<GeofenceFailure, List<GeofenceResponse>>>,
    ));
  }
}

/// @nodoc

class _$_GeofenceState implements _GeofenceState {
  const _$_GeofenceState(
      {required final List<GeofenceCoordinate> geofenceCoordinates,
      required this.nearestCoordinates,
      required this.currentLocation,
      required final List<GeofenceCoordinate> geofenceCoordinatesSaved,
      required final List<GeofenceCoordinate> nearestCoordinatesSaved,
      required this.isGetting,
      required this.failureOrSuccessOption})
      : _geofenceCoordinates = geofenceCoordinates,
        _geofenceCoordinatesSaved = geofenceCoordinatesSaved,
        _nearestCoordinatesSaved = nearestCoordinatesSaved;

  final List<GeofenceCoordinate> _geofenceCoordinates;
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
  final List<GeofenceCoordinate> _geofenceCoordinatesSaved;
//
  @override
  List<GeofenceCoordinate> get geofenceCoordinatesSaved {
    if (_geofenceCoordinatesSaved is EqualUnmodifiableListView)
      return _geofenceCoordinatesSaved;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_geofenceCoordinatesSaved);
  }

  final List<GeofenceCoordinate> _nearestCoordinatesSaved;
  @override
  List<GeofenceCoordinate> get nearestCoordinatesSaved {
    if (_nearestCoordinatesSaved is EqualUnmodifiableListView)
      return _nearestCoordinatesSaved;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nearestCoordinatesSaved);
  }

//
  @override
  final bool isGetting;
  @override
  final Option<Either<GeofenceFailure, List<GeofenceResponse>>>
      failureOrSuccessOption;

  @override
  String toString() {
    return 'GeofenceState(geofenceCoordinates: $geofenceCoordinates, nearestCoordinates: $nearestCoordinates, currentLocation: $currentLocation, geofenceCoordinatesSaved: $geofenceCoordinatesSaved, nearestCoordinatesSaved: $nearestCoordinatesSaved, isGetting: $isGetting, failureOrSuccessOption: $failureOrSuccessOption)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GeofenceState &&
            const DeepCollectionEquality()
                .equals(other._geofenceCoordinates, _geofenceCoordinates) &&
            (identical(other.nearestCoordinates, nearestCoordinates) ||
                other.nearestCoordinates == nearestCoordinates) &&
            (identical(other.currentLocation, currentLocation) ||
                other.currentLocation == currentLocation) &&
            const DeepCollectionEquality().equals(
                other._geofenceCoordinatesSaved, _geofenceCoordinatesSaved) &&
            const DeepCollectionEquality().equals(
                other._nearestCoordinatesSaved, _nearestCoordinatesSaved) &&
            (identical(other.isGetting, isGetting) ||
                other.isGetting == isGetting) &&
            (identical(other.failureOrSuccessOption, failureOrSuccessOption) ||
                other.failureOrSuccessOption == failureOrSuccessOption));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_geofenceCoordinates),
      nearestCoordinates,
      currentLocation,
      const DeepCollectionEquality().hash(_geofenceCoordinatesSaved),
      const DeepCollectionEquality().hash(_nearestCoordinatesSaved),
      isGetting,
      failureOrSuccessOption);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GeofenceStateCopyWith<_$_GeofenceState> get copyWith =>
      __$$_GeofenceStateCopyWithImpl<_$_GeofenceState>(this, _$identity);
}

abstract class _GeofenceState implements GeofenceState {
  const factory _GeofenceState(
      {required final List<GeofenceCoordinate> geofenceCoordinates,
      required final GeofenceCoordinate nearestCoordinates,
      required final Location currentLocation,
      required final List<GeofenceCoordinate> geofenceCoordinatesSaved,
      required final List<GeofenceCoordinate> nearestCoordinatesSaved,
      required final bool isGetting,
      required final Option<Either<GeofenceFailure, List<GeofenceResponse>>>
          failureOrSuccessOption}) = _$_GeofenceState;

  @override
  List<GeofenceCoordinate> get geofenceCoordinates;
  @override
  GeofenceCoordinate get nearestCoordinates;
  @override
  Location get currentLocation;
  @override //
  List<GeofenceCoordinate> get geofenceCoordinatesSaved;
  @override
  List<GeofenceCoordinate> get nearestCoordinatesSaved;
  @override //
  bool get isGetting;
  @override
  Option<Either<GeofenceFailure, List<GeofenceResponse>>>
      get failureOrSuccessOption;
  @override
  @JsonKey(ignore: true)
  _$$_GeofenceStateCopyWith<_$_GeofenceState> get copyWith =>
      throw _privateConstructorUsedError;
}
