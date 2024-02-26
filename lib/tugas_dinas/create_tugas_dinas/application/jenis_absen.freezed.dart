// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jenis_absen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

JenisAbsen _$JenisAbsenFromJson(Map<String, dynamic> json) {
  return _JenisAbsen.fromJson(json);
}

/// @nodoc
mixin _$JenisAbsen {
  String get Kode => throw _privateConstructorUsedError;
  String get Nama => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $JenisAbsenCopyWith<JenisAbsen> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JenisAbsenCopyWith<$Res> {
  factory $JenisAbsenCopyWith(
          JenisAbsen value, $Res Function(JenisAbsen) then) =
      _$JenisAbsenCopyWithImpl<$Res, JenisAbsen>;
  @useResult
  $Res call({String Kode, String Nama});
}

/// @nodoc
class _$JenisAbsenCopyWithImpl<$Res, $Val extends JenisAbsen>
    implements $JenisAbsenCopyWith<$Res> {
  _$JenisAbsenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? Kode = null,
    Object? Nama = null,
  }) {
    return _then(_value.copyWith(
      Kode: null == Kode
          ? _value.Kode
          : Kode // ignore: cast_nullable_to_non_nullable
              as String,
      Nama: null == Nama
          ? _value.Nama
          : Nama // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_JenisAbsenCopyWith<$Res>
    implements $JenisAbsenCopyWith<$Res> {
  factory _$$_JenisAbsenCopyWith(
          _$_JenisAbsen value, $Res Function(_$_JenisAbsen) then) =
      __$$_JenisAbsenCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String Kode, String Nama});
}

/// @nodoc
class __$$_JenisAbsenCopyWithImpl<$Res>
    extends _$JenisAbsenCopyWithImpl<$Res, _$_JenisAbsen>
    implements _$$_JenisAbsenCopyWith<$Res> {
  __$$_JenisAbsenCopyWithImpl(
      _$_JenisAbsen _value, $Res Function(_$_JenisAbsen) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? Kode = null,
    Object? Nama = null,
  }) {
    return _then(_$_JenisAbsen(
      Kode: null == Kode
          ? _value.Kode
          : Kode // ignore: cast_nullable_to_non_nullable
              as String,
      Nama: null == Nama
          ? _value.Nama
          : Nama // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_JenisAbsen implements _JenisAbsen {
  _$_JenisAbsen({required this.Kode, required this.Nama});

  factory _$_JenisAbsen.fromJson(Map<String, dynamic> json) =>
      _$$_JenisAbsenFromJson(json);

  @override
  final String Kode;
  @override
  final String Nama;

  @override
  String toString() {
    return 'JenisAbsen(Kode: $Kode, Nama: $Nama)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_JenisAbsen &&
            (identical(other.Kode, Kode) || other.Kode == Kode) &&
            (identical(other.Nama, Nama) || other.Nama == Nama));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, Kode, Nama);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_JenisAbsenCopyWith<_$_JenisAbsen> get copyWith =>
      __$$_JenisAbsenCopyWithImpl<_$_JenisAbsen>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_JenisAbsenToJson(
      this,
    );
  }
}

abstract class _JenisAbsen implements JenisAbsen {
  factory _JenisAbsen(
      {required final String Kode, required final String Nama}) = _$_JenisAbsen;

  factory _JenisAbsen.fromJson(Map<String, dynamic> json) =
      _$_JenisAbsen.fromJson;

  @override
  String get Kode;
  @override
  String get Nama;
  @override
  @JsonKey(ignore: true)
  _$$_JenisAbsenCopyWith<_$_JenisAbsen> get copyWith =>
      throw _privateConstructorUsedError;
}
