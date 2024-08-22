// import 'package:face_net_authentication/utils/logging.dart';

import 'package:dio/dio.dart';

import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/absen/application/absen_auth_notifier.dart';
import '../features/absen/application/absen_auth_state.dart';
import '../features/absen/application/absen_notifier.dart';
import '../features/absen/application/absen_state.dart';
import '../features/absen/infrastructures/absen_remote_service.dart';
import '../features/absen/infrastructures/absen_repository.dart';

import '../features/auth/application/auth_notifier.dart';
import '../features/auth/infrastructures/auth_interceptor.dart';
import '../features/auth/infrastructures/auth_interceptor_two.dart';
import '../features/auth/infrastructures/auth_remote_service.dart';
import '../features/auth/infrastructures/auth_repository.dart';

import '../features/background/application/background_notifier.dart';
import '../features/background/application/background_state.dart';

import '../features/geofence/application/geofence_notifier.dart';
import '../features/geofence/application/geofence_state.dart';
import '../features/geofence/infrastructures/geofence_remote_service.dart';
import '../features/geofence/infrastructures/geofence_repository.dart';
import '../features/home/applicatioin/home_notifier.dart';
import '../features/home/applicatioin/home_state.dart';
import '../features/imei/application/imei_auth_notifier.dart';
import '../features/imei/application/imei_auth_state.dart';
import '../features/imei/application/imei_reset_notifier.dart';
import '../features/imei/application/imei_reset_state.dart';

import '../features/imei/infrastructures/imei_remote_service.dart';
import '../infrastructures/cache_storage/auto_absen_storage.dart';
import '../features/background/infrastructures/background_repository.dart';
import '../infrastructures/cache_storage/imei_checked_storage.dart';
import '../infrastructures/cache_storage/riwayat_storage.dart';
import '../infrastructures/credentials_storage/credentials_storage.dart';
import '../infrastructures/credentials_storage/secure_credentials_storage.dart';

import '../infrastructures/cache_storage/geofence_storage.dart';
import '../infrastructures/cache_storage/imei_storage.dart';
import '../features/imei/infrastructures/imei_repository.dart';
import '../infrastructures/karyawan/infrastructures/karyawan_repository.dart';

import '../features/init_user/application/init_user_notifier.dart';
import '../features/init_user/application/init_user_status.dart';
import '../features/mock_location/application/mock_location_notifier.dart';
import '../features/mock_location/application/mock_location_state.dart';
import '../features/riwayat_absen/application/riwayat_absen_notifier.dart';
import '../features/riwayat_absen/application/riwayat_absen_state.dart';
import '../features/routes/application/route_notifier.dart';
import '../features/sign_in_form/application/sign_in_form_notifier.dart';
import '../features/tester/application/tester_notifier.dart';
import '../features/tester/application/tester_state.dart';
import '../features/user/application/user_notifier.dart';
import '../features/user/application/user_state.dart';

part 'providers.g.dart';

// import '../utils/string_utils.dart';

/*
  --------- ESSENTIALS ---------
  - NETWORKING & ROUTER
  - ROUTE
  - STORAGE
*/

// NETWORKING & ROUTER
final dioProvider = Provider((ref) => Dio());
final dioProviderHosting = Provider((ref) => Dio());

final dioProviderCuti = Provider((ref) => Dio());
final dioProviderCutiServer = Provider((ref) => Dio());

final dioRequestProvider = Provider<Map<String, String>>(
  (ref) => {"kode": "110011"},
);

// ROUTE
final routerProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);
  return GoRouter(
    refreshListenable: router,
    redirect: router.redirectLogic,
    routes: router.routes,
  );
});

AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );

// STORAGE
@Riverpod(keepAlive: true)
FlutterSecureStorage flutterSecureStorage(FlutterSecureStorageRef ref) {
  return FlutterSecureStorage(
    aOptions: _getAndroidOptions(),
  );
}

/*
  ------------------
*/

final authRemoteServiceProvider = Provider(
  (ref) =>
      AuthRemoteService(ref.watch(dioProvider), ref.watch(dioRequestProvider)),
);

@Riverpod(keepAlive: true)
SecureCredentialsStorage credentialsStorage(CredentialsStorageRef ref) {
  return SecureCredentialsStorage(
    ref.watch(flutterSecureStorageProvider),
  );
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(
    ref.watch(credentialsStorageProvider),
    ref.watch(authRemoteServiceProvider),
  );
}

final authInterceptorProvider = Provider(
  (ref) => AuthInterceptor(ref),
);

final authInterceptorTwoProvider = Provider(
  (ref) => AuthInterceptorTwo(ref),
);

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.watch(authRepositoryProvider)),
);

final userNotifierProvider = StateNotifierProvider<UserNotifier, UserState>(
    (ref) => UserNotifier(ref.watch(authRepositoryProvider)));

final signInFormNotifierProvider =
    StateNotifierProvider.autoDispose<SignInFormNotifier, SignInFormState>(
  (ref) => SignInFormNotifier(ref.watch(authRepositoryProvider)),
);

// INIT PAGE
final initUserStatusNotifierProvider =
    StateNotifierProvider<InitUserNotifier, InitUserStatus>(
        (ref) => InitUserNotifier(ref));

