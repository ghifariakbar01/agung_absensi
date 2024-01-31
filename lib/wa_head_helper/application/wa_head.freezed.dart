// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wa_head.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

WaHead _$WaHeadFromJson(Map<String, dynamic> json) {
  return _WaHead.fromJson(json);
}

/// @nodoc
mixin _$WaHead {
  @JsonKey(name: 'id_user_head')
  int? get idUserHead => throw _privateConstructorUsedError;
  @JsonKey(name: 'idkary')
  String? get idKary => throw _privateConstructorUsedError;
  @JsonKey(name: 'nama')
  String? get nama => throw _privateConstructorUsedError;
  @JsonKey(name: 'telp1')
  String? get telp1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'telp2')
  String? get telp2 => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WaHeadCopyWith<WaHead> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WaHeadCopyWith<$Res> {
  factory $WaHeadCopyWith(WaHead value, $Res Function(WaHead) then) =
      _$WaHeadCopyWithImpl<$Res, WaHead>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id_user_head') int? idUserHead,
      @JsonKey(name: 'idkary') String? idKary,
      @JsonKey(name: 'nama') String? nama,
      @JsonKey(name: 'telp1') String? telp1,
      @JsonKey(name: 'telp2') String? telp2});
}

/// @nodoc
class _$WaHeadCopyWithImpl<$Res, $Val extends WaHead>
    implements $WaHeadCopyWith<$Res> {
  _$WaHeadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idUserHead = freezed,
    Object? idKary = freezed,
    Object? nama = freezed,
    Object? telp1 = freezed,
    Object? telp2 = freezed,
  }) {
    return _then(_value.copyWith(
      idUserHead: freezed == idUserHead
          ? _value.idUserHead
          : idUserHead // ignore: cast_nullable_to_non_nullable
              as int?,
      idKary: freezed == idKary
          ? _value.idKary
          : idKary // ignore: cast_nullable_to_non_nullable
              as String?,
      nama: freezed == nama
          ? _value.nama
          : nama // ignore: cast_nullable_to_non_nullable
              as String?,
      telp1: freezed == telp1
          ? _value.telp1
          : telp1 // ignore: cast_nullable_to_non_nullable
              as String?,
      telp2: freezed == telp2
          ? _value.telp2
          : telp2 // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_WaHeadCopyWith<$Res> implements $WaHeadCopyWith<$Res> {
  factory _$$_WaHeadCopyWith(_$_WaHead value, $Res Function(_$_WaHead) then) =
      __$$_WaHeadCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id_user_head') int? idUserHead,
      @JsonKey(name: 'idkary') String? idKary,
      @JsonKey(name: 'nama') String? nama,
      @JsonKey(name: 'telp1') String? telp1,
      @JsonKey(name: 'telp2') String? telp2});
}

/// @nodoc
class __$$_WaHeadCopyWithImpl<$Res>
    extends _$WaHeadCopyWithImpl<$Res, _$_WaHead>
    implements _$$_WaHeadCopyWith<$Res> {
  __$$_WaHeadCopyWithImpl(_$_WaHead _value, $Res Function(_$_WaHead) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idUserHead = freezed,
    Object? idKary = freezed,
    Object? nama = freezed,
    Object? telp1 = freezed,
    Object? telp2 = freezed,
  }) {
    return _then(_$_WaHead(
      idUserHead: freezed == idUserHead
          ? _value.idUserHead
          : idUserHead // ignore: cast_nullable_to_non_nullable
              as int?,
      idKary: freezed == idKary
          ? _value.idKary
          : idKary // ignore: cast_nullable_to_non_nullable
              as String?,
      nama: freezed == nama
          ? _value.nama
          : nama // ignore: cast_nullable_to_non_nullable
              as String?,
      telp1: freezed == telp1
          ? _value.telp1
          : telp1 // ignore: cast_nullable_to_non_nullable
              as String?,
      telp2: freezed == telp2
          ? _value.telp2
          : telp2 // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_WaHead implements _WaHead {
  _$_WaHead(
      {@JsonKey(name: 'id_user_head') this.idUserHead,
      @JsonKey(name: 'idkary') this.idKary,
      @JsonKey(name: 'nama') this.nama,
      @JsonKey(name: 'telp1') this.telp1,
      @JsonKey(name: 'telp2') this.telp2});

  factory _$_WaHead.fromJson(Map<String, dynamic> json) =>
      _$$_WaHeadFromJson(json);

  @override
  @JsonKey(name: 'id_user_head')
  final int? idUserHead;
  @override
  @JsonKey(name: 'idkary')
  final String? idKary;
  @override
  @JsonKey(name: 'nama')
  final String? nama;
  @override
  @JsonKey(name: 'telp1')
  final String? telp1;
  @override
  @JsonKey(name: 'telp2')
  final String? telp2;

  @override
  String toString() {
    return 'WaHead(idUserHead: $idUserHead, idKary: $idKary, nama: $nama, telp1: $telp1, telp2: $telp2)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_WaHead &&
            (identical(other.idUserHead, idUserHead) ||
                other.idUserHead == idUserHead) &&
            (identical(other.idKary, idKary) || other.idKary == idKary) &&
            (identical(other.nama, nama) || other.nama == nama) &&
            (identical(other.telp1, telp1) || other.telp1 == telp1) &&
            (identical(other.telp2, telp2) || other.telp2 == telp2));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, idUserHead, idKary, nama, telp1, telp2);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_WaHeadCopyWith<_$_WaHead> get copyWith =>
      __$$_WaHeadCopyWithImpl<_$_WaHead>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_WaHeadToJson(
      this,
    );
  }
}

abstract class _WaHead implements WaHead {
  factory _WaHead(
      {@JsonKey(name: 'id_user_head') final int? idUserHead,
      @JsonKey(name: 'idkary') final String? idKary,
      @JsonKey(name: 'nama') final String? nama,
      @JsonKey(name: 'telp1') final String? telp1,
      @JsonKey(name: 'telp2') final String? telp2}) = _$_WaHead;

  factory _WaHead.fromJson(Map<String, dynamic> json) = _$_WaHead.fromJson;

  @override
  @JsonKey(name: 'id_user_head')
  int? get idUserHead;
  @override
  @JsonKey(name: 'idkary')
  String? get idKary;
  @override
  @JsonKey(name: 'nama')
  String? get nama;
  @override
  @JsonKey(name: 'telp1')
  String? get telp1;
  @override
  @JsonKey(name: 'telp2')
  String? get telp2;
  @override
  @JsonKey(ignore: true)
  _$$_WaHeadCopyWith<_$_WaHead> get copyWith =>
      throw _privateConstructorUsedError;
}
