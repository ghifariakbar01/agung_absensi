// ignore_for_file: unused_result

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/features/cross_auth/application/cross_auth_notifier.dart';
import 'package:face_net_authentication/features/cross_auth/application/is_user_crossed.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../utils/logging.dart';
import '../../background/application/saved_location.dart';
import '../../../constants/assets.dart';
import '../../../constants/constants.dart';
import '../../copyright/presentation/copyright_item.dart';
import '../../domain/absen_failure.dart';
import '../../err_log/application/err_log_notifier.dart';
import '../../firebase/remote_config/application/firebase_remote_config_notifier.dart';
import '../../imei/application/imei_notifier.dart';
import '../../imei/application/imei_state.dart';
import '../../imei_introduction/application/shared/imei_introduction_providers.dart';
import '../../../infrastructures/exceptions.dart';
import '../../riwayat_absen/application/riwayat_absen_state.dart';
import '../../../shared/providers.dart';
import '../../../style/style.dart';
import '../../../utils/dialog_helper.dart';
import '../../../utils/os_vibrate.dart';
import '../../../widgets/image_absen.dart';
import '../../../widgets/testing.dart';
import '../../../widgets/user_info.dart';
import '../../../widgets/v_async_widget.dart';
import '../../../widgets/v_dialogs.dart';
import 'absen_error_and_button.dart';

import 'absen_success.dart';

class AbsenPage extends StatefulHookConsumerWidget {
  AbsenPage({Key? key}) : super(key: key);
  @override
  _AbsenPageState createState() => _AbsenPageState();
}

