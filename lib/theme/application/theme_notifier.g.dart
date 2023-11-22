// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$themeRepositoryHash() => r'2e40ca07b371717a75f42c6668833861da2eb707';

/// See also [themeRepository].
@ProviderFor(themeRepository)
final themeRepositoryProvider = Provider<ThemeRepository>.internal(
  themeRepository,
  name: r'themeRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$themeRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ThemeRepositoryRef = ProviderRef<ThemeRepository>;
String _$themeNotifierHash() => r'520a601245037c5711da9c4608b10fc64b698bf7';

/// See also [ThemeNotifier].
@ProviderFor(ThemeNotifier)
final themeNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ThemeNotifier, String>.internal(
  ThemeNotifier.new,
  name: r'themeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$themeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ThemeNotifier = AutoDisposeAsyncNotifier<String>;
String _$themeControllerHash() => r'68f1350c80c500b7cec4bbf48b0ac07dad21a3e2';

/// See also [ThemeController].
@ProviderFor(ThemeController)
final themeControllerProvider =
    AutoDisposeAsyncNotifierProvider<ThemeController, void>.internal(
  ThemeController.new,
  name: r'themeControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$themeControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ThemeController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
