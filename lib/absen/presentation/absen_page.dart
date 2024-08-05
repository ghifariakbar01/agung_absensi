// ignore_for_file: unused_result

import 'package:face_net_authentication/riwayat_absen/application/riwayat_absen_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/constants.dart';
import '../../network_time/network_time_notifier.dart';
import '../../shared/providers.dart';
import '../../style/style.dart';
import '../../widgets/image_absen.dart';
import '../../widgets/network_widget.dart';
import '../../widgets/testing.dart';
import '../../widgets/user_info.dart';
import 'absen_error_and_button.dart';
import "package:face_net_authentication/copyright/presentation/copyright_item.dart";

class AbsenPage extends ConsumerStatefulWidget {
  AbsenPage({Key? key}) : super(key: key);
  @override
  _AbsenPageState createState() => _AbsenPageState();
}

class _AbsenPageState extends ConsumerState<AbsenPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _recheckTesterState();
      await _initializeGeofenceImeiAndAbsen();
    });
  }

  Future<void> _recheckTesterState() async {
    await ref.read(testerNotifierProvider).maybeWhen(
        forcedRegularUser: () {},
        orElse: () => ref
            .read(testerNotifierProvider.notifier)
            .checkAndUpdateTesterState());
  }

  Future<void> _initializeGeofenceImeiAndAbsen() async {
    ref.read(riwayatAbsenNotifierProvider.notifier).reset();
    ref.read(riwayatAbsenNotifierProvider.notifier).reset();

    await ref.refresh(networkTimeNotifierProvider);

    await ref.read(testerNotifierProvider).maybeWhen(
      tester: () async {
        await _initializeImei();
      },
      orElse: () async {
        await _initializeImei();

        await ref.read(backgroundNotifierProvider.notifier).getSavedLocations();
        await ref.read(absenNotifierProvidier.notifier).getAbsenToday();
      },
    );
  }

  Future<void> _initializeImei() async {
    final imeiNotifier = ref.read(imeiNotifierProvider.notifier);
    final imei = await imeiNotifier.getImeiString();

    await Future.delayed(
      Duration(seconds: 1),
      () => imeiNotifier.changeSavedImei(imei),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayImage = ref.watch(displayImageProvider);
    final isOfflineMode = ref.watch(absenOfflineModeProvider);

    final riwayatLoading = ref.watch(
      riwayatAbsenNotifierProvider.select((value) => value.isGetting),
    );

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          toolbarHeight: 45,
          actions: [
            NetworkWidget(),
            SizedBox(
              width: 24,
            )
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
                height: displayImage == false || isOfflineMode
                    ? MediaQuery.of(context).size.height + 200
                    : MediaQuery.of(context).size.height + 475,
                child: Stack(
                  children: [
                    if (!isOfflineMode && riwayatLoading) ...[
                      Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      )
                    ] else ...[
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
                    ]
                  ],
                )),
          ),
        ));
  }
}
