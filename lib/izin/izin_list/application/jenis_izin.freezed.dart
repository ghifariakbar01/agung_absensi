// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, duplicate_ignore
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jenis_izin.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

JenisIzin _$JenisIzinFromJson(Map<String, dynamic> json) {
  return _JenisIzin.fromJson(json);
}

/// @nodoc
mixin _$JenisIzin {
// ignore: invalid_annotation_target
  @JsonKey(name: 'id_mst_izin')
  int? get idMstIzin => throw _privateConstructorUsedError;
  String? get nama => throw _privateConstructorUsedError;
  int? get qty => throw _privateConstructorUsedError;
  String? get tipe => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $JenisIzinCopyWith<JenisIzin> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JenisIzinCopyWith<$Res> {
  factory $JenisIzinCopyWith(JenisIzin value, $Res Function(JenisIzin) then) =
      _$JenisIzinCopyWithImpl<$Res, JenisIzin>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id_mst_izin') int? idMstIzin,
      String? nama,
      int? qty,
      String? tipe});
}

/// @nodoc
class _$JenisIzinCopyWithImpl<$Res, $Val extends JenisIzin>
    implements $JenisIzinCopyWith<$Res> {
  _$JenisIzinCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idMstIzin = freezed,
    Object? nama = freezed,
    Object? qty = freezed,
    Object? tipe = freezed,
  }) {
    return _then(_value.copyWith(
      idMstIzin: freezed == idMstIzin
          ? _value.idMstIzin
          : idMstIzin // ignore: cast_nullable_to_non_nullable
              as int?,
      nama: freezed == nama
          ? _value.nama
          : nama // ignore: cast_nullable_to_non_nullable
              as String?,
      qty: freezed == qty
          ? _value.qty
          : qty // ignore: cast_nullable_to_non_nullable
              as int?,
      tipe: freezed == tipe
          ? _value.tipe
          : tipe // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_JenisIzinCopyWith<$Res> implements $JenisIzinCopyWith<$Res> {
  factory _$$_JenisIzinCopyWith(
          _$_JenisIzin value, $Res Function(_$_JenisIzin) then) =
      __$$_JenisIzinCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id_mst_izin') int? idMstIzin,
      String? nama,
      int? qty,
      String? tipe});
}

/// @nodoc
class __$$_JenisIzinCopyWithImpl<$Res>
    extends _$JenisIzinCopyWithImpl<$Res, _$_JenisIzin>
    implements _$$_JenisIzinCopyWith<$Res> {
  __$$_JenisIzinCopyWithImpl(
      _$_JenisIzin _value, $Res Function(_$_JenisIzin) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idMstIzin = freezed,
    Object? nama = freezed,
    Object? qty = freezed,
    Object? tipe = freezed,
  }) {
    return _then(_$_JenisIzin(
      idMstIzin: freezed == idMstIzin
          ? _value.idMstIzin
          : idMstIzin // ignore: cast_nullable_to_non_nullable
              as int?,
      nama: freezed == nama
          ? _value.nama
          : nama // ignore: cast_nullable_to_non_nullable
              as String?,
      qty: freezed == qty
          ? _value.qty
          : qty // ignore: cast_nullable_to_non_nullable
              as int?,
      tipe: freezed == tipe
          ? _value.tipe
          : tipe // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_JenisIzin implements _JenisIzin {
  const _$_JenisIzin(
      {@JsonKey(name: 'id_mst_izin') this.idMstIzin,
      this.nama,
      this.qty,
      this.tipe});

  factory _$_JenisIzin.fromJson(Map<String, dynamic> json) =>
      _$$_JenisIzinFromJson(json);

// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'id_mst_izin')
  final int? idMstIzin;
  @override
  final String? nama;
  @override
  final int? qty;
  @override
  final String? tipe;

  @override
  String toString() {
    return 'JenisIzin(idMstIzin: $idMstIzin, nama: $nama, qty: $qty, tipe: $tipe)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_JenisIzin &&
            (identical(other.idMstIzin, idMstIzin) ||
                other.idMstIzin == idMstIzin) &&
            (identical(other.nama, nama) || other.nama == nama) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.tipe, tipe) || other.tipe == tipe));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, idMstIzin, nama, qty, tipe);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_JenisIzinCopyWith<_$_JenisIzin> get copyWith =>
      __$$_JenisIzinCopyWithImpl<_$_JenisIzin>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_JenisIzinToJson(
      this,
    );
  }
}

abstract class _JenisIzin implements JenisIzin {
  const factory _JenisIzin(
      {@JsonKey(name: 'id_mst_izin') final int? idMstIzin,
      final String? nama,
      final int? qty,
      final String? tipe}) = _$_JenisIzin;

  factory _JenisIzin.fromJson(Map<String, dynamic> json) =
      _$_JenisIzin.fromJson;

  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'id_mst_izin')
  int? get idMstIzin;
  @override
  String? get nama;
  @override
  int? get qty;
  @override
  String? get tipe;
  @override
  @JsonKey(ignore: true)
  _$$_JenisIzinCopyWith<_$_JenisIzin> get copyWith =>
      throw _privateConstructorUsedError;
}
