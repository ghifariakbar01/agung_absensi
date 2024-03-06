// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'izin_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$izinListRemoteServiceHash() =>
    r'd77238ed49fd87cf3c1997707566ad31a8798f8a';

/// See also [izinListRemoteService].
@ProviderFor(izinListRemoteService)
final izinListRemoteServiceProvider = Provider<IzinListRemoteService>.internal(
  izinListRemoteService,
  name: r'izinListRemoteServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$izinListRemoteServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IzinListRemoteServiceRef = ProviderRef<IzinListRemoteService>;
String _$izinListRepositoryHash() =>
    r'e487d85985cded6db727145d8e4f47efd5aa5366';

/// See also [izinListRepository].
@ProviderFor(izinListRepository)
final izinListRepositoryProvider = Provider<IzinListRepository>.internal(
  izinListRepository,
  name: r'izinListRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$izinListRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IzinListRepositoryRef = ProviderRef<IzinListRepository>;
String _$izinListControllerHash() =>
    r'f5463a8c1a2df99648114270430e627fba2decc4';

/// See also [IzinListController].
@ProviderFor(IzinListController)
final izinListControllerProvider = AutoDisposeAsyncNotifierProvider<
    IzinListController, List<IzinList>>.internal(
  IzinListController.new,
  name: r'izinListControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$izinListControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IzinListController = AutoDisposeAsyncNotifier<List<IzinList>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
