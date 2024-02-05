// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alasan_cuti.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AlasanCuti _$AlasanCutiFromJson(Map<String, dynamic> json) {
  return _AlasanCuti.fromJson(json);
}

/// @nodoc
mixin _$AlasanCuti {
  int get id_emergency => throw _privateConstructorUsedError;
  String get alasan => throw _privateConstructorUsedError;
  String get kode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AlasanCutiCopyWith<AlasanCuti> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlasanCutiCopyWith<$Res> {
  factory $AlasanCutiCopyWith(
          AlasanCuti value, $Res Function(AlasanCuti) then) =
      _$AlasanCutiCopyWithImpl<$Res, AlasanCuti>;
  @useResult
  $Res call({int id_emergency, String alasan, String kode});
}

/// @nodoc
class _$AlasanCutiCopyWithImpl<$Res, $Val extends AlasanCuti>
    implements $AlasanCutiCopyWith<$Res> {
  _$AlasanCutiCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id_emergency = null,
    Object? alasan = null,
    Object? kode = null,
  }) {
    return _then(_value.copyWith(
      id_emergency: null == id_emergency
          ? _value.id_emergency
          : id_emergency // ignore: cast_nullable_to_non_nullable
              as int,
      alasan: null == alasan
          ? _value.alasan
          : alasan // ignore: cast_nullable_to_non_nullable
              as String,
      kode: null == kode
          ? _value.kode
          : kode // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AlasanCutiCopyWith<$Res>
    implements $AlasanCutiCopyWith<$Res> {
  factory _$$_AlasanCutiCopyWith(
          _$_AlasanCuti value, $Res Function(_$_AlasanCuti) then) =
      __$$_AlasanCutiCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id_emergency, String alasan, String kode});
}

/// @nodoc
class __$$_AlasanCutiCopyWithImpl<$Res>
    extends _$AlasanCutiCopyWithImpl<$Res, _$_AlasanCuti>
    implements _$$_AlasanCutiCopyWith<$Res> {
  __$$_AlasanCutiCopyWithImpl(
      _$_AlasanCuti _value, $Res Function(_$_AlasanCuti) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id_emergency = null,
    Object? alasan = null,
    Object? kode = null,
  }) {
    return _then(_$_AlasanCuti(
      id_emergency: null == id_emergency
          ? _value.id_emergency
          : id_emergency // ignore: cast_nullable_to_non_nullable
              as int,
      alasan: null == alasan
          ? _value.alasan
          : alasan // ignore: cast_nullable_to_non_nullable
              as String,
      kode: null == kode
          ? _value.kode
          : kode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AlasanCuti implements _AlasanCuti {
  _$_AlasanCuti(
      {required this.id_emergency, required this.alasan, required this.kode});

  factory _$_AlasanCuti.fromJson(Map<String, dynamic> json) =>
      _$$_AlasanCutiFromJson(json);

  @override
  final int id_emergency;
  @override
  final String alasan;
  @override
  final String kode;

  @override
  String toString() {
    return 'AlasanCuti(id_emergency: $id_emergency, alasan: $alasan, kode: $kode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AlasanCuti &&
            (identical(other.id_emergency, id_emergency) ||
                other.id_emergency == id_emergency) &&
            (identical(other.alasan, alasan) || other.alasan == alasan) &&
            (identical(other.kode, kode) || other.kode == kode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id_emergency, alasan, kode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AlasanCutiCopyWith<_$_AlasanCuti> get copyWith =>
      __$$_AlasanCutiCopyWithImpl<_$_AlasanCuti>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AlasanCutiToJson(
      this,
    );
  }
}

abstract class _AlasanCuti implements AlasanCuti {
  factory _AlasanCuti(
      {required final int id_emergency,
      required final String alasan,
      required final String kode}) = _$_AlasanCuti;

  factory _AlasanCuti.fromJson(Map<String, dynamic> json) =
      _$_AlasanCuti.fromJson;

  @override
  int get id_emergency;
  @override
  String get alasan;
  @override
  String get kode;
  @override
  @JsonKey(ignore: true)
  _$$_AlasanCutiCopyWith<_$_AlasanCuti> get copyWith =>
      throw _privateConstructorUsedError;
}
