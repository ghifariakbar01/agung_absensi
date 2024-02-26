// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserList _$UserListFromJson(Map<String, dynamic> json) {
  return _UserList.fromJson(json);
}

/// @nodoc
mixin _$UserList {
  @JsonKey(name: 'id_user')
  int? get idUser => throw _privateConstructorUsedError;
  @JsonKey(name: 'id_dept')
  int? get idDept => throw _privateConstructorUsedError;
  String? get nama => throw _privateConstructorUsedError;
  @JsonKey(name: 'fullname')
  String? get fullName => throw _privateConstructorUsedError;
  @JsonKey(name: 'no_telp1')
  String? get noTelp1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'no_telp2')
  String? get noTelp2 => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserListCopyWith<UserList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserListCopyWith<$Res> {
  factory $UserListCopyWith(UserList value, $Res Function(UserList) then) =
      _$UserListCopyWithImpl<$Res, UserList>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id_user') int? idUser,
      @JsonKey(name: 'id_dept') int? idDept,
      String? nama,
      @JsonKey(name: 'fullname') String? fullName,
      @JsonKey(name: 'no_telp1') String? noTelp1,
      @JsonKey(name: 'no_telp2') String? noTelp2});
}

/// @nodoc
class _$UserListCopyWithImpl<$Res, $Val extends UserList>
    implements $UserListCopyWith<$Res> {
  _$UserListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idUser = freezed,
    Object? idDept = freezed,
    Object? nama = freezed,
    Object? fullName = freezed,
    Object? noTelp1 = freezed,
    Object? noTelp2 = freezed,
  }) {
    return _then(_value.copyWith(
      idUser: freezed == idUser
          ? _value.idUser
          : idUser // ignore: cast_nullable_to_non_nullable
              as int?,
      idDept: freezed == idDept
          ? _value.idDept
          : idDept // ignore: cast_nullable_to_non_nullable
              as int?,
      nama: freezed == nama
          ? _value.nama
          : nama // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      noTelp1: freezed == noTelp1
          ? _value.noTelp1
          : noTelp1 // ignore: cast_nullable_to_non_nullable
              as String?,
      noTelp2: freezed == noTelp2
          ? _value.noTelp2
          : noTelp2 // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserListCopyWith<$Res> implements $UserListCopyWith<$Res> {
  factory _$$_UserListCopyWith(
          _$_UserList value, $Res Function(_$_UserList) then) =
      __$$_UserListCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id_user') int? idUser,
      @JsonKey(name: 'id_dept') int? idDept,
      String? nama,
      @JsonKey(name: 'fullname') String? fullName,
      @JsonKey(name: 'no_telp1') String? noTelp1,
      @JsonKey(name: 'no_telp2') String? noTelp2});
}

/// @nodoc
class __$$_UserListCopyWithImpl<$Res>
    extends _$UserListCopyWithImpl<$Res, _$_UserList>
    implements _$$_UserListCopyWith<$Res> {
  __$$_UserListCopyWithImpl(
      _$_UserList _value, $Res Function(_$_UserList) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idUser = freezed,
    Object? idDept = freezed,
    Object? nama = freezed,
    Object? fullName = freezed,
    Object? noTelp1 = freezed,
    Object? noTelp2 = freezed,
  }) {
    return _then(_$_UserList(
      idUser: freezed == idUser
          ? _value.idUser
          : idUser // ignore: cast_nullable_to_non_nullable
              as int?,
      idDept: freezed == idDept
          ? _value.idDept
          : idDept // ignore: cast_nullable_to_non_nullable
              as int?,
      nama: freezed == nama
          ? _value.nama
          : nama // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      noTelp1: freezed == noTelp1
          ? _value.noTelp1
          : noTelp1 // ignore: cast_nullable_to_non_nullable
              as String?,
      noTelp2: freezed == noTelp2
          ? _value.noTelp2
          : noTelp2 // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserList implements _UserList {
  _$_UserList(
      {@JsonKey(name: 'id_user') required this.idUser,
      @JsonKey(name: 'id_dept') required this.idDept,
      required this.nama,
      @JsonKey(name: 'fullname') required this.fullName,
      @JsonKey(name: 'no_telp1') this.noTelp1,
      @JsonKey(name: 'no_telp2') required this.noTelp2});

  factory _$_UserList.fromJson(Map<String, dynamic> json) =>
      _$$_UserListFromJson(json);

  @override
  @JsonKey(name: 'id_user')
  final int? idUser;
  @override
  @JsonKey(name: 'id_dept')
  final int? idDept;
  @override
  final String? nama;
  @override
  @JsonKey(name: 'fullname')
  final String? fullName;
  @override
  @JsonKey(name: 'no_telp1')
  final String? noTelp1;
  @override
  @JsonKey(name: 'no_telp2')
  final String? noTelp2;

  @override
  String toString() {
    return 'UserList(idUser: $idUser, idDept: $idDept, nama: $nama, fullName: $fullName, noTelp1: $noTelp1, noTelp2: $noTelp2)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserList &&
            (identical(other.idUser, idUser) || other.idUser == idUser) &&
            (identical(other.idDept, idDept) || other.idDept == idDept) &&
            (identical(other.nama, nama) || other.nama == nama) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.noTelp1, noTelp1) || other.noTelp1 == noTelp1) &&
            (identical(other.noTelp2, noTelp2) || other.noTelp2 == noTelp2));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, idUser, idDept, nama, fullName, noTelp1, noTelp2);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserListCopyWith<_$_UserList> get copyWith =>
      __$$_UserListCopyWithImpl<_$_UserList>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserListToJson(
      this,
    );
  }
}

abstract class _UserList implements UserList {
  factory _UserList(
      {@JsonKey(name: 'id_user') required final int? idUser,
      @JsonKey(name: 'id_dept') required final int? idDept,
      required final String? nama,
      @JsonKey(name: 'fullname') required final String? fullName,
      @JsonKey(name: 'no_telp1') final String? noTelp1,
      @JsonKey(name: 'no_telp2') required final String? noTelp2}) = _$_UserList;

  factory _UserList.fromJson(Map<String, dynamic> json) = _$_UserList.fromJson;

  @override
  @JsonKey(name: 'id_user')
  int? get idUser;
  @override
  @JsonKey(name: 'id_dept')
  int? get idDept;
  @override
  String? get nama;
  @override
  @JsonKey(name: 'fullname')
  String? get fullName;
  @override
  @JsonKey(name: 'no_telp1')
  String? get noTelp1;
  @override
  @JsonKey(name: 'no_telp2')
  String? get noTelp2;
  @override
  @JsonKey(ignore: true)
  _$$_UserListCopyWith<_$_UserList> get copyWith =>
      throw _privateConstructorUsedError;
}
