import 'dart:io';

import 'package:dartz/dartz.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/assets.dart';
import '../../constants/constants.dart';
import '../../domain/edit_failure.dart';
import '../../firebase/remote_config/application/firebase_remote_config_notifier.dart';
import '../../imei_introduction/application/shared/imei_introduction_providers.dart';
import '../../ios_user_maintanance/ios_user_maintanance_notifier.dart';
import '../../shared/future_providers.dart';
import '../../shared/providers.dart';
import '../../tc/application/shared/tc_providers.dart';
import '../../utils/dialog_helper.dart';
import '../../widgets/v_async_widget.dart';
import '../../widgets/v_dialogs.dart';
import 'profile_scaffold.dart';

class ProfilePage extends StatefulHookConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final remoteConfigCfg =
          await ref.read(firebaseRemoteConfigNotifierProvider.future);

      return Future.delayed(
          Duration(seconds: 1),
          () => ref
              .read(iosUserMaintananceProvider.notifier)
              .setIosUserMaintanance(remoteConfigCfg.iosUserMaintanance));
    });
  }

  @override
  Widget build(BuildContext context) {
    // FOR UNLINK DEVICE
    ref.listen<Option<Either<EditFailure, Unit?>>>(
      imeiNotifierProvider.select(
        (state) => state.failureOrSuccessOptionClearRegisterImei,
      ),
      (_, failureOrSuccessOption) => failureOrSuccessOption
          .fold(
              () {},
              (either) => either.fold(
                  (failure) => failure.maybeMap(
                        noConnection: (_) => null,
                        orElse: () => showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (_) => VSimpleDialog(
                            label: 'Error',
                            labelDescription: failure.maybeMap(
                                server: (server) => 'error server $server',
                                passwordExpired: (password) => '$password',
                                passwordWrong: (password) => '$password',
                                orElse: () => ''),
                            asset: Assets.iconCrossed,
                          ),
                        ),
                      ),
                  (_) => DialogHelper.showCustomDialog(
                        'Unlink Sukses. Mohon Uninstall Aplikasi. Terimakasih 🙏',
                        context,
                        label: 'Uninstall',
                        isLarge: true,
                        assets: Assets.iconChecked,
                      )))!
          .then((_) => _onImeiCleared()),
    );

    final user = ref.watch(getUserFutureProvider);

    return VAsyncWidgetScaffold(
      value: user,
      data: (_) => ProfileScaffold(),
    );
  }

  Future<void> _onImeiCleared() async {
    final _idKary = ref.read(userNotifierProvider).user.IdKary ?? 'null';

    bool isSuccess = await ref
        .read(imeiNotifierProvider.notifier)
        .clearImeiSuccess(idKary: _idKary);

    if (isSuccess) {
      if (Platform.isIOS) {
        final isMaintaining = await _isMaintaining();
        if (isMaintaining) {
          return _executeMaintanance(ref);
        }

        return ref
            .read(imeiNotifierProvider.notifier)
            .clearImeiFromDBAndLogoutiOS(ref);
      } else {
        return ref
            .read(imeiNotifierProvider.notifier)
            .clearImeiFromDBAndLogout(ref);
      }
    }
  }

  Future<bool> _isMaintaining() async {
    final iosUserMaintanance =
        await ref.read(iosUserMaintananceProvider.future);

    return iosUserMaintanance.isNotEmpty &&
        iosUserMaintanance != Constants.iosUserMaintanance;
  }

  _executeMaintanance(WidgetRef ref) async {
    _backToLoginScreen(ref);
    await _resetIntroScreens(ref);
    await _obliterate(ref);
    await _authCheck(ref);
  }

  _backToLoginScreen(WidgetRef ref) {
    ref.read(userNotifierProvider.notifier).setUserInitial();
    ref.read(initUserStatusNotifierProvider.notifier).hold();
  }

  _resetIntroScreens(WidgetRef ref) async {
    final tcNotifier = ref.read(tcNotifierProvider.notifier);
    await tcNotifier.clearVisitedTC();
    await tcNotifier.checkAndUpdateStatusTC();

    final imeiInstructionNotifier =
        ref.read(imeiIntroNotifierProvider.notifier);
    await imeiInstructionNotifier.clearVisitedIMEIIntroduction();
    await imeiInstructionNotifier.checkAndUpdateImeiIntro();
  }

  _obliterate(WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await ref.read(flutterSecureStorageProvider).deleteAll();
  }

  _authCheck(WidgetRef ref) async {
    await ref.read(userNotifierProvider.notifier).logout();
    await ref.read(authNotifierProvider.notifier).checkAndUpdateAuthStatus();
  }
}
