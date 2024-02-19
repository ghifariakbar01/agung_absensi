// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wa_register_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$waRegisterRepositoryHash() =>
    r'c888cbd3821004fc9d55fcfefa64a98606bb9999';

/// See also [waRegisterRepository].
@ProviderFor(waRegisterRepository)
final waRegisterRepositoryProvider = Provider<WaRegisterRepository>.internal(
  waRegisterRepository,
  name: r'waRegisterRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$waRegisterRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WaRegisterRepositoryRef = ProviderRef<WaRegisterRepository>;
String _$currentlySavedPhoneNumberNotifierHash() =>
    r'300095a761d34f9ab854ded59ae752d8eeee1332';

/// See also [CurrentlySavedPhoneNumberNotifier].
@ProviderFor(CurrentlySavedPhoneNumberNotifier)
final currentlySavedPhoneNumberNotifierProvider =
    AutoDisposeAsyncNotifierProvider<CurrentlySavedPhoneNumberNotifier,
        PhoneNum>.internal(
  CurrentlySavedPhoneNumberNotifier.new,
  name: r'currentlySavedPhoneNumberNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentlySavedPhoneNumberNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentlySavedPhoneNumberNotifier
    = AutoDisposeAsyncNotifier<PhoneNum>;
String _$waRegisterNotifierHash() =>
    r'd4d6cf6a29d0430dcf29d51041ffd2cafe37a26e';

/// See also [WaRegisterNotifier].
@ProviderFor(WaRegisterNotifier)
final waRegisterNotifierProvider =
    AutoDisposeAsyncNotifierProvider<WaRegisterNotifier, WaRegister>.internal(
  WaRegisterNotifier.new,
  name: r'waRegisterNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$waRegisterNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WaRegisterNotifier = AutoDisposeAsyncNotifier<WaRegister>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
