// import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:ntp/ntp.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../absen/application/absen_auth_notifier.dart';
import '../absen/application/absen_auth_state.dart';
import '../absen/application/absen_notifier.dart';
import '../absen/application/absen_state.dart';
import '../absen/infrastructure/absen_remote_service.dart';
import '../absen/infrastructure/absen_repository.dart';

import '../auth/application/auth_notifier.dart';
import '../auth/infrastructure/auth_interceptor.dart';
import '../auth/infrastructure/auth_remote_service.dart';
import '../auth/infrastructure/auth_repository.dart';
import '../auto_absen/application/auto_absen_notifier.dart';
import '../auto_absen/application/auto_absen_repository.dart';
import '../auto_absen/application/auto_absen_state.dart';
import '../background/application/background_notifier.dart';
import '../background/application/background_state.dart';
import '../edit_profile/application/edit_profile_notifier.dart';
import '../edit_profile/application/edit_profile_state.dart';
import '../edit_profile/infrastructure/edit_profile_remote_service.dart';
import '../edit_profile/infrastructure/edit_profile_repository.dart';
import '../geofence/application/geofence_notifier.dart';
import '../geofence/application/geofence_state.dart';
import '../geofence/infrastructure/geofence_remote_service.dart';
import '../geofence/infrastructure/geofence_repository.dart';
import '../home/applicatioin/home_notifier.dart';
import '../home/applicatioin/home_state.dart';
import '../imei/application/imei_auth_notifier.dart';
import '../imei/application/imei_auth_state.dart';
import '../imei/application/imei_notifier.dart';
import '../imei/application/imei_reset_notifier.dart';
import '../imei/application/imei_reset_state.dart';
import '../imei/application/imei_state.dart';

import '../infrastructure/cache_storage/auto_absen_storage.dart';
import '../background/infrastructure/background_repository.dart';
import '../infrastructure/credentials_storage/credentials_storage.dart';
import '../infrastructure/credentials_storage/secure_credentials_storage.dart';

import '../infrastructure/cache_storage/geofence_storage.dart';
import '../infrastructure/cache_storage/imei_storage.dart';
import '../imei/infrastructure/imei_repository.dart';
import '../infrastructure/karyawan/infrastructure/karyawan_repository.dart';

import '../init_user/application/init_user_notifier.dart';
import '../init_user/application/init_user_status.dart';
import '../mock_location/application/mock_location_notifier.dart';
import '../mock_location/application/mock_location_state.dart';
import '../routes/application/route_notifier.dart';
import '../sign_in_form/application/sign_in_form_notifier.dart';
import '../tester/application/tester_notifier.dart';
import '../tester/application/tester_state.dart';
import '../user/application/user_notifier.dart';
import '../user/application/user_state.dart';
// import '../utils/string_utils.dart';

// NETWORKING & ROUTER
final dioProvider = Provider((ref) => Dio());
final dioProviderHosting = Provider((ref) => Dio());

final dioRequestProvider = Provider<Map<String, String>>(
  (ref) => {"kode": "110011"},
);

final routerProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);
  return GoRouter(
    refreshListenable: router,
    redirect: router.redirectLogic,
    routes: router.routes,
  );
});

// AUTH
final flutterSecureStorageProvider = Provider(
  (ref) => FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  ),
);

final credentialsStorageProvider = Provider<CredentialsStorage>(
    (ref) => SecureCredentialsStorage(ref.watch(flutterSecureStorageProvider)));

final imeiCredentialsStorageProvider = Provider<CredentialsStorage>(
  (ref) =>
      ImeiSecureCredentialsStorage(ref.watch(flutterSecureStorageProvider)),
);

final authRemoteServiceProvider = Provider(
  (ref) => AuthRemoteService(
      ref.watch(dioProviderHosting), ref.watch(dioRequestProvider)),
);

final authRepositoryProvider = Provider((ref) => AuthRepository(
      ref.watch(credentialsStorageProvider),
      ref.watch(authRemoteServiceProvider),
    ));

final authInterceptorProvider = Provider(
  (ref) => AuthInterceptor(ref),
);

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref, ref.watch(authRepositoryProvider)),
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

final autoAbsenRepositoryProvider = Provider(
    (ref) => AutoAbsenRepository(ref.watch(autoAbsenSecureStorageProvider)));

final autoAbsenNotifierProvider =
    StateNotifierProvider<AutoAbsenNotifier, AutoAbsenState>(
        (ref) => AutoAbsenNotifier(ref));

final backgroundNotifierProvider =
    StateNotifierProvider<BackgroundNotifier, BackgroundState>(
        (ref) => BackgroundNotifier(BackgroundRepository()));