// BACKGROUND
final autoAbsenSecureStorageProvider = Provider<CredentialsStorage>(
  (ref) => AutoAbsenStorage(ref.watch(flutterSecureStorageProvider)),
);

final backgroundNotifierProvider =
    StateNotifierProvider<BackgroundNotifier, BackgroundState>(
        (ref) => BackgroundNotifier(BackgroundRepository()));

// ABSEN
final absenRemoteServiceProvider = Provider(
  (ref) => AbsenRemoteService(
      ref.watch(dioProvider),
      ref.watch(dioProviderHosting),
      ref.watch(dioRequestProvider),
      ref.watch(userNotifierProvider).user),
);

// RIWAYAT ABSEN
@Riverpod(keepAlive: true)
RiwayatStorage riwayatStorage(RiwayatStorageRef ref) {
  return RiwayatStorage(
    ref.watch(flutterSecureStorageProvider),
  );
}

final absenRepositoryProvider = Provider(
  (ref) => AbsenRepository(
    ref.watch(absenRemoteServiceProvider),
    ref.watch(riwayatStorageProvider),
  ),
);

final absenNotifierProvidier = StateNotifierProvider<AbsenNotifier, AbsenState>(
    (ref) => AbsenNotifier(ref.watch(absenRepositoryProvider)));

final absenOfflineModeProvider = StateProvider<bool>(
  (ref) => false,
);

// RIWAYAT ABSEN
final riwayatAbsenNotifierProvider =
    StateNotifierProvider<RiwayatAbsenNotifier, RiwayatAbsenState>(
  (ref) => RiwayatAbsenNotifier(ref.watch(absenRepositoryProvider)),
);

// ABSEN AUTH
final absenAuthNotifierProvidier =
    StateNotifierProvider<AbsenAuthNotifier, AbsenAuthState>(
        (ref) => AbsenAuthNotifier(ref.watch(absenRepositoryProvider)));

// GEOFENCE
final geofenceSecureStorageProvider = Provider<CredentialsStorage>(
    (ref) => GeofenceSecureStorage(ref.watch(flutterSecureStorageProvider)));

final geofenceRemoteServiceProvider = Provider((ref) => GeofenceRemoteService(
    ref.watch(dioProvider), ref.watch(dioRequestProvider)));

final geofenceRepositoryProvider = Provider(
  (ref) => GeofenceRepository(ref.watch(geofenceRemoteServiceProvider),
      ref.watch(geofenceSecureStorageProvider)),
);

final geofenceProvider = StateNotifierProvider<GeofenceNotifier, GeofenceState>(
    (ref) => GeofenceNotifier(
          ref.watch(geofenceRepositoryProvider),
        ));

// KARYAWAN SHIFT
final karyawanShiftRepositoryProvider =
    Provider((ref) => KaryawanShiftRepository());

final karyawanShiftFutureProvider = FutureProvider<bool>((ref) async {
  final _repository = ref.watch(karyawanShiftRepositoryProvider);

  return await _repository.isKaryawanShift();
});

/* 
 =================================================================
 ================== [ IMEI PROVIDERS ] ===========================
=================================================================
 */
@Riverpod(keepAlive: true)
ImeiSecureCredentialsStorage imeiSecureCredentialsStorage(
    ImeiSecureCredentialsStorageRef ref) {
  return ImeiSecureCredentialsStorage(
    ref.watch(flutterSecureStorageProvider),
  );
}

@Riverpod(keepAlive: true)
ImeiCheckedStorage imeiCheckedStorage(ImeiCheckedStorageRef ref) {
  return ImeiCheckedStorage(
    ref.watch(flutterSecureStorageProvider),
  );
}

@Riverpod(keepAlive: true)
ImeiRemoteService imeiRemoteService(ImeiRemoteServiceRef ref) {
  return ImeiRemoteService(
    ref.watch(dioProvider),
    ref.watch(dioRequestProvider),
  );
}

@Riverpod(keepAlive: true)
ImeiRepository imeiRepository(ImeiRepositoryRef ref) {
  return ImeiRepository(
    ref.watch(imeiSecureCredentialsStorageProvider),
    ref.watch(imeiCheckedStorageProvider),
    ref.watch(imeiRemoteServiceProvider),
  );
}

final imeiAuthNotifierProvider =
    StateNotifierProvider<ImeiAuthNotifier, ImeiAuthState>(
        (ref) => ImeiAuthNotifier());

final imeiResetNotifierProvider =
    StateNotifierProvider<ImeiResetNotifier, ImeiResetState>(
        (ref) => ImeiResetNotifier(ref.watch(imeiRepositoryProvider)));

/* 
   ==================================================================
   ================== END ===========================================
   ==================================================================
 */

// HOME

final homeNotifierProvider =
    StateNotifierProvider<HomeNotifier, HomeState>((ref) => HomeNotifier());

// MOCK LOCATION
final mockLocationNotifierProvider =
    StateNotifierProvider<MockLocationNotifier, MockLocationState>(
  (ref) => MockLocationNotifier(),
);

// MISC
final passwordVisibleProvider = StateProvider.autoDispose<bool>((ref) => false);

final testerNotifierProvider =
    StateNotifierProvider<TesterhNotifier, TesterState>(
  (ref) => TesterhNotifier(ref),
);
