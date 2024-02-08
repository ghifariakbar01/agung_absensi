// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'absen_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AbsenRequest {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int absenIdMnl) absenIn,
    required TResult Function(int absenIdMnl) absenOut,
    required TResult Function() absenUnknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int absenIdMnl)? absenIn,
    TResult? Function(int absenIdMnl)? absenOut,
    TResult? Function()? absenUnknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int absenIdMnl)? absenIn,
    TResult Function(int absenIdMnl)? absenOut,
    TResult Function()? absenUnknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_AbsenIn value) absenIn,
    required TResult Function(_AbsenOut value) absenOut,
    required TResult Function(_AbsenUnknown value) absenUnknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_AbsenIn value)? absenIn,
    TResult? Function(_AbsenOut value)? absenOut,
    TResult? Function(_AbsenUnknown value)? absenUnknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AbsenIn value)? absenIn,
    TResult Function(_AbsenOut value)? absenOut,
    TResult Function(_AbsenUnknown value)? absenUnknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AbsenRequestCopyWith<$Res> {
  factory $AbsenRequestCopyWith(
          AbsenRequest value, $Res Function(AbsenRequest) then) =
      _$AbsenRequestCopyWithImpl<$Res, AbsenRequest>;
}

/// @nodoc
class _$AbsenRequestCopyWithImpl<$Res, $Val extends AbsenRequest>
    implements $AbsenRequestCopyWith<$Res> {
  _$AbsenRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_AbsenInCopyWith<$Res> {
  factory _$$_AbsenInCopyWith(
          _$_AbsenIn value, $Res Function(_$_AbsenIn) then) =
      __$$_AbsenInCopyWithImpl<$Res>;
  @useResult
  $Res call({int absenIdMnl});
}

/// @nodoc
class __$$_AbsenInCopyWithImpl<$Res>
    extends _$AbsenRequestCopyWithImpl<$Res, _$_AbsenIn>
    implements _$$_AbsenInCopyWith<$Res> {
  __$$_AbsenInCopyWithImpl(_$_AbsenIn _value, $Res Function(_$_AbsenIn) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? absenIdMnl = null,
  }) {
    return _then(_$_AbsenIn(
      absenIdMnl: null == absenIdMnl
          ? _value.absenIdMnl
          : absenIdMnl // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_AbsenIn implements _AbsenIn {
  const _$_AbsenIn({required this.absenIdMnl});

  @override
  final int absenIdMnl;

  @override
  String toString() {
    return 'AbsenRequest.absenIn(absenIdMnl: $absenIdMnl)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AbsenIn &&
            (identical(other.absenIdMnl, absenIdMnl) ||
                other.absenIdMnl == absenIdMnl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, absenIdMnl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AbsenInCopyWith<_$_AbsenIn> get copyWith =>
      __$$_AbsenInCopyWithImpl<_$_AbsenIn>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int absenIdMnl) absenIn,
    required TResult Function(int absenIdMnl) absenOut,
    required TResult Function() absenUnknown,
  }) {
    return absenIn(absenIdMnl);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int absenIdMnl)? absenIn,
    TResult? Function(int absenIdMnl)? absenOut,
    TResult? Function()? absenUnknown,
  }) {
    return absenIn?.call(absenIdMnl);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int absenIdMnl)? absenIn,
    TResult Function(int absenIdMnl)? absenOut,
    TResult Function()? absenUnknown,
    required TResult orElse(),
  }) {
    if (absenIn != null) {
      return absenIn(absenIdMnl);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_AbsenIn value) absenIn,
    required TResult Function(_AbsenOut value) absenOut,
    required TResult Function(_AbsenUnknown value) absenUnknown,
  }) {
    return absenIn(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_AbsenIn value)? absenIn,
    TResult? Function(_AbsenOut value)? absenOut,
    TResult? Function(_AbsenUnknown value)? absenUnknown,
  }) {
    return absenIn?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AbsenIn value)? absenIn,
    TResult Function(_AbsenOut value)? absenOut,
    TResult Function(_AbsenUnknown value)? absenUnknown,
    required TResult orElse(),
  }) {
    if (absenIn != null) {
      return absenIn(this);
    }
    return orElse();
  }
}

abstract class _AbsenIn implements AbsenRequest {
  const factory _AbsenIn({required final int absenIdMnl}) = _$_AbsenIn;

