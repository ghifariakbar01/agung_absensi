// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remember_me_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

RememberMeModel _$RememberMeModelFromJson(Map<String, dynamic> json) {
  return _RememberMeModel.fromJson(json);
}

/// @nodoc
mixin _$RememberMeModel {
  String get nik => throw _privateConstructorUsedError;
  String get nama => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get ptName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RememberMeModelCopyWith<RememberMeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RememberMeModelCopyWith<$Res> {
  factory $RememberMeModelCopyWith(
          RememberMeModel value, $Res Function(RememberMeModel) then) =
      _$RememberMeModelCopyWithImpl<$Res, RememberMeModel>;
  @useResult
  $Res call({String nik, String nama, String password, String ptName});
}

/// @nodoc
class _$RememberMeModelCopyWithImpl<$Res, $Val extends RememberMeModel>
    implements $RememberMeModelCopyWith<$Res> {
  _$RememberMeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nik = null,
    Object? nama = null,
    Object? password = null,
    Object? ptName = null,
  }) {
    return _then(_value.copyWith(
      nik: null == nik
          ? _value.nik
          : nik // ignore: cast_nullable_to_non_nullable
              as String,
      nama: null == nama
          ? _value.nama
          : nama // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      ptName: null == ptName
          ? _value.ptName
          : ptName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_RememberMeModelCopyWith<$Res>
    implements $RememberMeModelCopyWith<$Res> {
  factory _$$_RememberMeModelCopyWith(
          _$_RememberMeModel value, $Res Function(_$_RememberMeModel) then) =
      __$$_RememberMeModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String nik, String nama, String password, String ptName});
}

/// @nodoc
class __$$_RememberMeModelCopyWithImpl<$Res>
    extends _$RememberMeModelCopyWithImpl<$Res, _$_RememberMeModel>
    implements _$$_RememberMeModelCopyWith<$Res> {
  __$$_RememberMeModelCopyWithImpl(
      _$_RememberMeModel _value, $Res Function(_$_RememberMeModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nik = null,
    Object? nama = null,
    Object? password = null,
    Object? ptName = null,
  }) {
    return _then(_$_RememberMeModel(
      nik: null == nik
          ? _value.nik
          : nik // ignore: cast_nullable_to_non_nullable
              as String,
      nama: null == nama
          ? _value.nama
          : nama // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      ptName: null == ptName
          ? _value.ptName
          : ptName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_RememberMeModel implements _RememberMeModel {
  const _$_RememberMeModel(
      {required this.nik,
      required this.nama,
      required this.password,
      required this.ptName});

  factory _$_RememberMeModel.fromJson(Map<String, dynamic> json) =>
      _$$_RememberMeModelFromJson(json);

  @override
  final String nik;
  @override
  final String nama;
  @override
  final String password;
  @override
  final String ptName;

  @override
  String toString() {
    return 'RememberMeModel(nik: $nik, nama: $nama, password: $password, ptName: $ptName)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RememberMeModel &&
            (identical(other.nik, nik) || other.nik == nik) &&
            (identical(other.nama, nama) || other.nama == nama) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.ptName, ptName) || other.ptName == ptName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, nik, nama, password, ptName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RememberMeModelCopyWith<_$_RememberMeModel> get copyWith =>
      __$$_RememberMeModelCopyWithImpl<_$_RememberMeModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_RememberMeModelToJson(
      this,
    );
  }
}

abstract class _RememberMeModel implements RememberMeModel {
  const factory _RememberMeModel(
      {required final String nik,
      required final String nama,
      required final String password,
      required final String ptName}) = _$_RememberMeModel;

  factory _RememberMeModel.fromJson(Map<String, dynamic> json) =
      _$_RememberMeModel.fromJson;

  @override
  String get nik;
  @override
  String get nama;
  @override
  String get password;
  @override
  String get ptName;
  @override
  @JsonKey(ignore: true)
  _$$_RememberMeModelCopyWith<_$_RememberMeModel> get copyWith =>
      throw _privateConstructorUsedError;
}
