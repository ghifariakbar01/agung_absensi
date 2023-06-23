// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geofence_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GeofenceResponse _$GeofenceResponseFromJson(Map<String, dynamic> json) {
  return _GeofenceResponse.fromJson(json);
}

/// @nodoc
mixin _$GeofenceResponse {
  @JsonKey(name: 'id_geof')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'nm_lokasi')
  String get namaLokasi => throw _privateConstructorUsedError;
  @JsonKey(name: 'geof')
  String get latLong => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GeofenceResponseCopyWith<GeofenceResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeofenceResponseCopyWith<$Res> {
  factory $GeofenceResponseCopyWith(
          GeofenceResponse value, $Res Function(GeofenceResponse) then) =
      _$GeofenceResponseCopyWithImpl<$Res, GeofenceResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id_geof') int id,
      @JsonKey(name: 'nm_lokasi') String namaLokasi,
      @JsonKey(name: 'geof') String latLong});
}

/// @nodoc
class _$GeofenceResponseCopyWithImpl<$Res, $Val extends GeofenceResponse>
    implements $GeofenceResponseCopyWith<$Res> {
  _$GeofenceResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? namaLokasi = null,
    Object? latLong = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      namaLokasi: null == namaLokasi
          ? _value.namaLokasi
          : namaLokasi // ignore: cast_nullable_to_non_nullable
              as String,
      latLong: null == latLong
          ? _value.latLong
          : latLong // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GeofenceResponseCopyWith<$Res>
    implements $GeofenceResponseCopyWith<$Res> {
  factory _$$_GeofenceResponseCopyWith(
          _$_GeofenceResponse value, $Res Function(_$_GeofenceResponse) then) =
      __$$_GeofenceResponseCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id_geof') int id,
      @JsonKey(name: 'nm_lokasi') String namaLokasi,
      @JsonKey(name: 'geof') String latLong});
}

/// @nodoc
class __$$_GeofenceResponseCopyWithImpl<$Res>
    extends _$GeofenceResponseCopyWithImpl<$Res, _$_GeofenceResponse>
    implements _$$_GeofenceResponseCopyWith<$Res> {
  __$$_GeofenceResponseCopyWithImpl(
      _$_GeofenceResponse _value, $Res Function(_$_GeofenceResponse) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? namaLokasi = null,
    Object? latLong = null,
  }) {
    return _then(_$_GeofenceResponse(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      namaLokasi: null == namaLokasi
          ? _value.namaLokasi
          : namaLokasi // ignore: cast_nullable_to_non_nullable
              as String,
      latLong: null == latLong
          ? _value.latLong
          : latLong // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_GeofenceResponse implements _GeofenceResponse {
  const _$_GeofenceResponse(
      {@JsonKey(name: 'id_geof') required this.id,
      @JsonKey(name: 'nm_lokasi') required this.namaLokasi,
      @JsonKey(name: 'geof') required this.latLong});

  factory _$_GeofenceResponse.fromJson(Map<String, dynamic> json) =>
      _$$_GeofenceResponseFromJson(json);

  @override
  @JsonKey(name: 'id_geof')
  final int id;
  @override
  @JsonKey(name: 'nm_lokasi')
  final String namaLokasi;
  @override
  @JsonKey(name: 'geof')
  final String latLong;

  @override
  String toString() {
    return 'GeofenceResponse(id: $id, namaLokasi: $namaLokasi, latLong: $latLong)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GeofenceResponse &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.namaLokasi, namaLokasi) ||
                other.namaLokasi == namaLokasi) &&
            (identical(other.latLong, latLong) || other.latLong == latLong));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, namaLokasi, latLong);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GeofenceResponseCopyWith<_$_GeofenceResponse> get copyWith =>
      __$$_GeofenceResponseCopyWithImpl<_$_GeofenceResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GeofenceResponseToJson(
      this,
    );
  }
}

abstract class _GeofenceResponse implements GeofenceResponse {
  const factory _GeofenceResponse(
          {@JsonKey(name: 'id_geof') required final int id,
          @JsonKey(name: 'nm_lokasi') required final String namaLokasi,
          @JsonKey(name: 'geof') required final String latLong}) =
      _$_GeofenceResponse;

  factory _GeofenceResponse.fromJson(Map<String, dynamic> json) =
      _$_GeofenceResponse.fromJson;

  @override
  @JsonKey(name: 'id_geof')
  int get id;
  @override
  @JsonKey(name: 'nm_lokasi')
  String get namaLokasi;
  @override
  @JsonKey(name: 'geof')
  String get latLong;
  @override
  @JsonKey(ignore: true)
  _$$_GeofenceResponseCopyWith<_$_GeofenceResponse> get copyWith =>
      throw _privateConstructorUsedError;
}
