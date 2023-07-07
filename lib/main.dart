import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'application/background_service/background_service.dart';
import 'application/background_service/saved_location.dart';
import 'config/configuration.dart';
import 'shared/providers.dart';
import 'utils/geofence_utils.dart';

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // String? locations;
      final _sharedPreference =
          await SharedPreferences.getInstance(); //Initialize dependency

      if (inputData != null) {
        switch (_sharedPreference.getString("locations") != null) {
          case true:
            final savedLocations = await parseLocation(
                savedLocations: _sharedPreference.getString("locations"));

            final currentLocations =
                parseSavedLocation(location: inputData["locations"]);

            final processLocation =
                [...savedLocations, currentLocations].toSet().toList();

            await _sharedPreference.setString(
                "locations", jsonEncode(processLocation));

            // log('savedLocations ${savedLocations}');
            // log('currentLocations ${currentLocations}');

            break;
          case false:
            await _sharedPreference.setString(
                "locations", inputData['locations']);

            // debugger(message: 'called');
            // log('inputData[locations] type ${inputData['locations'].runtimeType} ');
            // log('inputData[locations] ${inputData['locations']} ');
            // log('_sharedPreference.getString("locations") ${_sharedPreference.getString("locations")}');
            break;
        }
      }
    } catch (err) {
      log('error background' +
          err.toString()); // Logger flutter package, prints error on the debug console
      throw Exception(err);
    }

    return Future.value(true);
  });
}

Future<List<SavedLocation>> parseLocation(
    {required String? savedLocations}) async {
  final parsedData = jsonDecode(savedLocations!);

  // log('parsedData $parsedData ');

  if (parsedData is Map<String, dynamic>) {
    final location = SavedLocation.fromJson(parsedData);

    final List<SavedLocation> empty = [];

    empty.add(location);

    return empty;
  } else {
    return (parsedData as List<dynamic>)
        .map((locationData) => SavedLocation.fromJson(locationData))
        .toList();
  }
}

SavedLocation parseSavedLocation({required String location}) {
  return SavedLocation.fromJson(jsonDecode(location));
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Themes.initUiOverlayStyle();

  BuildConfig.init(flavor: const String.fromEnvironment('flavor'));

  setupServices();

  await initializeBackgroundLocation();

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  final location = await Geolocator.getCurrentPosition();

  final latitude = location.latitude;
  final longitude = location.longitude;

  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );

  Placemark? lokasi = await getAddressFromCoordinates(latitude, longitude);

  final locations = jsonEncode(SavedLocation(
      latitude: latitude,
      longitude: longitude,
      alamat:
          '${lokasi?.street}, ${lokasi?.subAdministrativeArea}, ${lokasi?.postalCode}.',
      date: DateTime.now()));

  Workmanager().registerOneOffTask(
    "task-identifier",
    "simpleTask",
    inputData: <String, dynamic>{
      "locations": locations,
    },
  );

  runApp(ProviderScope(child: MyApp()));
}

final initializationProvider = FutureProvider<Unit>((ref) async {
  // await ref.read(hiveProvider).init();
  ref.read(dioProvider)
    ..options = BaseOptions(
      connectTimeout: BuildConfig.get().connectTimeout,
      receiveTimeout: BuildConfig.get().receiveTimeout,
      validateStatus: (status) {
        return true;
      },
      baseUrl: BuildConfig.get().baseUrl,
    );
  // ..interceptors.add(ref.read(authInterceptorProvider));

  if (!BuildConfig.isProduction) {
    ref.read(dioProvider).interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
        ));
  }

  final authNotifier = ref.read(authNotifierProvider.notifier);
  await authNotifier.checkAndUpdateAuthStatus();

  return unit;
});

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(initializationProvider, (_, __) {});

    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
