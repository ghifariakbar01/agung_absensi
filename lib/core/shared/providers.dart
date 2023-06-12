import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/timer/timer_notifier.dart';
import '../../application/timer/timer_state.dart';
import '../application/routes/auth/auth_notifier.dart';
import '../application/routes/route_names.dart';
import '../application/routes/route_notifier.dart';
import '../application/routes/sign_in_form/sign_in_form_notifier.dart';
import '../infrastructure/hive_database.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../infrastructure/auth_interceptor.dart';
import '../infrastructure/auth_remote_service.dart';
import '../infrastructure/auth_repository.dart';
import '../infrastructure/credentials_storage/credentials_storage.dart';
import '../infrastructure/credentials_storage/secure_credentials_storage.dart';

final dioProvider = Provider((ref) => Dio());

final hiveProvider = Provider(
  (ref) => HiveDatabase(),
);

final routerProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);
  return GoRouter(
    initialLocation: RouteNames.welcomeRoute,
    refreshListenable: router,
    // redirect: router.redirectLogic,
    routes: router.routes,
  );
});

final timerProvider = StateNotifierProvider<TimerNotifier, TimerModel>(
  (ref) => TimerNotifier(),
);

final flutterSecureStorageProvider = Provider(
  (ref) => const FlutterSecureStorage(),
);

final credentialsStorageProvider = Provider<CredentialsStorage>(
  (ref) => SecureCredentialsStorage(ref.watch(flutterSecureStorageProvider)),
);

final authRemoteServiceProvider = Provider(
  (ref) => AuthRemoteService(ref.watch(dioProvider)),
);

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    ref.watch(credentialsStorageProvider),
    ref.watch(authRemoteServiceProvider),
  ),
);

final authInterceptorProvider = Provider(
  (ref) => AuthInterceptor(ref.watch(authRepositoryProvider)),
);

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.watch(authRepositoryProvider)),
);

final signInFormNotifierProvider =
    StateNotifierProvider.autoDispose<SignInFormNotifier, SignInFormState>(
  (ref) => SignInFormNotifier(ref.watch(authRepositoryProvider)),
);
