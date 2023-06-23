import 'package:dio/dio.dart';
import 'package:face_net_authentication/application/absen/absen_auth_notifier.dart';
import 'package:face_net_authentication/application/absen/absen_state.dart';

import 'package:face_net_authentication/infrastructure/absen/absen_remote_service.dart';
import 'package:face_net_authentication/infrastructure/absen/absen_repository.dart';
import 'package:face_net_authentication/infrastructure/geofence/geofence_remote_service.dart';
import 'package:face_net_authentication/infrastructure/geofence/geofence_repository.dart';

import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../application/absen/absen_auth_state.dart';
import '../application/absen/absen_notifier.dart';
import '../application/auth/auth_notifier.dart';
import '../application/geofence/geofence_notifier.dart';
import '../application/geofence/geofence_state.dart';
import '../application/permission/permission_notifier.dart';
import '../application/permission/permission_state.dart';
import '../application/routes/route_names.dart';
import '../application/routes/route_notifier.dart';
import '../application/sign_in_form/sign_in_form_notifier.dart';
import '../application/timer/timer_notifier.dart';
import '../application/timer/timer_state.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../application/user/user_notifier.dart';
import '../application/user/user_state.dart';
import '../infrastructure/auth_remote_service.dart';
import '../infrastructure/auth_repository.dart';
import '../infrastructure/credentials_storage/credentials_storage.dart';
import '../infrastructure/credentials_storage/secure_credentials_storage.dart';

// Networking & Router

final dioProvider = Provider((ref) => Dio());

final routerProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);
  return GoRouter(
    initialLocation: RouteNames.permissionRoute,
    refreshListenable: router,
    // redirect: router.redirectLogic, Z
    routes: router.routes,
  );
});

// Auth

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

// final authInterceptorProvider = Provider(
//   (ref) => AuthInterceptor(ref.watch(authRepositoryProvider)),
// );

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.watch(authRepositoryProvider)),
);

final userNotifierProvider = StateNotifierProvider<UserNotifier, UserState>(
    (ref) => UserNotifier(ref.watch(authRepositoryProvider)));

final signInFormNotifierProvider =
    StateNotifierProvider.autoDispose<SignInFormNotifier, SignInFormState>(
  (ref) => SignInFormNotifier(ref.watch(authRepositoryProvider)),
);

// Absen

final absenRemoteServiceProvider = Provider((ref) => AbsenRemoteService(
    ref.watch(dioProvider),
    ref.watch(userNotifierProvider.select((value) => value.user))));

final absenRepositoryProvider = Provider(
  (ref) => AbsenRepository(
    ref.watch(absenRemoteServiceProvider),
  ),
);

final absenNotifierProvidier = StateNotifierProvider<AbsenNotifier, AbsenState>(
    (ref) => AbsenNotifier(ref.watch(absenRepositoryProvider)));

// Absen auth

final absenAuthNotifierProvidier =
    StateNotifierProvider<AbsenAuthNotifier, AbsenAuthState>(
        (ref) => AbsenAuthNotifier(ref.watch(absenRepositoryProvider)));

// Geofence

final geofenceRemoteServiceProvider = Provider((ref) => GeofenceRemoteService(
    ref.watch(dioProvider),
    ref.watch(userNotifierProvider.select((value) => value.user))));

final geofenceRepositoryProvider = Provider(
  (ref) => GeofenceRepository(
    ref.watch(geofenceRemoteServiceProvider),
  ),
);

final geofenceProvider = StateNotifierProvider<GeofenceNotifier, GeofenceState>(
    (ref) => GeofenceNotifier(
          ref.watch(geofenceRepositoryProvider),
        ));

// Misc

final permissionProvider =
    StateNotifierProvider<PermissionNotifier, PermissionState>(
        (ref) => PermissionNotifier());

final timerProvider = StateNotifierProvider<TimerNotifier, TimerModel>(
  (ref) => TimerNotifier(),
);
