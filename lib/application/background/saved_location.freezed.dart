// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SavedLocation _$SavedLocationFromJson(Map<String, dynamic> json) {
  return _SavedLocation.fromJson(json);
}

/// @nodoc
mixin _$SavedLocation {
  String? get idGeof => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  String? get alamat => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  DateTime get dbDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SavedLocationCopyWith<SavedLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavedLocationCopyWith<$Res> {
  factory $SavedLocationCopyWith(
          SavedLocation value, $Res Function(SavedLocation) then) =
      _$SavedLocationCopyWithImpl<$Res, SavedLocation>;
  @useResult
  $Res call(
      {String? idGeof,
      double? latitude,
      double? longitude,
      String? alamat,
      DateTime date,
      DateTime dbDate});
}

/// @nodoc
class _$SavedLocationCopyWithImpl<$Res, $Val extends SavedLocation>
    implements $SavedLocationCopyWith<$Res> {
  _$SavedLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idGeof = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? alamat = freezed,
    Object? date = null,
    Object? dbDate = null,
  }) {
    return _then(_value.copyWith(
      idGeof: freezed == idGeof
          ? _value.idGeof
          : idGeof // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      alamat: freezed == alamat
          ? _value.alamat
          : alamat // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dbDate: null == dbDate
          ? _value.dbDate
          : dbDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SavedLocationCopyWith<$Res>
    implements $SavedLocationCopyWith<$Res> {
  factory _$$_SavedLocationCopyWith(
          _$_SavedLocation value, $Res Function(_$_SavedLocation) then) =
      __$$_SavedLocationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? idGeof,
      double? latitude,
      double? longitude,
      String? alamat,
      DateTime date,
      DateTime dbDate});
}

/// @nodoc
class __$$_SavedLocationCopyWithImpl<$Res>
    extends _$SavedLocationCopyWithImpl<$Res, _$_SavedLocation>
    implements _$$_SavedLocationCopyWith<$Res> {
  __$$_SavedLocationCopyWithImpl(
      _$_SavedLocation _value, $Res Function(_$_SavedLocation) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idGeof = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? alamat = freezed,
    Object? date = null,
    Object? dbDate = null,
  }) {
    return _then(_$_SavedLocation(
      idGeof: freezed == idGeof
          ? _value.idGeof
          : idGeof // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      alamat: freezed == alamat
          ? _value.alamat
          : alamat // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dbDate: null == dbDate
          ? _value.dbDate
          : dbDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SavedLocation implements _SavedLocation {
  const _$_SavedLocation(
      {required this.idGeof,
      required this.latitude,
      required this.longitude,
      required this.alamat,
      required this.date,
      required this.dbDate});

  factory _$_SavedLocation.fromJson(Map<String, dynamic> json) =>
      _$$_SavedLocationFromJson(json);

  @override
  final String? idGeof;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String? alamat;
  @override
  final DateTime date;
  @override
  final DateTime dbDate;

  @override
  String toString() {
    return 'SavedLocation(idGeof: $idGeof, latitude: $latitude, longitude: $longitude, alamat: $alamat, date: $date, dbDate: $dbDate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SavedLocation &&
            (identical(other.idGeof, idGeof) || other.idGeof == idGeof) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.alamat, alamat) || other.alamat == alamat) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.dbDate, dbDate) || other.dbDate == dbDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, idGeof, latitude, longitude, alamat, date, dbDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SavedLocationCopyWith<_$_SavedLocation> get copyWith =>
      __$$_SavedLocationCopyWithImpl<_$_SavedLocation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SavedLocationToJson(
      this,
    );
  }
}

abstract class _SavedLocation implements SavedLocation {
  const factory _SavedLocation(
      {required final String? idGeof,
      required final double? latitude,
      required final double? longitude,
      required final String? alamat,
      required final DateTime date,
      required final DateTime dbDate}) = _$_SavedLocation;

  factory _SavedLocation.fromJson(Map<String, dynamic> json) =
      _$_SavedLocation.fromJson;

  @override
  String? get idGeof;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  String? get alamat;
  @override
  DateTime get date;
  @override
  DateTime get dbDate;
  @override
  @JsonKey(ignore: true)
  _$$_SavedLocationCopyWith<_$_SavedLocation> get copyWith =>
      throw _privateConstructorUsedError;
}
