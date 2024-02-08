// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geofence_coordinate_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GeofenceCoordinate {
  String get id => throw _privateConstructorUsedError;
  String get nama => throw _privateConstructorUsedError;
  Coordinate get coordinate => throw _privateConstructorUsedError;
  double get minDistance => throw _privateConstructorUsedError;
  double get remainingDistance => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GeofenceCoordinateCopyWith<GeofenceCoordinate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeofenceCoordinateCopyWith<$Res> {
  factory $GeofenceCoordinateCopyWith(
          GeofenceCoordinate value, $Res Function(GeofenceCoordinate) then) =
      _$GeofenceCoordinateCopyWithImpl<$Res, GeofenceCoordinate>;
  @useResult
  $Res call(
      {String id,
      String nama,
      Coordinate coordinate,
      double minDistance,
      double remainingDistance});

  $CoordinateCopyWith<$Res> get coordinate;
}

/// @nodoc
class _$GeofenceCoordinateCopyWithImpl<$Res, $Val extends GeofenceCoordinate>
    implements $GeofenceCoordinateCopyWith<$Res> {
  _$GeofenceCoordinateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nama = null,
    Object? coordinate = null,
    Object? minDistance = null,
    Object? remainingDistance = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nama: null == nama
          ? _value.nama
          : nama // ignore: cast_nullable_to_non_nullable
              as String,
      coordinate: null == coordinate
          ? _value.coordinate
          : coordinate // ignore: cast_nullable_to_non_nullable
              as Coordinate,
      minDistance: null == minDistance
          ? _value.minDistance
          : minDistance // ignore: cast_nullable_to_non_nullable
              as double,
      remainingDistance: null == remainingDistance
          ? _value.remainingDistance
          : remainingDistance // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CoordinateCopyWith<$Res> get coordinate {
    return $CoordinateCopyWith<$Res>(_value.coordinate, (value) {
      return _then(_value.copyWith(coordinate: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_GeofenceCoordinateCopyWith<$Res>
    implements $GeofenceCoordinateCopyWith<$Res> {
  factory _$$_GeofenceCoordinateCopyWith(_$_GeofenceCoordinate value,
          $Res Function(_$_GeofenceCoordinate) then) =
      __$$_GeofenceCoordinateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String nama,
      Coordinate coordinate,
      double minDistance,
      double remainingDistance});

  @override
  $CoordinateCopyWith<$Res> get coordinate;
}

/// @nodoc
class __$$_GeofenceCoordinateCopyWithImpl<$Res>
    extends _$GeofenceCoordinateCopyWithImpl<$Res, _$_GeofenceCoordinate>
    implements _$$_GeofenceCoordinateCopyWith<$Res> {
  __$$_GeofenceCoordinateCopyWithImpl(
      _$_GeofenceCoordinate _value, $Res Function(_$_GeofenceCoordinate) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nama = null,
    Object? coordinate = null,
    Object? minDistance = null,
    Object? remainingDistance = null,
  }) {
    return _then(_$_GeofenceCoordinate(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nama: null == nama
          ? _value.nama
          : nama // ignore: cast_nullable_to_non_nullable
              as String,
      coordinate: null == coordinate
          ? _value.coordinate
          : coordinate // ignore: cast_nullable_to_non_nullable
              as Coordinate,
      minDistance: null == minDistance
          ? _value.minDistance
          : minDistance // ignore: cast_nullable_to_non_nullable
              as double,
      remainingDistance: null == remainingDistance
          ? _value.remainingDistance
          : remainingDistance // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$_GeofenceCoordinate implements _GeofenceCoordinate {
  const _$_GeofenceCoordinate(
      {required this.id,
      required this.nama,
      required this.coordinate,
      required this.minDistance,
      required this.remainingDistance});

  @override
  final String id;
  @override
  final String nama;
  @override
  final Coordinate coordinate;
  @override
  final double minDistance;
  @override
  final double remainingDistance;

  @override
  String toString() {
    return 'GeofenceCoordinate(id: $id, nama: $nama, coordinate: $coordinate, minDistance: $minDistance, remainingDistance: $remainingDistance)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GeofenceCoordinate &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nama, nama) || other.nama == nama) &&
            (identical(other.coordinate, coordinate) ||
                other.coordinate == coordinate) &&
            (identical(other.minDistance, minDistance) ||
                other.minDistance == minDistance) &&
            (identical(other.remainingDistance, remainingDistance) ||
                other.remainingDistance == remainingDistance));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, nama, coordinate, minDistance, remainingDistance);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GeofenceCoordinateCopyWith<_$_GeofenceCoordinate> get copyWith =>
      __$$_GeofenceCoordinateCopyWithImpl<_$_GeofenceCoordinate>(
          this, _$identity);
}

abstract class _GeofenceCoordinate implements GeofenceCoordinate {
  const factory _GeofenceCoordinate(
      {required final String id,
      required final String nama,
      required final Coordinate coordinate,
      required final double minDistance,
      required final double remainingDistance}) = _$_GeofenceCoordinate;

  @override
  String get id;
  @override
  String get nama;
  @override
  Coordinate get coordinate;
  @override
  double get minDistance;
  @override
  double get remainingDistance;
  @override
  @JsonKey(ignore: true)
  _$$_GeofenceCoordinateCopyWith<_$_GeofenceCoordinate> get copyWith =>
      throw _privateConstructorUsedError;
}
