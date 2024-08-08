import 'dart:io';

import 'package:face_net_authentication/ios_user_maintanance/ios_user_maintanance_notifier.dart';
import 'package:face_net_authentication/widgets/v_async_widget.dart';
import 'package:face_net_authentication/widgets/v_dialogs.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../imei/application/imei_notifier.dart';
import '../../style/style.dart';
import '../../widgets/v_button.dart';
import 'profile_view.dart';

class ProfileScaffold extends HookConsumerWidget {
  const ProfileScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProvider = ref.watch(userNotifierProvider);
    final user = userProvider.user;

    final scrollController = useScrollController();
    final iosUserMaintanance = ref.watch(iosUserMaintananceProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: null,
        leadingWidth: 20,
        centerTitle: false,
        title: InkWell(
          onTap: () => scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
          ),
          child: Text(
            'Profile & Unlink',
            style: Themes.customColor(
              25,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          controller: scrollController,
          children: [
            const ProfileView(),
            VAsyncValueWidget<String>(
                value: iosUserMaintanance,
                data: (iosUser) {
                  if (user.nama == iosUser) {
                    return VButton(
                        label: 'Button Maintanance $iosUser',
                        color: Palette.blueLink,
                        onPressed: () async {
                          return ref
                              .read(imeiNotifierProvider.notifier)
                              .logClearImeiFromDB(
                                imei: user.imeiHp ?? '-',
                                idUser: user.idUser.toString(),
                                nama: user.nama!.isEmpty
                                    ? ''
                                    : '${user.nama} Button Maintanance $iosUser ',
                              );
                        });
                  } else {
                    return Container();
                  }
                }),
            VButton(
                label: 'UNLINK HP',
                color: Palette.red,
                onPressed: () => showDialog(
                    context: context,
                    builder: (_) => Platform.isIOS && user.nama != 'Ghifar'
                        ? VAlertDialog(
                            label: 'Unlink HP & Uninstall ?',
                            labelDescription:
                                'Mohon Dibaca: Setelah Hapus Installation ID\n & Uninstall Akun Anda tidak akan bisa menggunakan device ini kembali.',
                            onPressed: () async {
                              context.pop();

                              await ref
                                  .read(imeiNotifierProvider.notifier)
                                  .logClearImeiFromDB(
                                    nama: user.nama ?? '',
                                    idUser: user.idUser.toString(),
                                    imei: user.imeiHp ?? '',
                                  );
                            })
                        : VAlertDialog(
                            label: 'Unlink HP & Uninstall ?',
                            labelDescription:
                                'Hapus Installation ID\n & Logout',
                            onPressed: () async {
                              context.pop();

                              await ref
                                  .read(imeiNotifierProvider.notifier)
                                  .logClearImeiFromDB(
                                    nama: user.nama ?? '',
                                    idUser: user.idUser.toString(),
                                    imei: user.imeiHp ?? '',
                                  );
                            })))
          ],
        ),
      ),
    );
  }
}
