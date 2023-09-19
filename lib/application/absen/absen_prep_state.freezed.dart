// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'absen_prep_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AbsenPrepState {
  String get imei => throw _privateConstructorUsedError;
  String get lokasi => throw _privateConstructorUsedError;
  String get idGeofence => throw _privateConstructorUsedError;
  DateTime get networkTime => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AbsenPrepStateCopyWith<AbsenPrepState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AbsenPrepStateCopyWith<$Res> {
  factory $AbsenPrepStateCopyWith(
          AbsenPrepState value, $Res Function(AbsenPrepState) then) =
      _$AbsenPrepStateCopyWithImpl<$Res, AbsenPrepState>;
  @useResult
  $Res call(
      {String imei, String lokasi, String idGeofence, DateTime networkTime});
}

/// @nodoc
class _$AbsenPrepStateCopyWithImpl<$Res, $Val extends AbsenPrepState>
    implements $AbsenPrepStateCopyWith<$Res> {
  _$AbsenPrepStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imei = null,
    Object? lokasi = null,
    Object? idGeofence = null,
    Object? networkTime = null,
  }) {
    return _then(_value.copyWith(
      imei: null == imei
          ? _value.imei
          : imei // ignore: cast_nullable_to_non_nullable
              as String,
      lokasi: null == lokasi
          ? _value.lokasi
          : lokasi // ignore: cast_nullable_to_non_nullable
              as String,
      idGeofence: null == idGeofence
          ? _value.idGeofence
          : idGeofence // ignore: cast_nullable_to_non_nullable
              as String,
      networkTime: null == networkTime
          ? _value.networkTime
          : networkTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AbsenAuthCopyWith<$Res>
    implements $AbsenPrepStateCopyWith<$Res> {
  factory _$$_AbsenAuthCopyWith(
          _$_AbsenAuth value, $Res Function(_$_AbsenAuth) then) =
      __$$_AbsenAuthCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String imei, String lokasi, String idGeofence, DateTime networkTime});
}

/// @nodoc
class __$$_AbsenAuthCopyWithImpl<$Res>
    extends _$AbsenPrepStateCopyWithImpl<$Res, _$_AbsenAuth>
    implements _$$_AbsenAuthCopyWith<$Res> {
  __$$_AbsenAuthCopyWithImpl(
      _$_AbsenAuth _value, $Res Function(_$_AbsenAuth) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imei = null,
    Object? lokasi = null,
    Object? idGeofence = null,
    Object? networkTime = null,
  }) {
    return _then(_$_AbsenAuth(
      imei: null == imei
          ? _value.imei
          : imei // ignore: cast_nullable_to_non_nullable
              as String,
      lokasi: null == lokasi
          ? _value.lokasi
          : lokasi // ignore: cast_nullable_to_non_nullable
              as String,
      idGeofence: null == idGeofence
          ? _value.idGeofence
          : idGeofence // ignore: cast_nullable_to_non_nullable
              as String,
      networkTime: null == networkTime
          ? _value.networkTime
          : networkTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$_AbsenAuth implements _AbsenAuth {
  const _$_AbsenAuth(
      {required this.imei,
      required this.lokasi,
      required this.idGeofence,
      required this.networkTime});

  @override
  final String imei;
  @override
  final String lokasi;
  @override
  final String idGeofence;
  @override
  final DateTime networkTime;

  @override
  String toString() {
    return 'AbsenPrepState(imei: $imei, lokasi: $lokasi, idGeofence: $idGeofence, networkTime: $networkTime)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AbsenAuth &&
            (identical(other.imei, imei) || other.imei == imei) &&
            (identical(other.lokasi, lokasi) || other.lokasi == lokasi) &&
            (identical(other.idGeofence, idGeofence) ||
                other.idGeofence == idGeofence) &&
            (identical(other.networkTime, networkTime) ||
                other.networkTime == networkTime));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, imei, lokasi, idGeofence, networkTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AbsenAuthCopyWith<_$_AbsenAuth> get copyWith =>
      __$$_AbsenAuthCopyWithImpl<_$_AbsenAuth>(this, _$identity);
}

abstract class _AbsenAuth implements AbsenPrepState {
  const factory _AbsenAuth(
      {required final String imei,
      required final String lokasi,
      required final String idGeofence,
      required final DateTime networkTime}) = _$_AbsenAuth;

  @override
  String get imei;
  @override
  String get lokasi;
  @override
  String get idGeofence;
  @override
  DateTime get networkTime;
  @override
  @JsonKey(ignore: true)
  _$$_AbsenAuthCopyWith<_$_AbsenAuth> get copyWith =>
      throw _privateConstructorUsedError;
}
