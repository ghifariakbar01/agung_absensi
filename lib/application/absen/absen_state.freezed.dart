// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'absen_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AbsenState _$AbsenStateFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'empty':
      return _Empty.fromJson(json);
    case 'absenIn':
      return _AbsenIn.fromJson(json);
    case 'incomplete':
      return _Incomplete.fromJson(json);
    case 'complete':
      return _Complete.fromJson(json);
    case 'failure':
      return _Failure.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'AbsenState',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$AbsenState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() absenIn,
    required TResult Function() incomplete,
    required TResult Function() complete,
    required TResult Function(int? errorCode, String? message) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? absenIn,
    TResult? Function()? incomplete,
    TResult? Function()? complete,
    TResult? Function(int? errorCode, String? message)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? absenIn,
    TResult Function()? incomplete,
    TResult Function()? complete,
    TResult Function(int? errorCode, String? message)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Empty value) empty,
    required TResult Function(_AbsenIn value) absenIn,
    required TResult Function(_Incomplete value) incomplete,
    required TResult Function(_Complete value) complete,
    required TResult Function(_Failure value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Empty value)? empty,
    TResult? Function(_AbsenIn value)? absenIn,
    TResult? Function(_Incomplete value)? incomplete,
    TResult? Function(_Complete value)? complete,
    TResult? Function(_Failure value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Empty value)? empty,
    TResult Function(_AbsenIn value)? absenIn,
    TResult Function(_Incomplete value)? incomplete,
    TResult Function(_Complete value)? complete,
    TResult Function(_Failure value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AbsenStateCopyWith<$Res> {
  factory $AbsenStateCopyWith(
          AbsenState value, $Res Function(AbsenState) then) =
      _$AbsenStateCopyWithImpl<$Res, AbsenState>;
}

/// @nodoc
class _$AbsenStateCopyWithImpl<$Res, $Val extends AbsenState>
    implements $AbsenStateCopyWith<$Res> {
  _$AbsenStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_EmptyCopyWith<$Res> {
  factory _$$_EmptyCopyWith(_$_Empty value, $Res Function(_$_Empty) then) =
      __$$_EmptyCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_EmptyCopyWithImpl<$Res>
    extends _$AbsenStateCopyWithImpl<$Res, _$_Empty>
    implements _$$_EmptyCopyWith<$Res> {
  __$$_EmptyCopyWithImpl(_$_Empty _value, $Res Function(_$_Empty) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$_Empty implements _Empty {
  const _$_Empty({final String? $type}) : $type = $type ?? 'empty';

  factory _$_Empty.fromJson(Map<String, dynamic> json) =>
      _$$_EmptyFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AbsenState.empty()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_Empty);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() absenIn,
    required TResult Function() incomplete,
    required TResult Function() complete,
    required TResult Function(int? errorCode, String? message) failure,
  }) {
    return empty();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? absenIn,
    TResult? Function()? incomplete,
    TResult? Function()? complete,
    TResult? Function(int? errorCode, String? message)? failure,
  }) {
    return empty?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? absenIn,
    TResult Function()? incomplete,
    TResult Function()? complete,
    TResult Function(int? errorCode, String? message)? failure,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Empty value) empty,
    required TResult Function(_AbsenIn value) absenIn,
    required TResult Function(_Incomplete value) incomplete,
    required TResult Function(_Complete value) complete,
    required TResult Function(_Failure value) failure,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Empty value)? empty,
    TResult? Function(_AbsenIn value)? absenIn,
    TResult? Function(_Incomplete value)? incomplete,
    TResult? Function(_Complete value)? complete,
    TResult? Function(_Failure value)? failure,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Empty value)? empty,
    TResult Function(_AbsenIn value)? absenIn,
    TResult Function(_Incomplete value)? incomplete,
    TResult Function(_Complete value)? complete,
    TResult Function(_Failure value)? failure,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$_EmptyToJson(
      this,
    );
  }
}

abstract class _Empty implements AbsenState {
  const factory _Empty() = _$_Empty;

  factory _Empty.fromJson(Map<String, dynamic> json) = _$_Empty.fromJson;
}