class _AbsenPageState extends ConsumerState<AbsenPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeAbsen();
      await _recheckTesterState();
    });

    ref.listenManual<AsyncValue<ImeiState>>(
      imeiNotifierProvider,
      (_, state) async {
        if (!state.isLoading &&
            state.hasValue &&
            state.value != '' &&
            state.value != null &&
            state.hasError == false &&
            state.value != AsyncData<ImeiState>(ImeiState.initial()) &&
            state.value != AsyncData<ImeiState>(ImeiState.rejected()) &&
            state.value !=
                AsyncData<ImeiState>(ImeiState.notRegisteredAfterAbsen())) {
          state.requireValue.maybeWhen(
            alreadyRegistered: () => _onImeiNotRegistered(),
            notRegistered: () => _onImeiNotRegistered(),
            initial: () {},
            ok: () => _onImeiOk(),
            rejected: () {},
            notRegisteredAfterAbsen: () {},
            orElse: () {},
          );
        } else {
          if (state.hasError) {
            final error = state.error;
            if (error is PlatformException) {
              return DialogHelper.showCustomDialog(
                'Error Storage Penuh : Tidak bisa menyimpan imei',
                context,
              ).then((_) => _reset());
            } else if (error is NoConnectionException) {
              return DialogHelper.showCustomDialog(
                'Tidak ada jaringan internet / server down. Absen masih tersimpan',
                context,
              ).then((_) => _reset());
            } else if (error is RestApiExceptionWithMessage) {
              return DialogHelper.showCustomDialog(
                'Error server. ${error.errorCode} : ${error.message}',
                context,
              ).then((_) => _reset());
            } else if (error is RestApiException) {
              return DialogHelper.showCustomDialog(
                'Error server. ${error.errorCode}',
                context,
              ).then((_) => _reset());
            }

            return state.showAlertDialogOnError(context, ref);
          }
        }
      },
      fireImmediately: true,
    );

    ref.listenManual<List<Option<Either<AbsenFailure, SavedLocation>>>>(
      absenAuthNotifierProvidier
          .select((value) => value.failureOrSuccessOptionList),
      (_, list) async {
        for (int i = 0; i < list.length; i++) {
          final e = list[i];
          final isLast = i + 1 == list.length;

          await e.fold(
              () {},
              (either) => either.fold(
                      (failure) => failure.when(
                          noConnection: (item) => _onNoConnection(
                              item: item,
                              context: context,
                              checkProcessedAbsen: () async {
                                if (isLast) {
                                  return _checkProcessedAbsen(context);
                                }
                              }),
                          server: (errorCode, message, item) => _onErrOther(
                              item: item,
                              failure: failure,
                              context: context,
                              checkProcessedAbsen: () async {
                                if (isLast) {
                                  return _checkProcessedAbsen(context);
                                }
                              }),
                          passwordExpired: (item) => _onErrOther(
                              item: item,
                              failure: failure,
                              context: context,
                              checkProcessedAbsen: () async {
                                if (isLast) {
                                  return _checkProcessedAbsen(context);
                                }
                              }),
                          passwordWrong: (item) => _onErrOther(
                              item: item,
                              failure: failure,
                              context: context,
                              checkProcessedAbsen: () async {
                                if (isLast) {
                                  return _checkProcessedAbsen(context);
                                }
                              })), (item) async {
                    await _deleteSaved(item.id);

                    if (isLast) {
                      return _checkProcessedAbsen(context);
                    }
                  }));
        }
      },
      fireImmediately: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRefreshed = useState(false);
    final displayImage = ref.watch(displayImageProvider);
    final isOfflineMode = ref.watch(absenOfflineModeProvider);
    final imei = ref.watch(imeiNotifierProvider);
    final isUserCrossed = ref.watch(isUserCrossedProvider);
    final crossAuthNotifier = ref.watch(crossAuthNotifierProvider);

    final isLoading = ref.watch(
          imeiNotifierProvider.select((value) => value.isLoading),
        ) ||
        ref.watch(
          geofenceProvider.select((value) => value.isGetting),
        ) ||
        ref.watch(
          backgroundNotifierProvider.select((value) => value.isGetting),
        ) ||
        ref.watch(
          riwayatAbsenNotifierProvider.select((value) => value.isGetting),
        ) ||
        ref.watch(
          absenAuthNotifierProvidier.select((value) => value.isSubmitting),
        );

    Log.info('isOfflineMode $isOfflineMode isLoading $isLoading');

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          toolbarHeight: 45,
          actions: [
            isRefreshed.value == false
                ? IconButton(
                    onPressed: () async {
                      final result = await DialogHelper.showConfirmationDialog(
                          label: ' Refresh ulang Geofence ? ',
                          context: context);

                      if (result) {
                        ref.read(geofenceProvider.notifier).resetFOSO();
                        await ref.read(geofenceProvider.notifier).clear();
                        await ref
                            .read(geofenceProvider.notifier)
                            .getGeofenceList();

                        isRefreshed.value = true;
                      }
                    },
                    icon: Icon(Icons.pin_drop_outlined),
                  )
                : IconButton(
                    onPressed: () async {
                      return DialogHelper.showCustomDialog(
                          'Anda sudah melakukan refresh', context);
                    },
                    icon: Icon(Icons.pin_drop),
                  )
          ],
        ),
        body: VAsyncValueWidget(
          value: imei,
          data: (_) => VAsyncValueWidget(
            value: crossAuthNotifier,
            data: (_) => SafeArea(
              child: !isOfflineMode && isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                          height: displayImage == false || isOfflineMode
                              ? MediaQuery.of(context).size.height + 300
                              : MediaQuery.of(context).size.height + 475,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Palette.containerBackgroundColor
                                        .withOpacity(0.1),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 4,
                                      ),
                                      UserInfo(
                                        'User ${isOfflineMode ? '(Mode Offline)' : ''}',
                                      ),
                                      Constants.isDev
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Testing(),
                                            )
                                          : Container(),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      VAsyncValueWidget<IsUserCrossedState>(
                                          value: isUserCrossed,
                                          data: (isCrossed) => isCrossed.when(
                                                crossed: () => TextButton(
                                                    onPressed: () async {
                                                      final _ptMap = await ref
                                                          .read(
                                                              firebaseRemoteConfigNotifierProvider
                                                                  .notifier)
                                                          .getPtMap();
                                                      final user = ref
                                                          .read(
                                                              userNotifierProvider)
                                                          .user;

                                                      if (user.idUser == null ||
                                                          user.password ==
                                                              null) {
                                                        return DialogHelper
                                                            .showCustomDialog(
                                                                'idUser atau password null',
                                                                context);
                                                      }

                                                      return ref
                                                          .read(
                                                              crossAuthNotifierProvider
                                                                  .notifier)
                                                          .uncross(
                                                              userId: user
                                                                  .idUser
                                                                  .toString(),
                                                              password: user
                                                                  .password!,
                                                              url: _ptMap);
                                                    },
                                                    child:
                                                        Text('User Crossed')),
                                                notCrossed: () =>
                                                    AbsenErrorAndButton(),
                                              )),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 0,
                                right: 0,
                                child: CopyrightItem(),
                              )
                            ],
                          )),
                    ),
            ),
          ),
        ));
  }

  Future<void> _checkProcessedAbsen(BuildContext context) async {
    final List<SavedLocation> processed =
        ref.read(absenAuthNotifierProvidier).absenProcessedList;

    if (processed.isEmpty) {
      return Future.value();
    } else {
      ref.read(absenAuthNotifierProvidier.notifier).resetFoso();
      return _onBerhasilAbsen(context);
    }
  }

  Future<void> _onImeiAlreadyRegistered() async {
    String idKary = await _getIdKary();

    final imeiNotifier = ref.read(imeiNotifierProvider.notifier);

    await imeiNotifier.onImeiAlreadyRegistered(
      idKary: idKary,
    );

    await showSuccessDialog(
      context,
      'Absen berhasil, tapi kami mendeteksi abnormality.',
    ).then((_) => showErrorDialog(
          context,
          Constants.imeiAlreadyRegistered,
        ).then(
          (_) => _restartImeiIntro(),
        ));

    _reset();
  }

  Future<void> _onImeiNotRegistered() async {
    String idKary = await _getIdKary();

    final imeiNotifier = ref.read(imeiNotifierProvider.notifier);
    final generateImei = imeiNotifier.generateImei();

    await imeiNotifier.registerImeiAfterAbsen(
      imei: generateImei,
      idKary: idKary,
    );

    await showSuccessDialog(
      context,
      'Absen berhasil, tapi kami mendeteksi abnormality.',
    ).then((_) => showErrorDialog(
          context,
          Constants.imeiNotRegistered,
        ).then(
          (_) => logout(ref),
        ));

    _reset();
  }

  _restartImeiIntro() async {
    await ref
        .read(imeiIntroNotifierProvider.notifier)
        .clearVisitedIMEIIntroduction();
    await ref
        .read(imeiIntroNotifierProvider.notifier)
        .checkAndUpdateImeiIntro();
    await ref.read(userNotifierProvider.notifier).logout();
    await ref.read(authNotifierProvider.notifier).checkAndUpdateAuthStatus();
  }

  Future<void> _recheckTesterState() async {
    await ref.read(testerNotifierProvider).maybeWhen(
        forcedRegularUser: () {},
        orElse: () => ref
            .read(testerNotifierProvider.notifier)
            .checkAndUpdateTesterState());
  }

  Future<void> _initializeAbsen() async {
    await ref.read(testerNotifierProvider).maybeWhen(
          tester: () async {},
          orElse: () async {
            await ref
                .read(backgroundNotifierProvider.notifier)
                .getSavedLocations();

            await ref
                .read(absenNotifierProvidier.notifier)
                .getAbsenTodayFromStorage();
          },
        );
  }

  Future<String> _getIdKary() async {
    final user = await ref.read(userNotifierProvider.notifier).getUserString();
    final idKary = user.IdKary ?? '-';
    return idKary;
  }

  Future<void> showErrorDialog(
    BuildContext context,
    String message,
  ) =>
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => VSimpleDialog(
          label: 'Oops',
          color: Palette.red,
          textColor: Colors.white,
          labelDescription: message,
          asset: Assets.iconCrossed,
        ),
      );

  Future<void> showSuccessDialog(
    BuildContext context,
    String message,
  ) =>
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => VSimpleDialog(
          label: 'Abnormal',
          color: Palette.green,
          textColor: Colors.white,
          labelDescription: message,
          asset: Assets.iconChecked,
        ),
      );

  _reset() {
    ref.read(imeiNotifierProvider.notifier).reset();
  }

  logout(WidgetRef ref) async {
    await ref.read(userNotifierProvider.notifier).logout();
    await ref.read(authNotifierProvider.notifier).checkAndUpdateAuthStatus();
  }

  _onImeiOk() async {
    final list = ref.read(absenAuthNotifierProvidier).absenProcessedList;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Palette.green,
      builder: (_) => Success(list),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
    );
  }

  Future<Unit> _deleteSaved(int id) async {
    return ref
        .read(backgroundNotifierProvider.notifier)
        .removeLocationFromSavedById(id);
  }

  Future<void> _onBerhasilAbsen(BuildContext context) async {
    ref.read(absenOfflineModeProvider.notifier).state = false;
    await OSVibrate.vibrate();

    final _riwayat = RiwayatAbsenState.initial();
    final idUser = ref.read(userNotifierProvider).user.idUser!;
    await ref.read(riwayatAbsenNotifierProvider.notifier).getAbsenRiwayat(
          idUser: idUser,
          dateFirst: _riwayat.dateFirst,
          dateSecond: _riwayat.dateSecond,
        );
  }

  Future<void> _onNoConnection({
    required SavedLocation item,
    required BuildContext context,
    required Function() checkProcessedAbsen,
  }) async {
    final lokasiDetail =
        "\n Tanggal : ${DateFormat('dd, MMM HH:mm').format(item.date)}, Lokasi : ${item.alamat} \n";

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => VSimpleDialog(
              color: Palette.red,
              asset: Assets.iconCrossed,
              label: 'NoConnection',
              labelDescription:
                  'Tidak ada koneksi saat melakukan absensi ${lokasiDetail}. Lihat daftar absen tersimpan anda di halaman Absen',
            )).then((_) => showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => VSimpleDialog(
              asset: Assets.iconChecked,
              label: 'Saved',
              labelDescription:
                  'Absen ${lokasiDetail} masih tersimpan di HP. Anda bisa melihat daftar absen tersimpan anda di halaman Absen. Mohon lakukan absen saat ada jaringan internet.',
            )).then((_) => checkProcessedAbsen()));
  }

  Future<void> _onErrOther({
    required SavedLocation item,
    required AbsenFailure failure,
    required BuildContext context,
    required Function() checkProcessedAbsen,
  }) async {
    final lokasiDetail =
        "\n\n Tanggal : ${DateFormat('dd, MMM HH:mm').format(item.date)}\nLokasi : ${item.alamat} \n\n";

    final String errMessage = failure.maybeWhen(
        server: (code, message, id) => code == 10
            ? 'Anda mencoba absen 2x pada $lokasiDetail. Absen pertama anda sudah masuk dalam database. \n Mohon cek riwayat absen Terimakasih'
            : 'Error Saat absensi $lokasiDetail : $code $message. \n Lihat daftar absen tersimpan anda di halaman Absen \n',
        passwordExpired: (id) =>
            'Password Expired Saat absensi $lokasiDetail. \n Lihat daftar absen tersimpan anda di halaman Absen',
        passwordWrong: (id) =>
            'Password Wrong Saat absensi $lokasiDetail. \n Lihat daftar absen tersimpan anda di halaman Absen',
        orElse: () => '');

    await failure.maybeWhen(
      server: (errorCode, __, id) => errorCode == 10
          ? ref
              .read(backgroundNotifierProvider.notifier)
              .removeLocationFromSavedById(item.id)
          : () {},
      orElse: () {},
    );

    await ref.read(errLogControllerProvider.notifier).sendLog(
          isHoting: true,
          errMessage: errMessage,
        );

    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => VSimpleDialog(
              asset: Assets.iconCrossed,
              label: 'Error',
              labelDescription: errMessage,
            )).then((_) => checkProcessedAbsen());
  }
}
