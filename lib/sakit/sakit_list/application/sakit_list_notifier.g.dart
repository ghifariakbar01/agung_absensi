// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sakit_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sakitListRemoteServiceHash() =>
    r'3bf135f0483001f38fd7365e457405006577533c';

/// See also [sakitListRemoteService].
@ProviderFor(sakitListRemoteService)
final sakitListRemoteServiceProvider =
    Provider<SakitListRemoteService>.internal(
  sakitListRemoteService,
  name: r'sakitListRemoteServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sakitListRemoteServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SakitListRemoteServiceRef = ProviderRef<SakitListRemoteService>;
String _$sakitListRepositoryHash() =>
    r'ec87e138dccf5d7302eac5d6861f33274a35e1c8';

/// See also [sakitListRepository].
@ProviderFor(sakitListRepository)
final sakitListRepositoryProvider = Provider<SakitListRepository>.internal(
  sakitListRepository,
  name: r'sakitListRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sakitListRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SakitListRepositoryRef = ProviderRef<SakitListRepository>;
String _$sakitListControllerHash() =>
    r'1fd5c2fae40e74b177a29c10810d1219ce5ed5cc';

/// See also [SakitListController].
@ProviderFor(SakitListController)
final sakitListControllerProvider = AutoDisposeAsyncNotifierProvider<
    SakitListController, List<SakitList>>.internal(
  SakitListController.new,
  name: r'sakitListControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sakitListControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SakitListController = AutoDisposeAsyncNotifier<List<SakitList>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
