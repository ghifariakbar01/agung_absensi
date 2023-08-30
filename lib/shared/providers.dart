import 'package:dio/dio.dart';

import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ntp/ntp.dart';

import '../application/absen/absen_auth_notifier.dart';
import '../application/absen/absen_auth_state.dart';
import '../application/absen/absen_notifier.dart';
import '../application/absen/absen_state.dart';
import '../application/auth/auth_notifier.dart';
import '../application/auto_absen/auto_absen_notifier.dart';
import '../application/auto_absen/auto_absen_repository.dart';
import '../application/auto_absen/auto_absen_state.dart';
import '../application/background/background_notifier.dart';
import '../application/background/background_state.dart';
import '../application/edit_profile/edit_profile_notifier.dart';
import '../application/edit_profile/edit_profile_state.dart';
import '../application/geofence/geofence_notifier.dart';
import '../application/geofence/geofence_state.dart';
import '../application/imei/imei_auth_state.dart';
import '../application/imei/imei_notifier.dart';
import '../application/imei/imei_saved_notifier.dart';
import '../application/imei/imei_state.dart';
import '../application/karyawan/karyawan_shift_notifier.dart';
import '../application/routes/route_notifier.dart';
import '../application/sign_in_form/sign_in_form_notifier.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../application/user/user_notifier.dart';
import '../application/user/user_state.dart';
import '../infrastructure/absen/absen_remote_service.dart';
import '../infrastructure/absen/absen_repository.dart';

import '../infrastructure/auth/auth_remote_service.dart';
import '../infrastructure/auth/auth_repository.dart';
import '../infrastructure/cache_storage/auto_absen_storage.dart';
import '../infrastructure/background/background_repository.dart';
import '../infrastructure/credentials_storage/credentials_storage.dart';
import '../infrastructure/credentials_storage/secure_credentials_storage.dart';

import '../infrastructure/geofence/geofence_remote_service.dart';
import '../infrastructure/geofence/geofence_repository.dart';
import '../infrastructure/cache_storage/geofence_storage.dart';
import '../infrastructure/cache_storage/imei_storage.dart';
import '../infrastructure/imei/imei_repository.dart';
import '../infrastructure/karyawan/karyawan_repository.dart';
import '../infrastructure/profile/edit_profile_remote_service.dart';
import '../infrastructure/profile/edit_profile_repository.dart';
import '../utils/string_utils.dart';

// Networking & Router

final dioProvider = Provider((ref) => Dio());

final dioRequestProvider = Provider<Map<String, String>>(
  (ref) => {"kode": "${StringUtils.formatDate(DateTime.now())}"},
);

final routerProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);
  return GoRouter(
    refreshListenable: router,
    redirect: router.redirectLogic,
    routes: router.routes,
  );
});

// Background

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

// Auth

final flutterSecureStorageProvider = Provider(
  (ref) => const FlutterSecureStorage(),
);

final credentialsStorageProvider = Provider<CredentialsStorage>(
  (ref) => SecureCredentialsStorage(ref.watch(flutterSecureStorageProvider)),
);

final imeiCredentialsStorageProvider = Provider<CredentialsStorage>(
  (ref) =>
      ImeiSecureCredentialsStorage(ref.watch(flutterSecureStorageProvider)),
);

final authRemoteServiceProvider = Provider(
  (ref) =>
      AuthRemoteService(ref.watch(dioProvider), ref.watch(dioRequestProvider)),
);

final authRepositoryProvider = Provider((ref) => AuthRepository(
      ref.watch(credentialsStorageProvider),
      ref.watch(authRemoteServiceProvider),
    ));

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

final isKarwayanShiftNotifierProvider =
    StateNotifierProvider.autoDispose<KaryawanShiftNotifier, bool>(
  (ref) => KaryawanShiftNotifier(KaryawanShiftRepository()),
);

// Edit Profile

final editProfileRemoteServiceProvider = Provider(
  (ref) => EditProfileRemoteService(
      ref.watch(dioProvider),
      ref.watch(userNotifierProvider.select((value) => value.user)),
      ref.watch(dioRequestProvider)),
);

final editProfileRepositoryProvider = Provider(
  (ref) => EditProfileRepostiroy(ref.watch(editProfileRemoteServiceProvider),
      ref.watch(imeiCredentialsStorageProvider)),
);

final editProfileNotifierProvider =
    StateNotifierProvider<EditProfileNotifier, EditProfileState>(
  (ref) => EditProfileNotifier(ref.watch(editProfileRepositoryProvider)),
);

// Absen

final absenRemoteServiceProvider = Provider((ref) => AbsenRemoteService(
    ref.watch(dioProvider),
    ref.watch(userNotifierProvider.select((value) => value.user)),
    ref.watch(dioRequestProvider)));

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

// Absen auth

final absenAuthNotifierProvidier =
    StateNotifierProvider<AbsenAuthNotifier, AbsenAuthState>(
        (ref) => AbsenAuthNotifier(ref.watch(absenRepositoryProvider)));

final networkTimeFutureProvider = FutureProvider((ref) async {
  DateTime startDate = new DateTime.now().toLocal();
  int offset = await NTP.getNtpOffset(localTime: startDate);
  return startDate.add(new Duration(milliseconds: offset));
});

// Geofence

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

// Imei

final imeiRepositoryProvider = Provider(
    (ref) => ImeiRepository(ref.watch(imeiCredentialsStorageProvider)));

final imeiNotifierProvider =
    StateNotifierProvider<ImeiNotifier, ImeiState>((ref) => ImeiNotifier());

final imeiAuthNotifierProvider =
    StateNotifierProvider<ImeiAuthNotifier, ImeiAuthState>(
        (ref) => ImeiAuthNotifier(ref.watch(imeiRepositoryProvider)));

// Misc

final passwordVisibleProvider = StateProvider.autoDispose<bool>((ref) => false);

final karyawanShiftProvider = StateProvider((ref) => false);
