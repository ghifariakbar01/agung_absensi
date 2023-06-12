import 'package:face_net_authentication/application/providers/geofence_provider.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/pages/absen/widgets/user_info.dart';
import 'package:face_net_authentication/pages/db/databse_helper.dart';

import 'package:face_net_authentication/services/camera.service.dart';
import 'package:face_net_authentication/services/ml_service.dart';
import 'package:face_net_authentication/services/face_detector_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../core/presentation/widgets/alert_helper.dart';
import '../style/style.dart';
import 'home/widget/home_body.dart';
import 'widgets/location_detail.dart';

class MyHomePage extends ConsumerStatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  MLService _mlService = locator<MLService>();
  FaceDetectorService _mlKitService = locator<FaceDetectorService>();
  CameraService _cameraService = locator<CameraService>();

  bool loading = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  _initializeServices() async {
    if (_cameraService.cameraController == null) {
      try {
        setState(() => loading = true);
        await _cameraService.initialize(context);
        await _mlService.initialize(context);
        _mlKitService.initialize();
        setState(() => loading = false);
      } catch (_) {
        AlertHelper.showSnackBar(context,
            message: 'Kamera tidak bisa digunakan.');
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: Container(),
            elevation: 0,
            backgroundColor: Colors.transparent,
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20, top: 20),
                child: PopupMenuButton<String>(
                  child: Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'Clear DB':
                        DatabaseHelper _dataBaseHelper =
                            DatabaseHelper.instance;
                        _dataBaseHelper.deleteAll();
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return {'Clear DB'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ),
            ],
          ),
          body: !loading
              ? SingleChildScrollView(
                  child: SafeArea(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image(image: AssetImage('assets/logo.png')),
                          SizedBox(
                            height: 24,
                          ),
                          UserInfo(title: 'User'),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: LocationDetail(),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          HomeBody(),
                        ],
                      ),
                    ),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
        Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: !loading
                ? Center(
                    child: TextButton(
                    onPressed: () => context.pop(),
                    child: Text(
                      'ganti akun',
                      style: Themes.blackItalic(),
                    ),
                  ))
                : Container()),
      ],
    );
  }
}