// EDIT PROFILE
final editProfileRemoteServiceProvider = Provider(
  (ref) => EditProfileRemoteService(
    ref.watch(dioProviderHosting),
    ref.watch(dioRequestProvider),
  ),
);

final editProfileRepositoryProvider = Provider(
  (ref) => EditProfileRepostiroy(
    ref.watch(imeiCredentialsStorageProvider),
    ref.watch(editProfileRemoteServiceProvider),
  ),
);

final editProfileNotifierProvider =
    StateNotifierProvider<EditProfileNotifier, EditProfileState>(
  (ref) => EditProfileNotifier(ref.watch(editProfileRepositoryProvider)),
);

// ABSEN
final absenRemoteServiceProvider = Provider((ref) => AbsenRemoteService(
    ref.watch(dioProvider),
    ref.watch(dioProviderHosting),
    ref.watch(dioRequestProvider),
    ref.watch(userNotifierProvider).user));

final absenRepositoryProvider = Provider(
  (ref) => AbsenRepository(
    ref.watch(absenRemoteServiceProvider),
  ),
);

final absenNotifierProvidier = StateNotifierProvider<AbsenNotifier, AbsenState>(
    (ref) => AbsenNotifier(ref.watch(absenRepositoryProvider)));

final absenOfflineModeProvider = StateProvider<bool>(
  (ref) => false,
);

// ABSEN AUTH
final absenAuthNotifierProvidier =
    StateNotifierProvider<AbsenAuthNotifier, AbsenAuthState>(
        (ref) => AbsenAuthNotifier(ref.watch(absenRepositoryProvider)));

// final absenPrepNotifierProvider =
//     StateNotifierProvider<AbsenPrepNotifier, AbsenPrepState>(
//         (ref) => AbsenPrepNotifier(ref));

final networkTimeFutureProvider = FutureProvider((ref) async {
  DateTime startDate = new DateTime.now().toLocal();
  int offset = await NTP.getNtpOffset(localTime: startDate);
  return startDate.add(new Duration(milliseconds: offset));
});

// GEOFENCE
final geofenceSecureStorageProvider = Provider<CredentialsStorage>(
    (ref) => GeofenceSecureStorage(ref.watch(flutterSecureStorageProvider)));

final geofenceRemoteServiceProvider = Provider((ref) => GeofenceRemoteService(
    ref.watch(dioProviderHosting), ref.watch(dioRequestProvider)));

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

// IMEI
/// imeiCredentialsStorageProvider is used by [EditProfileRepostiroy] and [ImeiRepository]
final imeiRepositoryProvider = Provider(
    (ref) => ImeiRepository(ref.watch(imeiCredentialsStorageProvider)));

final imeiNotifierProvider = StateNotifierProvider<ImeiNotifier, ImeiState>(
    (ref) => ImeiNotifier(ref.watch(editProfileRepositoryProvider),
        ref.watch(imeiRepositoryProvider)));

final imeiAuthNotifierProvider =
    StateNotifierProvider<ImeiAuthNotifier, ImeiAuthState>(
        (ref) => ImeiAuthNotifier());

final imeiResetNotifierProvider =
    StateNotifierProvider<ImeiResetNotifier, ImeiResetState>(
        (ref) => ImeiResetNotifier(ref.watch(imeiRepositoryProvider)));

// HOME

final homeNotifierProvider =
    StateNotifierProvider<HomeNotifier, HomeState>((ref) => HomeNotifier());

// PASS EXPIRED
// final passwordExpiredStorageProvider = Provider<CredentialsStorage>(
//   (ref) => PasswordExpiredStorage(ref.watch(flutterSecureStorageProvider)),
// );

// final passwordExpiredRepositoryProvider = Provider((ref) =>
//     PasswordExpiredRepository(ref.watch(passwordExpiredStorageProvider)));

// final passwordExpiredNotifierProvider = StateNotifierProvider<
//         PasswordExpiredNotifier, PasswordExpiredNotifierState>(
//     (ref) =>
//         PasswordExpiredNotifier(ref.watch(passwordExpiredRepositoryProvider)));

// final passwordExpiredNotifierStatusProvider =
//     StateNotifierProvider<PasswordExpiredNotifierStatus, PasswordExpiredState>(
//         (ref) => PasswordExpiredNotifierStatus(
//             ref, ref.watch(passwordExpiredRepositoryProvider)));

// MOCK LOCATION
final mockLocationNotifierProvider =
    StateNotifierProvider<MockLocationNotifier, MockLocationState>(
  (ref) => MockLocationNotifier(),
);

// MISC
final passwordVisibleProvider = StateProvider.autoDispose<bool>((ref) => false);

final testerNotifierProvider =
    StateNotifierProvider<TesterhNotifier, TesterState>(
        (ref) => TesterhNotifier(ref));
