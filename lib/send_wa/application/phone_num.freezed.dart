// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'phone_num.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PhoneNum _$PhoneNumFromJson(Map<String, dynamic> json) {
  return _PhoneNum.fromJson(json);
}

/// @nodoc
mixin _$PhoneNum {
  @JsonKey(name: 'no_telp1')
  String? get noTelp1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'no_telp2')
  String? get noTelp2 => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PhoneNumCopyWith<PhoneNum> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhoneNumCopyWith<$Res> {
  factory $PhoneNumCopyWith(PhoneNum value, $Res Function(PhoneNum) then) =
      _$PhoneNumCopyWithImpl<$Res, PhoneNum>;
  @useResult
  $Res call(
      {@JsonKey(name: 'no_telp1') String? noTelp1,
      @JsonKey(name: 'no_telp2') String? noTelp2});
}

/// @nodoc
class _$PhoneNumCopyWithImpl<$Res, $Val extends PhoneNum>
    implements $PhoneNumCopyWith<$Res> {
  _$PhoneNumCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? noTelp1 = freezed,
    Object? noTelp2 = freezed,
  }) {
    return _then(_value.copyWith(
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
abstract class _$$_PhoneNumCopyWith<$Res> implements $PhoneNumCopyWith<$Res> {
  factory _$$_PhoneNumCopyWith(
          _$_PhoneNum value, $Res Function(_$_PhoneNum) then) =
      __$$_PhoneNumCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'no_telp1') String? noTelp1,
      @JsonKey(name: 'no_telp2') String? noTelp2});
}

/// @nodoc
class __$$_PhoneNumCopyWithImpl<$Res>
    extends _$PhoneNumCopyWithImpl<$Res, _$_PhoneNum>
    implements _$$_PhoneNumCopyWith<$Res> {
  __$$_PhoneNumCopyWithImpl(
      _$_PhoneNum _value, $Res Function(_$_PhoneNum) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? noTelp1 = freezed,
    Object? noTelp2 = freezed,
  }) {
    return _then(_$_PhoneNum(
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
class _$_PhoneNum implements _PhoneNum {
  const _$_PhoneNum(
      {@JsonKey(name: 'no_telp1') this.noTelp1,
      @JsonKey(name: 'no_telp2') this.noTelp2});

  factory _$_PhoneNum.fromJson(Map<String, dynamic> json) =>
      _$$_PhoneNumFromJson(json);

  @override
  @JsonKey(name: 'no_telp1')
  final String? noTelp1;
  @override
  @JsonKey(name: 'no_telp2')
  final String? noTelp2;

  @override
  String toString() {
    return 'PhoneNum(noTelp1: $noTelp1, noTelp2: $noTelp2)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PhoneNum &&
            (identical(other.noTelp1, noTelp1) || other.noTelp1 == noTelp1) &&
            (identical(other.noTelp2, noTelp2) || other.noTelp2 == noTelp2));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, noTelp1, noTelp2);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PhoneNumCopyWith<_$_PhoneNum> get copyWith =>
      __$$_PhoneNumCopyWithImpl<_$_PhoneNum>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PhoneNumToJson(
      this,
    );
  }
}

abstract class _PhoneNum implements PhoneNum {
  const factory _PhoneNum(
      {@JsonKey(name: 'no_telp1') final String? noTelp1,
      @JsonKey(name: 'no_telp2') final String? noTelp2}) = _$_PhoneNum;

  factory _PhoneNum.fromJson(Map<String, dynamic> json) = _$_PhoneNum.fromJson;

  @override
  @JsonKey(name: 'no_telp1')
  String? get noTelp1;
  @override
  @JsonKey(name: 'no_telp2')
  String? get noTelp2;
  @override
  @JsonKey(ignore: true)
  _$$_PhoneNumCopyWith<_$_PhoneNum> get copyWith =>
      throw _privateConstructorUsedError;
}
