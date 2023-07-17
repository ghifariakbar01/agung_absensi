// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recent_absen_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

RecentAbsenState _$RecentAbsenStateFromJson(Map<String, dynamic> json) {
  return _RecentAbsenState.fromJson(json);
}

/// @nodoc
mixin _$RecentAbsenState {
  SavedLocation get savedLocation => throw _privateConstructorUsedError;
  DateTime get dateAbsen => throw _privateConstructorUsedError;
  JenisAbsen get jenisAbsen => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RecentAbsenStateCopyWith<RecentAbsenState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentAbsenStateCopyWith<$Res> {
  factory $RecentAbsenStateCopyWith(
          RecentAbsenState value, $Res Function(RecentAbsenState) then) =
      _$RecentAbsenStateCopyWithImpl<$Res, RecentAbsenState>;
  @useResult
  $Res call(
      {SavedLocation savedLocation, DateTime dateAbsen, JenisAbsen jenisAbsen});

  $SavedLocationCopyWith<$Res> get savedLocation;
}

/// @nodoc
class _$RecentAbsenStateCopyWithImpl<$Res, $Val extends RecentAbsenState>
    implements $RecentAbsenStateCopyWith<$Res> {
  _$RecentAbsenStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? savedLocation = null,
    Object? dateAbsen = null,
    Object? jenisAbsen = null,
  }) {
    return _then(_value.copyWith(
      savedLocation: null == savedLocation
          ? _value.savedLocation
          : savedLocation // ignore: cast_nullable_to_non_nullable
              as SavedLocation,
      dateAbsen: null == dateAbsen
          ? _value.dateAbsen
          : dateAbsen // ignore: cast_nullable_to_non_nullable
              as DateTime,
      jenisAbsen: null == jenisAbsen
          ? _value.jenisAbsen
          : jenisAbsen // ignore: cast_nullable_to_non_nullable
              as JenisAbsen,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SavedLocationCopyWith<$Res> get savedLocation {
    return $SavedLocationCopyWith<$Res>(_value.savedLocation, (value) {
      return _then(_value.copyWith(savedLocation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_RecentAbsenStateCopyWith<$Res>
    implements $RecentAbsenStateCopyWith<$Res> {
  factory _$$_RecentAbsenStateCopyWith(
          _$_RecentAbsenState value, $Res Function(_$_RecentAbsenState) then) =
      __$$_RecentAbsenStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SavedLocation savedLocation, DateTime dateAbsen, JenisAbsen jenisAbsen});

  @override
  $SavedLocationCopyWith<$Res> get savedLocation;
}

/// @nodoc
class __$$_RecentAbsenStateCopyWithImpl<$Res>
    extends _$RecentAbsenStateCopyWithImpl<$Res, _$_RecentAbsenState>
    implements _$$_RecentAbsenStateCopyWith<$Res> {
  __$$_RecentAbsenStateCopyWithImpl(
      _$_RecentAbsenState _value, $Res Function(_$_RecentAbsenState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? savedLocation = null,
    Object? dateAbsen = null,
    Object? jenisAbsen = null,
  }) {
    return _then(_$_RecentAbsenState(
      savedLocation: null == savedLocation
          ? _value.savedLocation
          : savedLocation // ignore: cast_nullable_to_non_nullable
              as SavedLocation,
      dateAbsen: null == dateAbsen
          ? _value.dateAbsen
          : dateAbsen // ignore: cast_nullable_to_non_nullable
              as DateTime,
      jenisAbsen: null == jenisAbsen
          ? _value.jenisAbsen
          : jenisAbsen // ignore: cast_nullable_to_non_nullable
              as JenisAbsen,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_RecentAbsenState implements _RecentAbsenState {
  const _$_RecentAbsenState(
      {required this.savedLocation,
      required this.dateAbsen,
      required this.jenisAbsen});

  factory _$_RecentAbsenState.fromJson(Map<String, dynamic> json) =>
      _$$_RecentAbsenStateFromJson(json);

  @override
  final SavedLocation savedLocation;
  @override
  final DateTime dateAbsen;
  @override
  final JenisAbsen jenisAbsen;

  @override
  String toString() {
    return 'RecentAbsenState(savedLocation: $savedLocation, dateAbsen: $dateAbsen, jenisAbsen: $jenisAbsen)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RecentAbsenState &&
            (identical(other.savedLocation, savedLocation) ||
                other.savedLocation == savedLocation) &&
            (identical(other.dateAbsen, dateAbsen) ||
                other.dateAbsen == dateAbsen) &&
            (identical(other.jenisAbsen, jenisAbsen) ||
                other.jenisAbsen == jenisAbsen));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, savedLocation, dateAbsen, jenisAbsen);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RecentAbsenStateCopyWith<_$_RecentAbsenState> get copyWith =>
      __$$_RecentAbsenStateCopyWithImpl<_$_RecentAbsenState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_RecentAbsenStateToJson(
      this,
    );
  }
}

abstract class _RecentAbsenState implements RecentAbsenState {
  const factory _RecentAbsenState(
      {required final SavedLocation savedLocation,
      required final DateTime dateAbsen,
      required final JenisAbsen jenisAbsen}) = _$_RecentAbsenState;

  factory _RecentAbsenState.fromJson(Map<String, dynamic> json) =
      _$_RecentAbsenState.fromJson;

  @override
  SavedLocation get savedLocation;
  @override
  DateTime get dateAbsen;
  @override
  JenisAbsen get jenisAbsen;
  @override
  @JsonKey(ignore: true)
  _$$_RecentAbsenStateCopyWith<_$_RecentAbsenState> get copyWith =>
      throw _privateConstructorUsedError;
}
