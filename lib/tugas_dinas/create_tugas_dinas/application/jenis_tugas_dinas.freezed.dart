// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jenis_tugas_dinas.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

JenisTugasDinas _$JenisTugasDinasFromJson(Map<String, dynamic> json) {
  return _JenisTugasDinas.fromJson(json);
}

/// @nodoc
mixin _$JenisTugasDinas {
  int get id => throw _privateConstructorUsedError;
  String get kode => throw _privateConstructorUsedError;
  String get kategori => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $JenisTugasDinasCopyWith<JenisTugasDinas> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JenisTugasDinasCopyWith<$Res> {
  factory $JenisTugasDinasCopyWith(
          JenisTugasDinas value, $Res Function(JenisTugasDinas) then) =
      _$JenisTugasDinasCopyWithImpl<$Res, JenisTugasDinas>;
  @useResult
  $Res call({int id, String kode, String kategori});
}

/// @nodoc
class _$JenisTugasDinasCopyWithImpl<$Res, $Val extends JenisTugasDinas>
    implements $JenisTugasDinasCopyWith<$Res> {
  _$JenisTugasDinasCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? kode = null,
    Object? kategori = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      kode: null == kode
          ? _value.kode
          : kode // ignore: cast_nullable_to_non_nullable
              as String,
      kategori: null == kategori
          ? _value.kategori
          : kategori // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_JenisTugasDinasCopyWith<$Res>
    implements $JenisTugasDinasCopyWith<$Res> {
  factory _$$_JenisTugasDinasCopyWith(
          _$_JenisTugasDinas value, $Res Function(_$_JenisTugasDinas) then) =
      __$$_JenisTugasDinasCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String kode, String kategori});
}

/// @nodoc
class __$$_JenisTugasDinasCopyWithImpl<$Res>
    extends _$JenisTugasDinasCopyWithImpl<$Res, _$_JenisTugasDinas>
    implements _$$_JenisTugasDinasCopyWith<$Res> {
  __$$_JenisTugasDinasCopyWithImpl(
      _$_JenisTugasDinas _value, $Res Function(_$_JenisTugasDinas) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? kode = null,
    Object? kategori = null,
  }) {
    return _then(_$_JenisTugasDinas(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      kode: null == kode
          ? _value.kode
          : kode // ignore: cast_nullable_to_non_nullable
              as String,
      kategori: null == kategori
          ? _value.kategori
          : kategori // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_JenisTugasDinas implements _JenisTugasDinas {
  const _$_JenisTugasDinas(
      {required this.id, required this.kode, required this.kategori});

  factory _$_JenisTugasDinas.fromJson(Map<String, dynamic> json) =>
      _$$_JenisTugasDinasFromJson(json);

  @override
  final int id;
  @override
  final String kode;
  @override
  final String kategori;

  @override
  String toString() {
    return 'JenisTugasDinas(id: $id, kode: $kode, kategori: $kategori)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_JenisTugasDinas &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.kode, kode) || other.kode == kode) &&
            (identical(other.kategori, kategori) ||
                other.kategori == kategori));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, kode, kategori);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_JenisTugasDinasCopyWith<_$_JenisTugasDinas> get copyWith =>
      __$$_JenisTugasDinasCopyWithImpl<_$_JenisTugasDinas>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_JenisTugasDinasToJson(
      this,
    );
  }
}

abstract class _JenisTugasDinas implements JenisTugasDinas {
  const factory _JenisTugasDinas(
      {required final int id,
      required final String kode,
      required final String kategori}) = _$_JenisTugasDinas;

  factory _JenisTugasDinas.fromJson(Map<String, dynamic> json) =
      _$_JenisTugasDinas.fromJson;

  @override
  int get id;
  @override
  String get kode;
  @override
  String get kategori;
  @override
  @JsonKey(ignore: true)
  _$$_JenisTugasDinasCopyWith<_$_JenisTugasDinas> get copyWith =>
      throw _privateConstructorUsedError;
}
