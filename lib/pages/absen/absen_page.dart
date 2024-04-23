import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/providers.dart';

import '../widgets/copyright_text.dart';
import '../widgets/image_absen.dart';
import '../widgets/location_detail.dart';
import '../widgets/network_widget.dart';
import '../widgets/user_info.dart';
import 'absen_button.dart';

// CLASS
// MLService _mlService = locator<MLService>();
// FaceDetectorService _mlKitService = locator<FaceDetectorService>();
// CameraService _cameraService = locator<CameraService>();
// bool loading = false;

// _initializeServices() async {
//   if (_cameraService.cameraController == null) {
//     try {
//       setState(() => loading = true);
//       await _cameraService.initialize(context);
//       await _mlService.initialize(context);
//       _mlKitService.initialize();
//       setState(() => loading = false);
//     } catch (_) {
//       AlertHelper.showSnackBar(context,
//           message: 'Kamera tidak bisa digunakan.');
//       context.pop();
//     }
//   }
// }

// INIT STATE
// _initializeServices();

// WIDGET
// actions: <Widget>[
//   Padding(
//     padding: EdgeInsets.only(right: 20, top: 20),
//     child: PopupMenuButton<String>(
//       child: Icon(
//         Icons.more_vert,
//         color: Colors.black,
//       ),
//       onSelected: (value) {
//         switch (value) {
//           case 'Clear DB':
//             DatabaseHelper _dataBaseHelper =
//                 DatabaseHelper.instance;
//             _dataBaseHelper.deleteAll();
//             break;
//         }
//       },
//       itemBuilder: (BuildContext context) {
//         return {'Clear DB'}.map((String choice) {
//           return PopupMenuItem<String>(
//             value: choice,
//             child: Text(choice),
//           );
//         }).toList();
//       },
//     ),
//   ),
// ],

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
      await ref.read(testerNotifierProvider).maybeWhen(
          forcedRegularUser: () {},
          orElse: () => ref
              .read(testerNotifierProvider.notifier)
              .checkAndUpdateTesterState());

      final testerState = ref.read(testerNotifierProvider);

      await testerState.maybeWhen(
          tester: () {},
          orElse: () async {
            final imeiNotifier = ref.read(imeiNotifierProvider.notifier);

            String imei = await imeiNotifier.getImeiString();
            await Future.delayed(
                Duration(seconds: 1), () => imeiNotifier.changeSavedImei(imei));
            await ref
                .read(backgroundNotifierProvider.notifier)
                .getSavedLocations();
            await ref.read(geofenceProvider.notifier).getGeofenceList();
            await ref.read(absenNotifierProvidier.notifier).getAbsenToday();
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTester = ref.watch(testerNotifierProvider);
    final displayImage = ref.watch(displayImageProvider);
    final isOfflineMode = ref.watch(absenOfflineModeProvider);
    final mockLocation = ref.watch(mockLocationNotifierProvider);

    final user =
        ref.watch(userNotifierProvider.select((value) => value.user.nama));

    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              toolbarHeight: 45,
              actions: [
                NetworkWidget(),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                    height: displayImage == false
                        ? MediaQuery.of(context).size.height + 200
                        : MediaQuery.of(context).size.height + 475,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(children: [
                      ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          SizedBox(
                              height: 200,
                              child:
                                  Image(image: AssetImage('assets/logo.png'))),
                          SizedBox(
                            height: 24,
                          ),
                          UserInfo(
                            title:
                                'User ${isOfflineMode ? '(Mode Offline)' : ''}',
                            user: user ?? '',
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          ...isTester.maybeWhen(
                            tester: () => [AbsenButton()],
                            orElse: () => mockLocation.maybeWhen(
                              mocked: () => [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      'Anda diduga mengunakan Fake GPS. Harap matikan Fake GPS agar bisa menggunakan aplikasi.'),
                                )
                              ],
                              original: () => [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: LocationDetail(),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                AbsenButton(),
                              ],
                              orElse: () => [
                                Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CopyrightAgung(),
                        ),
                      )
                    ])),
              ),
            )),
      ],
    );
  }
}