  int get absenIdMnl;
  @JsonKey(ignore: true)
  _$$_AbsenInCopyWith<_$_AbsenIn> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_AbsenOutCopyWith<$Res> {
  factory _$$_AbsenOutCopyWith(
          _$_AbsenOut value, $Res Function(_$_AbsenOut) then) =
      __$$_AbsenOutCopyWithImpl<$Res>;
  @useResult
  $Res call({int absenIdMnl});
}

/// @nodoc
class __$$_AbsenOutCopyWithImpl<$Res>
    extends _$AbsenRequestCopyWithImpl<$Res, _$_AbsenOut>
    implements _$$_AbsenOutCopyWith<$Res> {
  __$$_AbsenOutCopyWithImpl(
      _$_AbsenOut _value, $Res Function(_$_AbsenOut) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? absenIdMnl = null,
  }) {
    return _then(_$_AbsenOut(
      absenIdMnl: null == absenIdMnl
          ? _value.absenIdMnl
          : absenIdMnl // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_AbsenOut implements _AbsenOut {
  const _$_AbsenOut({required this.absenIdMnl});

  @override
  final int absenIdMnl;

  @override
  String toString() {
    return 'AbsenRequest.absenOut(absenIdMnl: $absenIdMnl)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AbsenOut &&
            (identical(other.absenIdMnl, absenIdMnl) ||
                other.absenIdMnl == absenIdMnl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, absenIdMnl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AbsenOutCopyWith<_$_AbsenOut> get copyWith =>
      __$$_AbsenOutCopyWithImpl<_$_AbsenOut>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int absenIdMnl) absenIn,
    required TResult Function(int absenIdMnl) absenOut,
    required TResult Function() absenUnknown,
  }) {
    return absenOut(absenIdMnl);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int absenIdMnl)? absenIn,
    TResult? Function(int absenIdMnl)? absenOut,
    TResult? Function()? absenUnknown,
  }) {
    return absenOut?.call(absenIdMnl);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int absenIdMnl)? absenIn,
    TResult Function(int absenIdMnl)? absenOut,
    TResult Function()? absenUnknown,
    required TResult orElse(),
  }) {
    if (absenOut != null) {
      return absenOut(absenIdMnl);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_AbsenIn value) absenIn,
    required TResult Function(_AbsenOut value) absenOut,
    required TResult Function(_AbsenUnknown value) absenUnknown,
  }) {
    return absenOut(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_AbsenIn value)? absenIn,
    TResult? Function(_AbsenOut value)? absenOut,
    TResult? Function(_AbsenUnknown value)? absenUnknown,
  }) {
    return absenOut?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AbsenIn value)? absenIn,
    TResult Function(_AbsenOut value)? absenOut,
    TResult Function(_AbsenUnknown value)? absenUnknown,
    required TResult orElse(),
  }) {
    if (absenOut != null) {
      return absenOut(this);
    }
    return orElse();
  }
}

abstract class _AbsenOut implements AbsenRequest {
  const factory _AbsenOut({required final int absenIdMnl}) = _$_AbsenOut;

  int get absenIdMnl;
  @JsonKey(ignore: true)
  _$$_AbsenOutCopyWith<_$_AbsenOut> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_AbsenUnknownCopyWith<$Res> {
  factory _$$_AbsenUnknownCopyWith(
          _$_AbsenUnknown value, $Res Function(_$_AbsenUnknown) then) =
      __$$_AbsenUnknownCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_AbsenUnknownCopyWithImpl<$Res>
    extends _$AbsenRequestCopyWithImpl<$Res, _$_AbsenUnknown>
    implements _$$_AbsenUnknownCopyWith<$Res> {
  __$$_AbsenUnknownCopyWithImpl(
      _$_AbsenUnknown _value, $Res Function(_$_AbsenUnknown) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_AbsenUnknown implements _AbsenUnknown {
  const _$_AbsenUnknown();

  @override
  String toString() {
    return 'AbsenRequest.absenUnknown()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_AbsenUnknown);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int absenIdMnl) absenIn,
    required TResult Function(int absenIdMnl) absenOut,
    required TResult Function() absenUnknown,
  }) {
    return absenUnknown();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int absenIdMnl)? absenIn,
    TResult? Function(int absenIdMnl)? absenOut,
    TResult? Function()? absenUnknown,
  }) {
    return absenUnknown?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int absenIdMnl)? absenIn,
    TResult Function(int absenIdMnl)? absenOut,
    TResult Function()? absenUnknown,
    required TResult orElse(),
  }) {
    if (absenUnknown != null) {
      return absenUnknown();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_AbsenIn value) absenIn,
    required TResult Function(_AbsenOut value) absenOut,
    required TResult Function(_AbsenUnknown value) absenUnknown,
  }) {
    return absenUnknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_AbsenIn value)? absenIn,
    TResult? Function(_AbsenOut value)? absenOut,
    TResult? Function(_AbsenUnknown value)? absenUnknown,
  }) {
    return absenUnknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AbsenIn value)? absenIn,
    TResult Function(_AbsenOut value)? absenOut,
    TResult Function(_AbsenUnknown value)? absenUnknown,
    required TResult orElse(),
  }) {
    if (absenUnknown != null) {
      return absenUnknown(this);
    }
    return orElse();
  }
}

abstract class _AbsenUnknown implements AbsenRequest {
  const factory _AbsenUnknown() = _$_AbsenUnknown;
}
