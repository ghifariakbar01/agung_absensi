// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'err_log_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$errLogRemoteServiceHash() =>
    r'c6723d2e6a7a726661a7fea6042081da506c23da';

/// See also [errLogRemoteService].
@ProviderFor(errLogRemoteService)
final errLogRemoteServiceProvider = Provider<ErrLogRemoteService>.internal(
  errLogRemoteService,
  name: r'errLogRemoteServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$errLogRemoteServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ErrLogRemoteServiceRef = ProviderRef<ErrLogRemoteService>;
String _$errLogRepositoryHash() => r'6ad58e69869a6a38b015aa830728993bc057f1bf';

/// See also [errLogRepository].
@ProviderFor(errLogRepository)
final errLogRepositoryProvider = Provider<ErrLogRepository>.internal(
  errLogRepository,
  name: r'errLogRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$errLogRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ErrLogRepositoryRef = ProviderRef<ErrLogRepository>;
String _$errLogControllerHash() => r'cda56f4e2a3603097f9377606c27154bb16ef1a0';

/// See also [ErrLogController].
@ProviderFor(ErrLogController)
final errLogControllerProvider =
    AutoDisposeAsyncNotifierProvider<ErrLogController, void>.internal(
  ErrLogController.new,
  name: r'errLogControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$errLogControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ErrLogController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
