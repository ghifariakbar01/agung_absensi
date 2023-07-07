// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'background_item_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$BackgroundItemState {
  SavedLocation get savedLocations => throw _privateConstructorUsedError;
  AbsenState get abenStates => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BackgroundItemStateCopyWith<BackgroundItemState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackgroundItemStateCopyWith<$Res> {
  factory $BackgroundItemStateCopyWith(
          BackgroundItemState value, $Res Function(BackgroundItemState) then) =
      _$BackgroundItemStateCopyWithImpl<$Res, BackgroundItemState>;
  @useResult
  $Res call({SavedLocation savedLocations, AbsenState abenStates});

  $SavedLocationCopyWith<$Res> get savedLocations;
  $AbsenStateCopyWith<$Res> get abenStates;
}

/// @nodoc
class _$BackgroundItemStateCopyWithImpl<$Res, $Val extends BackgroundItemState>
    implements $BackgroundItemStateCopyWith<$Res> {
  _$BackgroundItemStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? savedLocations = null,
    Object? abenStates = null,
  }) {
    return _then(_value.copyWith(
      savedLocations: null == savedLocations
          ? _value.savedLocations
          : savedLocations // ignore: cast_nullable_to_non_nullable
              as SavedLocation,
      abenStates: null == abenStates
          ? _value.abenStates
          : abenStates // ignore: cast_nullable_to_non_nullable
              as AbsenState,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SavedLocationCopyWith<$Res> get savedLocations {
    return $SavedLocationCopyWith<$Res>(_value.savedLocations, (value) {
      return _then(_value.copyWith(savedLocations: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AbsenStateCopyWith<$Res> get abenStates {
    return $AbsenStateCopyWith<$Res>(_value.abenStates, (value) {
      return _then(_value.copyWith(abenStates: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_BackgroundItemStateCopyWith<$Res>
    implements $BackgroundItemStateCopyWith<$Res> {
  factory _$$_BackgroundItemStateCopyWith(_$_BackgroundItemState value,
          $Res Function(_$_BackgroundItemState) then) =
      __$$_BackgroundItemStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SavedLocation savedLocations, AbsenState abenStates});

  @override
  $SavedLocationCopyWith<$Res> get savedLocations;
  @override
  $AbsenStateCopyWith<$Res> get abenStates;
}

/// @nodoc
class __$$_BackgroundItemStateCopyWithImpl<$Res>
    extends _$BackgroundItemStateCopyWithImpl<$Res, _$_BackgroundItemState>
    implements _$$_BackgroundItemStateCopyWith<$Res> {
  __$$_BackgroundItemStateCopyWithImpl(_$_BackgroundItemState _value,
      $Res Function(_$_BackgroundItemState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? savedLocations = null,
    Object? abenStates = null,
  }) {
    return _then(_$_BackgroundItemState(
      savedLocations: null == savedLocations
          ? _value.savedLocations
          : savedLocations // ignore: cast_nullable_to_non_nullable
              as SavedLocation,
      abenStates: null == abenStates
          ? _value.abenStates
          : abenStates // ignore: cast_nullable_to_non_nullable
              as AbsenState,
    ));
  }
}

/// @nodoc

class _$_BackgroundItemState implements _BackgroundItemState {
  const _$_BackgroundItemState(
      {required this.savedLocations, required this.abenStates});

  @override
  final SavedLocation savedLocations;
  @override
  final AbsenState abenStates;

  @override
  String toString() {
    return 'BackgroundItemState(savedLocations: $savedLocations, abenStates: $abenStates)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BackgroundItemState &&
            (identical(other.savedLocations, savedLocations) ||
                other.savedLocations == savedLocations) &&
            (identical(other.abenStates, abenStates) ||
                other.abenStates == abenStates));
  }

  @override
  int get hashCode => Object.hash(runtimeType, savedLocations, abenStates);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BackgroundItemStateCopyWith<_$_BackgroundItemState> get copyWith =>
      __$$_BackgroundItemStateCopyWithImpl<_$_BackgroundItemState>(
          this, _$identity);
}

abstract class _BackgroundItemState implements BackgroundItemState {
  const factory _BackgroundItemState(
      {required final SavedLocation savedLocations,
      required final AbsenState abenStates}) = _$_BackgroundItemState;

  @override
  SavedLocation get savedLocations;
  @override
  AbsenState get abenStates;
  @override
  @JsonKey(ignore: true)
  _$$_BackgroundItemStateCopyWith<_$_BackgroundItemState> get copyWith =>
      throw _privateConstructorUsedError;
}
