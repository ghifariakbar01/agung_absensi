// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jenis_cuti.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

JenisCuti _$JenisCutiFromJson(Map<String, dynamic> json) {
  return _JenisCuti.fromJson(json);
}

/// @nodoc
mixin _$JenisCuti {
  int get id_jns_cuti => throw _privateConstructorUsedError;
  String get nama => throw _privateConstructorUsedError;
  String get inisial => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $JenisCutiCopyWith<JenisCuti> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JenisCutiCopyWith<$Res> {
  factory $JenisCutiCopyWith(JenisCuti value, $Res Function(JenisCuti) then) =
      _$JenisCutiCopyWithImpl<$Res, JenisCuti>;
  @useResult
  $Res call({int id_jns_cuti, String nama, String inisial});
}

/// @nodoc
class _$JenisCutiCopyWithImpl<$Res, $Val extends JenisCuti>
    implements $JenisCutiCopyWith<$Res> {
  _$JenisCutiCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id_jns_cuti = null,
    Object? nama = null,
    Object? inisial = null,
  }) {
    return _then(_value.copyWith(
      id_jns_cuti: null == id_jns_cuti
          ? _value.id_jns_cuti
          : id_jns_cuti // ignore: cast_nullable_to_non_nullable
              as int,
      nama: null == nama
          ? _value.nama
          : nama // ignore: cast_nullable_to_non_nullable
              as String,
      inisial: null == inisial
          ? _value.inisial
          : inisial // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_JenisCutiCopyWith<$Res> implements $JenisCutiCopyWith<$Res> {
  factory _$$_JenisCutiCopyWith(
          _$_JenisCuti value, $Res Function(_$_JenisCuti) then) =
      __$$_JenisCutiCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id_jns_cuti, String nama, String inisial});
}

/// @nodoc
class __$$_JenisCutiCopyWithImpl<$Res>
    extends _$JenisCutiCopyWithImpl<$Res, _$_JenisCuti>
    implements _$$_JenisCutiCopyWith<$Res> {
  __$$_JenisCutiCopyWithImpl(
      _$_JenisCuti _value, $Res Function(_$_JenisCuti) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id_jns_cuti = null,
    Object? nama = null,
    Object? inisial = null,
  }) {
    return _then(_$_JenisCuti(
      id_jns_cuti: null == id_jns_cuti
          ? _value.id_jns_cuti
          : id_jns_cuti // ignore: cast_nullable_to_non_nullable
              as int,
      nama: null == nama
          ? _value.nama
          : nama // ignore: cast_nullable_to_non_nullable
              as String,
      inisial: null == inisial
          ? _value.inisial
          : inisial // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_JenisCuti implements _JenisCuti {
  _$_JenisCuti(
      {required this.id_jns_cuti, required this.nama, required this.inisial});

  factory _$_JenisCuti.fromJson(Map<String, dynamic> json) =>
      _$$_JenisCutiFromJson(json);

  @override
  final int id_jns_cuti;
  @override
  final String nama;
  @override
  final String inisial;

  @override
  String toString() {
    return 'JenisCuti(id_jns_cuti: $id_jns_cuti, nama: $nama, inisial: $inisial)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_JenisCuti &&
            (identical(other.id_jns_cuti, id_jns_cuti) ||
                other.id_jns_cuti == id_jns_cuti) &&
            (identical(other.nama, nama) || other.nama == nama) &&
            (identical(other.inisial, inisial) || other.inisial == inisial));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id_jns_cuti, nama, inisial);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_JenisCutiCopyWith<_$_JenisCuti> get copyWith =>
      __$$_JenisCutiCopyWithImpl<_$_JenisCuti>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_JenisCutiToJson(
      this,
    );
  }
}

abstract class _JenisCuti implements JenisCuti {
  factory _JenisCuti(
      {required final int id_jns_cuti,
      required final String nama,
      required final String inisial}) = _$_JenisCuti;

  factory _JenisCuti.fromJson(Map<String, dynamic> json) =
      _$_JenisCuti.fromJson;

  @override
  int get id_jns_cuti;
  @override
  String get nama;
  @override
  String get inisial;
  @override
  @JsonKey(ignore: true)
  _$$_JenisCutiCopyWith<_$_JenisCuti> get copyWith =>
      throw _privateConstructorUsedError;
}
