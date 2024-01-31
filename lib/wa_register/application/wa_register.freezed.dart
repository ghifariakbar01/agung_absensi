// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wa_register.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

WaRegister _$WaRegisterFromJson(Map<String, dynamic> json) {
  return _WaRegister.fromJson(json);
}

/// @nodoc
mixin _$WaRegister {
  String? get phone => throw _privateConstructorUsedError;
  bool? get isRegistered => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WaRegisterCopyWith<WaRegister> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WaRegisterCopyWith<$Res> {
  factory $WaRegisterCopyWith(
          WaRegister value, $Res Function(WaRegister) then) =
      _$WaRegisterCopyWithImpl<$Res, WaRegister>;
  @useResult
  $Res call({String? phone, bool? isRegistered});
}

/// @nodoc
class _$WaRegisterCopyWithImpl<$Res, $Val extends WaRegister>
    implements $WaRegisterCopyWith<$Res> {
  _$WaRegisterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = freezed,
    Object? isRegistered = freezed,
  }) {
    return _then(_value.copyWith(
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      isRegistered: freezed == isRegistered
          ? _value.isRegistered
          : isRegistered // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_WaRegisterCopyWith<$Res>
    implements $WaRegisterCopyWith<$Res> {
  factory _$$_WaRegisterCopyWith(
          _$_WaRegister value, $Res Function(_$_WaRegister) then) =
      __$$_WaRegisterCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? phone, bool? isRegistered});
}

/// @nodoc
class __$$_WaRegisterCopyWithImpl<$Res>
    extends _$WaRegisterCopyWithImpl<$Res, _$_WaRegister>
    implements _$$_WaRegisterCopyWith<$Res> {
  __$$_WaRegisterCopyWithImpl(
      _$_WaRegister _value, $Res Function(_$_WaRegister) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = freezed,
    Object? isRegistered = freezed,
  }) {
    return _then(_$_WaRegister(
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      isRegistered: freezed == isRegistered
          ? _value.isRegistered
          : isRegistered // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_WaRegister implements _WaRegister {
  _$_WaRegister({this.phone, this.isRegistered});

  factory _$_WaRegister.fromJson(Map<String, dynamic> json) =>
      _$$_WaRegisterFromJson(json);

  @override
  final String? phone;
  @override
  final bool? isRegistered;

  @override
  String toString() {
    return 'WaRegister(phone: $phone, isRegistered: $isRegistered)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_WaRegister &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.isRegistered, isRegistered) ||
                other.isRegistered == isRegistered));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, phone, isRegistered);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_WaRegisterCopyWith<_$_WaRegister> get copyWith =>
      __$$_WaRegisterCopyWithImpl<_$_WaRegister>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_WaRegisterToJson(
      this,
    );
  }
}

abstract class _WaRegister implements WaRegister {
  factory _WaRegister({final String? phone, final bool? isRegistered}) =
      _$_WaRegister;

  factory _WaRegister.fromJson(Map<String, dynamic> json) =
      _$_WaRegister.fromJson;

  @override
  String? get phone;
  @override
  bool? get isRegistered;
  @override
  @JsonKey(ignore: true)
  _$$_WaRegisterCopyWith<_$_WaRegister> get copyWith =>
      throw _privateConstructorUsedError;
}