/// @nodoc
abstract class _$$_AbsenInCopyWith<$Res> {
  factory _$$_AbsenInCopyWith(
          _$_AbsenIn value, $Res Function(_$_AbsenIn) then) =
      __$$_AbsenInCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_AbsenInCopyWithImpl<$Res>
    extends _$AbsenStateCopyWithImpl<$Res, _$_AbsenIn>
    implements _$$_AbsenInCopyWith<$Res> {
  __$$_AbsenInCopyWithImpl(_$_AbsenIn _value, $Res Function(_$_AbsenIn) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$_AbsenIn implements _AbsenIn {
  const _$_AbsenIn({final String? $type}) : $type = $type ?? 'absenIn';

  factory _$_AbsenIn.fromJson(Map<String, dynamic> json) =>
      _$$_AbsenInFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AbsenState.absenIn()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_AbsenIn);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() absenIn,
    required TResult Function() incomplete,
    required TResult Function() complete,
    required TResult Function(int? errorCode, String? message) failure,
  }) {
    return absenIn();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? absenIn,
    TResult? Function()? incomplete,
    TResult? Function()? complete,
    TResult? Function(int? errorCode, String? message)? failure,
  }) {
    return absenIn?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? absenIn,
    TResult Function()? incomplete,
    TResult Function()? complete,
    TResult Function(int? errorCode, String? message)? failure,
    required TResult orElse(),
  }) {
    if (absenIn != null) {
      return absenIn();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Empty value) empty,
    required TResult Function(_AbsenIn value) absenIn,
    required TResult Function(_Incomplete value) incomplete,
    required TResult Function(_Complete value) complete,
    required TResult Function(_Failure value) failure,
  }) {
    return absenIn(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Empty value)? empty,
    TResult? Function(_AbsenIn value)? absenIn,
    TResult? Function(_Incomplete value)? incomplete,
    TResult? Function(_Complete value)? complete,
    TResult? Function(_Failure value)? failure,
  }) {
    return absenIn?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Empty value)? empty,
    TResult Function(_AbsenIn value)? absenIn,
    TResult Function(_Incomplete value)? incomplete,
    TResult Function(_Complete value)? complete,
    TResult Function(_Failure value)? failure,
    required TResult orElse(),
  }) {
    if (absenIn != null) {
      return absenIn(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$_AbsenInToJson(
      this,
    );
  }
}

abstract class _AbsenIn implements AbsenState {
  const factory _AbsenIn() = _$_AbsenIn;

  factory _AbsenIn.fromJson(Map<String, dynamic> json) = _$_AbsenIn.fromJson;
}

/// @nodoc
abstract class _$$_IncompleteCopyWith<$Res> {
  factory _$$_IncompleteCopyWith(
          _$_Incomplete value, $Res Function(_$_Incomplete) then) =
      __$$_IncompleteCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_IncompleteCopyWithImpl<$Res>
    extends _$AbsenStateCopyWithImpl<$Res, _$_Incomplete>
    implements _$$_IncompleteCopyWith<$Res> {
  __$$_IncompleteCopyWithImpl(
      _$_Incomplete _value, $Res Function(_$_Incomplete) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$_Incomplete implements _Incomplete {
  const _$_Incomplete({final String? $type}) : $type = $type ?? 'incomplete';

  factory _$_Incomplete.fromJson(Map<String, dynamic> json) =>
      _$$_IncompleteFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AbsenState.incomplete()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_Incomplete);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() absenIn,
    required TResult Function() incomplete,
    required TResult Function() complete,
    required TResult Function(int? errorCode, String? message) failure,
  }) {
    return incomplete();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? absenIn,
    TResult? Function()? incomplete,
    TResult? Function()? complete,
    TResult? Function(int? errorCode, String? message)? failure,
  }) {
    return incomplete?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? absenIn,
    TResult Function()? incomplete,
    TResult Function()? complete,
    TResult Function(int? errorCode, String? message)? failure,
    required TResult orElse(),
  }) {
    if (incomplete != null) {
      return incomplete();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Empty value) empty,
    required TResult Function(_AbsenIn value) absenIn,
    required TResult Function(_Incomplete value) incomplete,
    required TResult Function(_Complete value) complete,
    required TResult Function(_Failure value) failure,
  }) {
    return incomplete(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Empty value)? empty,
    TResult? Function(_AbsenIn value)? absenIn,
    TResult? Function(_Incomplete value)? incomplete,
    TResult? Function(_Complete value)? complete,
    TResult? Function(_Failure value)? failure,
  }) {
    return incomplete?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Empty value)? empty,
    TResult Function(_AbsenIn value)? absenIn,
    TResult Function(_Incomplete value)? incomplete,
    TResult Function(_Complete value)? complete,
    TResult Function(_Failure value)? failure,
    required TResult orElse(),
  }) {
    if (incomplete != null) {
      return incomplete(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$_IncompleteToJson(
      this,
    );
  }
}

abstract class _Incomplete implements AbsenState {
  const factory _Incomplete() = _$_Incomplete;

  factory _Incomplete.fromJson(Map<String, dynamic> json) =
      _$_Incomplete.fromJson;
}

/// @nodoc
abstract class _$$_CompleteCopyWith<$Res> {
  factory _$$_CompleteCopyWith(
          _$_Complete value, $Res Function(_$_Complete) then) =
      __$$_CompleteCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_CompleteCopyWithImpl<$Res>
    extends _$AbsenStateCopyWithImpl<$Res, _$_Complete>
    implements _$$_CompleteCopyWith<$Res> {
  __$$_CompleteCopyWithImpl(
      _$_Complete _value, $Res Function(_$_Complete) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$_Complete implements _Complete {
  const _$_Complete({final String? $type}) : $type = $type ?? 'complete';

  factory _$_Complete.fromJson(Map<String, dynamic> json) =>
      _$$_CompleteFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AbsenState.complete()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_Complete);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() absenIn,
    required TResult Function() incomplete,
    required TResult Function() complete,
    required TResult Function(int? errorCode, String? message) failure,
  }) {
    return complete();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? absenIn,
    TResult? Function()? incomplete,
    TResult? Function()? complete,
    TResult? Function(int? errorCode, String? message)? failure,
  }) {
    return complete?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? absenIn,
    TResult Function()? incomplete,
    TResult Function()? complete,
    TResult Function(int? errorCode, String? message)? failure,
    required TResult orElse(),
  }) {
    if (complete != null) {
      return complete();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Empty value) empty,
    required TResult Function(_AbsenIn value) absenIn,
    required TResult Function(_Incomplete value) incomplete,
    required TResult Function(_Complete value) complete,
    required TResult Function(_Failure value) failure,
  }) {
    return complete(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Empty value)? empty,
    TResult? Function(_AbsenIn value)? absenIn,
    TResult? Function(_Incomplete value)? incomplete,
    TResult? Function(_Complete value)? complete,
    TResult? Function(_Failure value)? failure,
  }) {
    return complete?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Empty value)? empty,
    TResult Function(_AbsenIn value)? absenIn,
    TResult Function(_Incomplete value)? incomplete,
    TResult Function(_Complete value)? complete,
    TResult Function(_Failure value)? failure,
    required TResult orElse(),
  }) {
    if (complete != null) {
      return complete(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$_CompleteToJson(
      this,
    );
  }
}

abstract class _Complete implements AbsenState {
  const factory _Complete() = _$_Complete;

  factory _Complete.fromJson(Map<String, dynamic> json) = _$_Complete.fromJson;
}

/// @nodoc
abstract class _$$_FailureCopyWith<$Res> {
  factory _$$_FailureCopyWith(
          _$_Failure value, $Res Function(_$_Failure) then) =
      __$$_FailureCopyWithImpl<$Res>;
  @useResult
  $Res call({int? errorCode, String? message});
}

/// @nodoc
class __$$_FailureCopyWithImpl<$Res>
    extends _$AbsenStateCopyWithImpl<$Res, _$_Failure>
    implements _$$_FailureCopyWith<$Res> {
  __$$_FailureCopyWithImpl(_$_Failure _value, $Res Function(_$_Failure) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errorCode = freezed,
    Object? message = freezed,
  }) {
    return _then(_$_Failure(
      errorCode: freezed == errorCode
          ? _value.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as int?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Failure implements _Failure {
  const _$_Failure({this.errorCode, this.message, final String? $type})
      : $type = $type ?? 'failure';

  factory _$_Failure.fromJson(Map<String, dynamic> json) =>
      _$$_FailureFromJson(json);

  @override
  final int? errorCode;
  @override
  final String? message;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AbsenState.failure(errorCode: $errorCode, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Failure &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, errorCode, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FailureCopyWith<_$_Failure> get copyWith =>
      __$$_FailureCopyWithImpl<_$_Failure>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() absenIn,
    required TResult Function() incomplete,
    required TResult Function() complete,
    required TResult Function(int? errorCode, String? message) failure,
  }) {
    return failure(errorCode, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? absenIn,
    TResult? Function()? incomplete,
    TResult? Function()? complete,
    TResult? Function(int? errorCode, String? message)? failure,
  }) {
    return failure?.call(errorCode, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? absenIn,
    TResult Function()? incomplete,
    TResult Function()? complete,
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
    required TResult Function(_Empty value) empty,
    required TResult Function(_AbsenIn value) absenIn,
    required TResult Function(_Incomplete value) incomplete,
    required TResult Function(_Complete value) complete,
    required TResult Function(_Failure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Empty value)? empty,
    TResult? Function(_AbsenIn value)? absenIn,
    TResult? Function(_Incomplete value)? incomplete,
    TResult? Function(_Complete value)? complete,
    TResult? Function(_Failure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Empty value)? empty,
    TResult Function(_AbsenIn value)? absenIn,
    TResult Function(_Incomplete value)? incomplete,
    TResult Function(_Complete value)? complete,
    TResult Function(_Failure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$_FailureToJson(
      this,
    );
  }
}

abstract class _Failure implements AbsenState {
  const factory _Failure({final int? errorCode, final String? message}) =
      _$_Failure;

  factory _Failure.fromJson(Map<String, dynamic> json) = _$_Failure.fromJson;

  int? get errorCode;
  String? get message;
  @JsonKey(ignore: true)
  _$$_FailureCopyWith<_$_Failure> get copyWith =>
      throw _privateConstructorUsedError;
}
