// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'permission_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PermissionState {
  bool get isAuthorized => throw _privateConstructorUsedError;
  bool get cameraAuthorized => throw _privateConstructorUsedError;
  bool get locationAuthorized => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PermissionStateCopyWith<PermissionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PermissionStateCopyWith<$Res> {
  factory $PermissionStateCopyWith(
          PermissionState value, $Res Function(PermissionState) then) =
      _$PermissionStateCopyWithImpl<$Res, PermissionState>;
  @useResult
  $Res call(
      {bool isAuthorized, bool cameraAuthorized, bool locationAuthorized});
}

/// @nodoc
class _$PermissionStateCopyWithImpl<$Res, $Val extends PermissionState>
    implements $PermissionStateCopyWith<$Res> {
  _$PermissionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isAuthorized = null,
    Object? cameraAuthorized = null,
    Object? locationAuthorized = null,
  }) {
    return _then(_value.copyWith(
      isAuthorized: null == isAuthorized
          ? _value.isAuthorized
          : isAuthorized // ignore: cast_nullable_to_non_nullable
              as bool,
      cameraAuthorized: null == cameraAuthorized
          ? _value.cameraAuthorized
          : cameraAuthorized // ignore: cast_nullable_to_non_nullable
              as bool,
      locationAuthorized: null == locationAuthorized
          ? _value.locationAuthorized
          : locationAuthorized // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PermissionStateCopyWith<$Res>
    implements $PermissionStateCopyWith<$Res> {
  factory _$$_PermissionStateCopyWith(
          _$_PermissionState value, $Res Function(_$_PermissionState) then) =
      __$$_PermissionStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isAuthorized, bool cameraAuthorized, bool locationAuthorized});
}

/// @nodoc
class __$$_PermissionStateCopyWithImpl<$Res>
    extends _$PermissionStateCopyWithImpl<$Res, _$_PermissionState>
    implements _$$_PermissionStateCopyWith<$Res> {
  __$$_PermissionStateCopyWithImpl(
      _$_PermissionState _value, $Res Function(_$_PermissionState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isAuthorized = null,
    Object? cameraAuthorized = null,
    Object? locationAuthorized = null,
  }) {
    return _then(_$_PermissionState(
      isAuthorized: null == isAuthorized
          ? _value.isAuthorized
          : isAuthorized // ignore: cast_nullable_to_non_nullable
              as bool,
      cameraAuthorized: null == cameraAuthorized
          ? _value.cameraAuthorized
          : cameraAuthorized // ignore: cast_nullable_to_non_nullable
              as bool,
      locationAuthorized: null == locationAuthorized
          ? _value.locationAuthorized
          : locationAuthorized // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_PermissionState implements _PermissionState {
  const _$_PermissionState(
      {required this.isAuthorized,
      required this.cameraAuthorized,
      required this.locationAuthorized});

  @override
  final bool isAuthorized;
  @override
  final bool cameraAuthorized;
  @override
  final bool locationAuthorized;

  @override
  String toString() {
    return 'PermissionState(isAuthorized: $isAuthorized, cameraAuthorized: $cameraAuthorized, locationAuthorized: $locationAuthorized)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PermissionState &&
            (identical(other.isAuthorized, isAuthorized) ||
                other.isAuthorized == isAuthorized) &&
            (identical(other.cameraAuthorized, cameraAuthorized) ||
                other.cameraAuthorized == cameraAuthorized) &&
            (identical(other.locationAuthorized, locationAuthorized) ||
                other.locationAuthorized == locationAuthorized));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, isAuthorized, cameraAuthorized, locationAuthorized);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PermissionStateCopyWith<_$_PermissionState> get copyWith =>
      __$$_PermissionStateCopyWithImpl<_$_PermissionState>(this, _$identity);
}

abstract class _PermissionState implements PermissionState {
  const factory _PermissionState(
      {required final bool isAuthorized,
      required final bool cameraAuthorized,
      required final bool locationAuthorized}) = _$_PermissionState;

  @override
  bool get isAuthorized;
  @override
  bool get cameraAuthorized;
  @override
  bool get locationAuthorized;
  @override
  @JsonKey(ignore: true)
  _$$_PermissionStateCopyWith<_$_PermissionState> get copyWith =>
      throw _privateConstructorUsedError;
}
