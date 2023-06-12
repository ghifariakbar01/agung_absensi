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
  List<Geofence> get geofenceList => throw _privateConstructorUsedError;
  List<double> get remainingDistance => throw _privateConstructorUsedError;
  int get nearestIndex => throw _privateConstructorUsedError;
  Location get currentLocation => throw _privateConstructorUsedError;

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
      {List<Geofence> geofenceList,
      List<double> remainingDistance,
      int nearestIndex,
      Location currentLocation});
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
    Object? geofenceList = null,
    Object? remainingDistance = null,
    Object? nearestIndex = null,
    Object? currentLocation = null,
  }) {
    return _then(_value.copyWith(
      geofenceList: null == geofenceList
          ? _value.geofenceList
          : geofenceList // ignore: cast_nullable_to_non_nullable
              as List<Geofence>,
      remainingDistance: null == remainingDistance
          ? _value.remainingDistance
          : remainingDistance // ignore: cast_nullable_to_non_nullable
              as List<double>,
      nearestIndex: null == nearestIndex
          ? _value.nearestIndex
          : nearestIndex // ignore: cast_nullable_to_non_nullable
              as int,
      currentLocation: null == currentLocation
          ? _value.currentLocation
          : currentLocation // ignore: cast_nullable_to_non_nullable
              as Location,
    ) as $Val);
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
      {List<Geofence> geofenceList,
      List<double> remainingDistance,
      int nearestIndex,
      Location currentLocation});
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
    Object? geofenceList = null,
    Object? remainingDistance = null,
    Object? nearestIndex = null,
    Object? currentLocation = null,
  }) {
    return _then(_$_GeofenceState(
      geofenceList: null == geofenceList
          ? _value._geofenceList
          : geofenceList // ignore: cast_nullable_to_non_nullable
              as List<Geofence>,
      remainingDistance: null == remainingDistance
          ? _value._remainingDistance
          : remainingDistance // ignore: cast_nullable_to_non_nullable
              as List<double>,
      nearestIndex: null == nearestIndex
          ? _value.nearestIndex
          : nearestIndex // ignore: cast_nullable_to_non_nullable
              as int,
      currentLocation: null == currentLocation
          ? _value.currentLocation
          : currentLocation // ignore: cast_nullable_to_non_nullable
              as Location,
    ));
  }
}

/// @nodoc

class _$_GeofenceState implements _GeofenceState {
  const _$_GeofenceState(
      {required final List<Geofence> geofenceList,
      required final List<double> remainingDistance,
      required this.nearestIndex,
      required this.currentLocation})
      : _geofenceList = geofenceList,
        _remainingDistance = remainingDistance;

  final List<Geofence> _geofenceList;
  @override
  List<Geofence> get geofenceList {
    if (_geofenceList is EqualUnmodifiableListView) return _geofenceList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_geofenceList);
  }

  final List<double> _remainingDistance;
  @override
  List<double> get remainingDistance {
    if (_remainingDistance is EqualUnmodifiableListView)
      return _remainingDistance;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_remainingDistance);
  }

  @override
  final int nearestIndex;
  @override
  final Location currentLocation;

  @override
  String toString() {
    return 'GeofenceState(geofenceList: $geofenceList, remainingDistance: $remainingDistance, nearestIndex: $nearestIndex, currentLocation: $currentLocation)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GeofenceState &&
            const DeepCollectionEquality()
                .equals(other._geofenceList, _geofenceList) &&
            const DeepCollectionEquality()
                .equals(other._remainingDistance, _remainingDistance) &&
            (identical(other.nearestIndex, nearestIndex) ||
                other.nearestIndex == nearestIndex) &&
            (identical(other.currentLocation, currentLocation) ||
                other.currentLocation == currentLocation));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_geofenceList),
      const DeepCollectionEquality().hash(_remainingDistance),
      nearestIndex,
      currentLocation);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GeofenceStateCopyWith<_$_GeofenceState> get copyWith =>
      __$$_GeofenceStateCopyWithImpl<_$_GeofenceState>(this, _$identity);
}

abstract class _GeofenceState implements GeofenceState {
  const factory _GeofenceState(
      {required final List<Geofence> geofenceList,
      required final List<double> remainingDistance,
      required final int nearestIndex,
      required final Location currentLocation}) = _$_GeofenceState;

  @override
  List<Geofence> get geofenceList;
  @override
  List<double> get remainingDistance;
  @override
  int get nearestIndex;
  @override
  Location get currentLocation;
  @override
  @JsonKey(ignore: true)
  _$$_GeofenceStateCopyWith<_$_GeofenceState> get copyWith =>
      throw _privateConstructorUsedError;
}
