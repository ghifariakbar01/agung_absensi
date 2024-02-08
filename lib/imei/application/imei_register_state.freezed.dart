// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'imei_register_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ImeiRegisterResponse {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String imei) withImei,
    required TResult Function(int? errorCode, String? message) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String imei)? withImei,
    TResult? Function(int? errorCode, String? message)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String imei)? withImei,
    TResult Function(int? errorCode, String? message)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WithImei value) withImei,
    required TResult Function(_ImeiFailure value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_WithImei value)? withImei,
    TResult? Function(_ImeiFailure value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WithImei value)? withImei,
    TResult Function(_ImeiFailure value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImeiRegisterResponseCopyWith<$Res> {
  factory $ImeiRegisterResponseCopyWith(ImeiRegisterResponse value,
          $Res Function(ImeiRegisterResponse) then) =
      _$ImeiRegisterResponseCopyWithImpl<$Res, ImeiRegisterResponse>;
}

/// @nodoc
class _$ImeiRegisterResponseCopyWithImpl<$Res,
        $Val extends ImeiRegisterResponse>
    implements $ImeiRegisterResponseCopyWith<$Res> {
  _$ImeiRegisterResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_WithImeiCopyWith<$Res> {
  factory _$$_WithImeiCopyWith(
          _$_WithImei value, $Res Function(_$_WithImei) then) =
      __$$_WithImeiCopyWithImpl<$Res>;
  @useResult
  $Res call({String imei});
}

/// @nodoc
class __$$_WithImeiCopyWithImpl<$Res>
    extends _$ImeiRegisterResponseCopyWithImpl<$Res, _$_WithImei>
    implements _$$_WithImeiCopyWith<$Res> {
  __$$_WithImeiCopyWithImpl(
      _$_WithImei _value, $Res Function(_$_WithImei) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imei = null,
  }) {
    return _then(_$_WithImei(
      imei: null == imei
          ? _value.imei
          : imei // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_WithImei extends _WithImei {
  const _$_WithImei({required this.imei}) : super._();

  @override
  final String imei;

  @override
  String toString() {
    return 'ImeiRegisterResponse.withImei(imei: $imei)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_WithImei &&
            (identical(other.imei, imei) || other.imei == imei));
  }

  @override
  int get hashCode => Object.hash(runtimeType, imei);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_WithImeiCopyWith<_$_WithImei> get copyWith =>
      __$$_WithImeiCopyWithImpl<_$_WithImei>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String imei) withImei,
    required TResult Function(int? errorCode, String? message) failure,
  }) {
    return withImei(imei);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String imei)? withImei,
    TResult? Function(int? errorCode, String? message)? failure,
  }) {
    return withImei?.call(imei);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String imei)? withImei,
    TResult Function(int? errorCode, String? message)? failure,
    required TResult orElse(),
  }) {
    if (withImei != null) {
      return withImei(imei);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WithImei value) withImei,
    required TResult Function(_ImeiFailure value) failure,
  }) {
    return withImei(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_WithImei value)? withImei,
    TResult? Function(_ImeiFailure value)? failure,
  }) {
    return withImei?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WithImei value)? withImei,
    TResult Function(_ImeiFailure value)? failure,
    required TResult orElse(),
  }) {
    if (withImei != null) {
      return withImei(this);
    }
    return orElse();
  }
}

abstract class _WithImei extends ImeiRegisterResponse {
  const factory _WithImei({required final String imei}) = _$_WithImei;
  const _WithImei._() : super._();

  String get imei;
  @JsonKey(ignore: true)
  _$$_WithImeiCopyWith<_$_WithImei> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_ImeiFailureCopyWith<$Res> {
  factory _$$_ImeiFailureCopyWith(
          _$_ImeiFailure value, $Res Function(_$_ImeiFailure) then) =
      __$$_ImeiFailureCopyWithImpl<$Res>;
  @useResult
  $Res call({int? errorCode, String? message});
}

/// @nodoc
class __$$_ImeiFailureCopyWithImpl<$Res>
    extends _$ImeiRegisterResponseCopyWithImpl<$Res, _$_ImeiFailure>
    implements _$$_ImeiFailureCopyWith<$Res> {
  __$$_ImeiFailureCopyWithImpl(
      _$_ImeiFailure _value, $Res Function(_$_ImeiFailure) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errorCode = freezed,
    Object? message = freezed,
  }) {
    return _then(_$_ImeiFailure(
      freezed == errorCode
          ? _value.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_ImeiFailure extends _ImeiFailure {
  const _$_ImeiFailure([this.errorCode, this.message]) : super._();

  @override
  final int? errorCode;
  @override
  final String? message;

  @override
  String toString() {
    return 'ImeiRegisterResponse.failure(errorCode: $errorCode, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ImeiFailure &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errorCode, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ImeiFailureCopyWith<_$_ImeiFailure> get copyWith =>
      __$$_ImeiFailureCopyWithImpl<_$_ImeiFailure>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String imei) withImei,
    required TResult Function(int? errorCode, String? message) failure,
  }) {
    return failure(errorCode, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String imei)? withImei,
    TResult? Function(int? errorCode, String? message)? failure,
  }) {
    return failure?.call(errorCode, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String imei)? withImei,
    TResult Function(int? errorCode, String? message)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(errorCode, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WithImei value) withImei,
    required TResult Function(_ImeiFailure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_WithImei value)? withImei,
    TResult? Function(_ImeiFailure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WithImei value)? withImei,
    TResult Function(_ImeiFailure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class _ImeiFailure extends ImeiRegisterResponse {
  const factory _ImeiFailure([final int? errorCode, final String? message]) =
      _$_ImeiFailure;
  const _ImeiFailure._() : super._();

  int? get errorCode;
  String? get message;
  @JsonKey(ignore: true)
  _$$_ImeiFailureCopyWith<_$_ImeiFailure> get copyWith =>
      throw _privateConstructorUsedError;
}
