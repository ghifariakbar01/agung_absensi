// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'riwayat_absen_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

RiwayatAbsenModel _$RiwayatAbsenModelFromJson(Map<String, dynamic> json) {
  return _RiwayatAbsenModel.fromJson(json);
}

/// @nodoc
mixin _$RiwayatAbsenModel {
  String? get tgl => throw _privateConstructorUsedError;
  @JsonKey(name: 'jam_awal')
  String? get jamAwal => throw _privateConstructorUsedError;
  @JsonKey(name: 'jam_akhir')
  String? get jamAkhir => throw _privateConstructorUsedError;
  @JsonKey(name: 'lokasi_masuk')
  String? get lokasiMasuk => throw _privateConstructorUsedError;
  @JsonKey(name: 'lokasi_keluar')
  String? get lokasiKeluar => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RiwayatAbsenModelCopyWith<RiwayatAbsenModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RiwayatAbsenModelCopyWith<$Res> {
  factory $RiwayatAbsenModelCopyWith(
          RiwayatAbsenModel value, $Res Function(RiwayatAbsenModel) then) =
      _$RiwayatAbsenModelCopyWithImpl<$Res, RiwayatAbsenModel>;
  @useResult
  $Res call(
      {String? tgl,
      @JsonKey(name: 'jam_awal') String? jamAwal,
      @JsonKey(name: 'jam_akhir') String? jamAkhir,
      @JsonKey(name: 'lokasi_masuk') String? lokasiMasuk,
      @JsonKey(name: 'lokasi_keluar') String? lokasiKeluar});
}

/// @nodoc
class _$RiwayatAbsenModelCopyWithImpl<$Res, $Val extends RiwayatAbsenModel>
    implements $RiwayatAbsenModelCopyWith<$Res> {
  _$RiwayatAbsenModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tgl = freezed,
    Object? jamAwal = freezed,
    Object? jamAkhir = freezed,
    Object? lokasiMasuk = freezed,
    Object? lokasiKeluar = freezed,
  }) {
    return _then(_value.copyWith(
      tgl: freezed == tgl
          ? _value.tgl
          : tgl // ignore: cast_nullable_to_non_nullable
              as String?,
      jamAwal: freezed == jamAwal
          ? _value.jamAwal
          : jamAwal // ignore: cast_nullable_to_non_nullable
              as String?,
      jamAkhir: freezed == jamAkhir
          ? _value.jamAkhir
          : jamAkhir // ignore: cast_nullable_to_non_nullable
              as String?,
      lokasiMasuk: freezed == lokasiMasuk
          ? _value.lokasiMasuk
          : lokasiMasuk // ignore: cast_nullable_to_non_nullable
              as String?,
      lokasiKeluar: freezed == lokasiKeluar
          ? _value.lokasiKeluar
          : lokasiKeluar // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_RiwayatAbsenModelCopyWith<$Res>
    implements $RiwayatAbsenModelCopyWith<$Res> {
  factory _$$_RiwayatAbsenModelCopyWith(_$_RiwayatAbsenModel value,
          $Res Function(_$_RiwayatAbsenModel) then) =
      __$$_RiwayatAbsenModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? tgl,
      @JsonKey(name: 'jam_awal') String? jamAwal,
      @JsonKey(name: 'jam_akhir') String? jamAkhir,
      @JsonKey(name: 'lokasi_masuk') String? lokasiMasuk,
      @JsonKey(name: 'lokasi_keluar') String? lokasiKeluar});
}

/// @nodoc
class __$$_RiwayatAbsenModelCopyWithImpl<$Res>
    extends _$RiwayatAbsenModelCopyWithImpl<$Res, _$_RiwayatAbsenModel>
    implements _$$_RiwayatAbsenModelCopyWith<$Res> {
  __$$_RiwayatAbsenModelCopyWithImpl(
      _$_RiwayatAbsenModel _value, $Res Function(_$_RiwayatAbsenModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tgl = freezed,
    Object? jamAwal = freezed,
    Object? jamAkhir = freezed,
    Object? lokasiMasuk = freezed,
    Object? lokasiKeluar = freezed,
  }) {
    return _then(_$_RiwayatAbsenModel(
      tgl: freezed == tgl
          ? _value.tgl
          : tgl // ignore: cast_nullable_to_non_nullable
              as String?,
      jamAwal: freezed == jamAwal
          ? _value.jamAwal
          : jamAwal // ignore: cast_nullable_to_non_nullable
              as String?,
      jamAkhir: freezed == jamAkhir
          ? _value.jamAkhir
          : jamAkhir // ignore: cast_nullable_to_non_nullable
              as String?,
      lokasiMasuk: freezed == lokasiMasuk
          ? _value.lokasiMasuk
          : lokasiMasuk // ignore: cast_nullable_to_non_nullable
              as String?,
      lokasiKeluar: freezed == lokasiKeluar
          ? _value.lokasiKeluar
          : lokasiKeluar // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_RiwayatAbsenModel implements _RiwayatAbsenModel {
  const _$_RiwayatAbsenModel(
      {required this.tgl,
      @JsonKey(name: 'jam_awal') required this.jamAwal,
      @JsonKey(name: 'jam_akhir') required this.jamAkhir,
      @JsonKey(name: 'lokasi_masuk') required this.lokasiMasuk,
      @JsonKey(name: 'lokasi_keluar') required this.lokasiKeluar});

  factory _$_RiwayatAbsenModel.fromJson(Map<String, dynamic> json) =>
      _$$_RiwayatAbsenModelFromJson(json);

  @override
  final String? tgl;
  @override
  @JsonKey(name: 'jam_awal')
  final String? jamAwal;
  @override
  @JsonKey(name: 'jam_akhir')
  final String? jamAkhir;
  @override
  @JsonKey(name: 'lokasi_masuk')
  final String? lokasiMasuk;
  @override
  @JsonKey(name: 'lokasi_keluar')
  final String? lokasiKeluar;

  @override
  String toString() {
    return 'RiwayatAbsenModel(tgl: $tgl, jamAwal: $jamAwal, jamAkhir: $jamAkhir, lokasiMasuk: $lokasiMasuk, lokasiKeluar: $lokasiKeluar)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RiwayatAbsenModel &&
            (identical(other.tgl, tgl) || other.tgl == tgl) &&
            (identical(other.jamAwal, jamAwal) || other.jamAwal == jamAwal) &&
            (identical(other.jamAkhir, jamAkhir) ||
                other.jamAkhir == jamAkhir) &&
            (identical(other.lokasiMasuk, lokasiMasuk) ||
                other.lokasiMasuk == lokasiMasuk) &&
            (identical(other.lokasiKeluar, lokasiKeluar) ||
                other.lokasiKeluar == lokasiKeluar));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, tgl, jamAwal, jamAkhir, lokasiMasuk, lokasiKeluar);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RiwayatAbsenModelCopyWith<_$_RiwayatAbsenModel> get copyWith =>
      __$$_RiwayatAbsenModelCopyWithImpl<_$_RiwayatAbsenModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_RiwayatAbsenModelToJson(
      this,
    );
  }
}

abstract class _RiwayatAbsenModel implements RiwayatAbsenModel {
  const factory _RiwayatAbsenModel(
      {required final String? tgl,
      @JsonKey(name: 'jam_awal')
          required final String? jamAwal,
      @JsonKey(name: 'jam_akhir')
          required final String? jamAkhir,
      @JsonKey(name: 'lokasi_masuk')
          required final String? lokasiMasuk,
      @JsonKey(name: 'lokasi_keluar')
          required final String? lokasiKeluar}) = _$_RiwayatAbsenModel;

  factory _RiwayatAbsenModel.fromJson(Map<String, dynamic> json) =
      _$_RiwayatAbsenModel.fromJson;

  @override
  String? get tgl;
  @override
  @JsonKey(name: 'jam_awal')
  String? get jamAwal;
  @override
  @JsonKey(name: 'jam_akhir')
  String? get jamAkhir;
  @override
  @JsonKey(name: 'lokasi_masuk')
  String? get lokasiMasuk;
  @override
  @JsonKey(name: 'lokasi_keluar')
  String? get lokasiKeluar;
  @override
  @JsonKey(ignore: true)
  _$$_RiwayatAbsenModelCopyWith<_$_RiwayatAbsenModel> get copyWith =>
      throw _privateConstructorUsedError;
}
