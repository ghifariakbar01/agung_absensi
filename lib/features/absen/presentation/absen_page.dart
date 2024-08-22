// ignore_for_file: unused_result

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../background/application/saved_location.dart';
import '../../../constants/assets.dart';
import '../../../constants/constants.dart';
import '../../copyright/presentation/copyright_item.dart';
import '../../domain/absen_failure.dart';
import '../../err_log/application/err_log_notifier.dart';
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
import 'absen_button.dart';
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
      await _initializeGeofenceAndSaved();
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

    ref.listenManual<Option<Either<AbsenFailure, Unit>>>(
      absenAuthNotifierProvidier
          .select((value) => value.failureOrSuccessOption),
      (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
          () {},
          (either) => either.fold(
              (failure) => failure.maybeWhen(
                    noConnection: () => _onNoConnection(context),
                    orElse: () => _onErrOther(failure, context),
                  ),
              (_) => _onBerhasilAbsen(context))),
      fireImmediately: true,
    );
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

  @override
  Widget build(BuildContext context) {
    final displayImage = ref.watch(displayImageProvider);
    final isOfflineMode = ref.watch(absenOfflineModeProvider);
    final imei = ref.watch(imeiNotifierProvider);

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

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          toolbarHeight: 45,
        ),
        body: VAsyncValueWidget(
          value: imei,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            padding: const EdgeInsets.all(8.0),
                                            child: Testing(),
                                          )
                                        : Container(),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    AbsenErrorAndButton(),
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
        ));
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

  Future<void> _initializeGeofenceAndSaved() async {
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
    final _time = await ref
        .read(backgroundNotifierProvider.notifier)
        .getLastSavedLocations()
        .then(
          (value) =>
              value == SavedLocation.initial() ? DateTime.now() : value.date,
        );

    await ref.read(backgroundNotifierProvider.notifier).getSavedLocations();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Palette.green,
      builder: (context) => Success(
        DateFormat('HH:mm').format(_time),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
    );
  }

  Future<void> _onBerhasilAbsen(BuildContext context) async {
    ref.read(buttonResetVisibilityProvider.notifier).state = false;
    ref.read(absenOfflineModeProvider.notifier).state = false;
    await OSVibrate.vibrate();

    await ref.read(backgroundNotifierProvider.notifier).clear();

    final _riwayat = RiwayatAbsenState.initial();
    await ref.read(riwayatAbsenNotifierProvider.notifier).getAbsenRiwayat(
          dateFirst: _riwayat.dateFirst,
          dateSecond: _riwayat.dateSecond,
        );
  }

  Future<void> _onNoConnection(
    BuildContext context,
  ) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => VSimpleDialog(
              color: Palette.red,
              asset: Assets.iconCrossed,
              label: 'NoConnection',
              labelDescription: 'Tidak ada koneksi',
            )).then((_) => showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => VSimpleDialog(
              asset: Assets.iconChecked,
              label: 'Saved',
              labelDescription:
                  'Absen masih tersimpan di HP. Mohon lakukan absen saat ada jaringan internet.',
            )));
  }

  Future<void> _onErrOther(
    AbsenFailure failure,
    BuildContext context,
  ) async {
    final String errMessage = failure.maybeWhen(
        server: (code, message) => 'Error $code $message',
        passwordExpired: () => 'Password Expired',
        passwordWrong: () => 'Password Wrong',
        orElse: () => '');

    await failure.maybeWhen(
        server: (_, __) =>
            ref.read(backgroundNotifierProvider.notifier).clear(),
        orElse: () {});

    await ref.read(errLogControllerProvider.notifier).sendLog(
          isHoting: true,
          errMessage: errMessage,
        );

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => VSimpleDialog(
              asset: Assets.iconCrossed,
              label: 'Error',
              labelDescription: errMessage,
            ));
  }
}
