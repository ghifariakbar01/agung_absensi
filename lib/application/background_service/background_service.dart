// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';

// import 'package:dartz/dartz.dart';
// import 'package:face_net_authentication/background_service/saved_location_model.dart/saved_location.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:geofence_service/geofence_service.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:workmanager/workmanager.dart';

// @pragma(
//     'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
// Future<bool> callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     late SavedLocation locations;

//     // Saved to save
//     //  {
//     // "data": [
//     //     {
//     //         "date": "DateTime.now()",
//     //         "out": true,
//     //         "in": false
//     //     },
//     //     {
//     //         "date": "DateTime.now()",
//     //         "out": true,
//     //         "in": false
//     //     },
//     //     {
//     //         "date": "DateTime.now()",
//     //         "out": false,
//     //         "in": true
//     //     }
//     //   ]
//     // }

//     // Dummy initial data
//     // SavedLocation(data: [
//     //   Saved(id: 404, date: "INITIAL_DATE", outAbsen: false, inAbsen: false)
//     // ]);

//     // Initialize shared preferences
//     final FlutterSecureStorage _storage = FlutterSecureStorage();

//     const _key = 'savedlocation';

//     // 1. Check if data exist
//     final data = await _storage.read(key: _key);

//     // 2. If data exist, put it --> locations, else init locations
//     if (data != null) {
//       try {
//         locations = SavedLocation.fromJson(jsonDecode(data));
//       } catch (e) {
//         Println('Error parsing SavedLocation ' + e.toString());
//       }
//     } else {
//       locations = SavedLocation(
//           data: [Saved(date: "INITIAL_DATE", outAbsen: false, inAbsen: false)]);
//     }

//     // Initialize geofence

//     // //  3. Make geonce list
//     // List<Geofence> _geofenceList = [
//     //   // Create a [Geofence] list.
//     //   Geofence(
//     //     id: 'stasiun_gondangdia',
//     //     latitude: -6.192780,
//     //     longitude: 106.831146,
//     //     data: 'Stasiun Gondangdia',
//     //     radius: [
//     //       GeofenceRadius(id: 'radius_100m', length: 100),
//     //     ],
//     //   ),

//     //   // Create a [Geofence] list.
//     //   Geofence(
//     //     id: 'ptun_jakarta',
//     //     latitude: -6.1960781,
//     //     longitude: 106.8395862,
//     //     data: 'PTUN Jakarta Halte',
//     //     radius: [
//     //       GeofenceRadius(id: 'radius_100m', length: 100),
//     //     ],
//     //   ),

//     //   // Create a [Geofence] list.
//     //   Geofence(
//     //     id: 'stasiun_manggarai',
//     //     latitude: -6.2077213,
//     //     longitude: 106.8485659,
//     //     data: 'Stasiun Manggarai',
//     //     radius: [
//     //       GeofenceRadius(id: 'radius_100m', length: 100),
//     //     ],
//     //   ),
//     // ];

//     // // 4.
//     // final _geofenceService = GeofenceService.instance.setup(
//     //     interval: 5000,
//     //     accuracy: 100,
//     //     loiteringDelayMs: 60000,
//     //     statusChangeDelayMs: 10000,
//     //     useActivityRecognition: false,
//     //     allowMockLocations: false,
//     //     printDevLog: false,
//     //     geofenceRadiusSortType: GeofenceRadiusSortType.DESC);

//     // This function is used to handle errors that occur in the service.
//     // void _onError(error) {
//     //   final errorCode = getErrorCodesFromError(error);
//     //   if (errorCode == null) {
//     //     print('Undefined error: $error');
//     //     return;
//     //   }

//     //   print('ErrorCode: $errorCode');
//     // }

//     // ============= FOR FINDING NEAREST DISTANCE =============
//     // fillRemainingDistance returns double with
//     // list of remaining distance

//     // findNearestIndex(List<double> remainingDistance) gets list
//     // from fillRemainingDistance and find the smallest distance

//     // changeNearestIndex initializee nearestIndex
//     // int? nearestIndex;

//     // List<double> fillRemainingDistance() {
//     //   final List<double> remaningDistance = [];

//     //   _geofenceList.forEach(
//     //       (geofence) => remaningDistance.add(geofence.remainingDistance ?? 0));

//     //   return remaningDistance;
//     // }

//     // double findNearest(List<double> remainingDistance) {
//     //   return remainingDistance.reduce(min);
//     // }

//     // int findNearestIndex(List<double> remainingDistance) {
//     //   return remainingDistance
//     //       .indexWhere((distance) => distance == findNearest(remainingDistance));
//     // }

//     // void changeNearestIndex(int index) {
//     //   nearestIndex = index;
//     // }

//     // // =================================================================

//     // Absen getAbsenType() {
//     //   final time = DateTime.now();

//     //   if (time.hour == 17 && time.minute == 00) {
//     //     return Absen.outAbsen;
//     //   }

//     //   if (time.hour == 08 && time.minute == 00) {
//     //     return Absen.inAbsen;
//     //   }

//     //   return Absen.undefined;
//     // }

//     // // after check distance, run function that has absen as param
//     // void checkDistance(Function(Absen absen) onDistance) {
//     //   changeNearestIndex(findNearestIndex(fillRemainingDistance()));

//     //   if (nearestIndex != null) {
//     //     final nearestPoint = _geofenceList[nearestIndex!];

//     //     if (nearestPoint.remainingDistance! < 100) {
//     //       onDistance(getAbsenType());
//     //     } else {
//     //       Println('Distance is more than 100 m. ${nearestPoint.data}');
//     //     }
//     //   }
//     // }

//     // bool isDateSame(Saved saved, DateTime now) {
//     //   return DateTime.parse(saved.date).day == now.day &&
//     //       DateTime.parse(saved.date).month == now.month &&
//     //       DateTime.parse(saved.date).year == now.year;
//     // }

//     // void currentTimeAbsent(Absen absen, Saved saved, Function() onAbsen) {
//     //   if (isDateSame(saved, DateTime.now())) {
//     //     if (saved.inAbsen == true && absen == Absen.inAbsen) {
//     //       return;
//     //     }

//     //     if (saved.outAbsen == true && absen == Absen.outAbsen) {
//     //       return;
//     //     }

//     //     onAbsen();
//     //   }
//     // }

//     // // to find location, if id is not empty
//     // Either<Unit, Saved> findAbsenByDate(SavedLocation locations, DateTime now) {
//     //   if (locations.data.isNotEmpty) {
//     //     return right(
//     //         locations.data.firstWhere((location) => isDateSame(location, now)));
//     //   }

//     //   return left(unit);
//     // }

//     // Either<Unit, Saved> changeAbsen(Absen absen, Saved saved) {
//     //   if (absen == Absen.inAbsen) {
//     //     saved.inAbsen = true;
//     //   }

//     //   if (absen == Absen.outAbsen) {
//     //     saved.outAbsen = true;
//     //   }

//     //   if (absen == Absen.undefined) {
//     //     return left(unit);
//     //   }

//     //   return right(saved);
//     // }

//     // Either<Unit, SavedLocation> updateAbsen(Saved saved) {
//     //   try {
//     //     final locationList = locations;

//     //     locationList.data
//     //         .removeWhere((location) => isDateSame(location, DateTime.now()));

//     //     locationList.data.add(saved);

//     //     return right(locationList);
//     //   } catch (_) {
//     //     return left(unit);
//     //   }
//     // }

//     // Either<Unit, SavedLocation> addAbsen(Saved saved) {
//     //   try {
//     //     final locationList = locations;

//     //     locationList.data.add(saved);

//     //     return right(locationList);
//     //   } catch (_) {
//     //     return left(unit);
//     //   }
//     // }

//     // void saveInStorage(SavedLocation _location) async {
//     //   final json = _location.toJson();

//     //   await _storage.write(key: _key, value: json.toString());
//     // }

//     // Saved initNewSavedLocation() {
//     //   return Saved(
//     //       date: DateTime.now().toString(), outAbsen: false, inAbsen: false);
//     // }

//     // void absen() async {
//     //   // first check if has distance, if doesn't return
//     //   // if has distance, check if has saved absen (by day, month, year), if not use intial data

//     //   // save that temp absen
//     //   // check if time is 17.00 or 08.00 and corresponding absen false

//     //   // if does, save location by adding to locations
//     //   // and saving json, to secure storage. using "savedlocation" as key

//     //   final newAbsen = initNewSavedLocation();

//     //   checkDistance((absen) {
//     //     findAbsenByDate(locations, DateTime.now()).fold(
//     //         (_) =>
//     //             // init new location
//     //             {
//     //               currentTimeAbsent(
//     //                   absen,
//     //                   newAbsen,
//     //                   // absen
//     //                   // locations => List<Saved
//     //                   () => changeAbsen(absen, newAbsen).fold(
//     //                       (_) => Println('Error absen undefined'),
//     //                       (changedAbsen) => addAbsen(changedAbsen).fold(
//     //                           (_) => Println('Error saat update absen'),
//     //                           (addedList) => saveInStorage(addedList))))
//     //             },
//     //         (savedData) => {
//     //               currentTimeAbsent(
//     //                   absen,
//     //                   savedData,
//     //                   // absen
//     //                   // locations => List<Saved
//     //                   () => changeAbsen(absen, savedData).fold(
//     //                       (_) => Println('Error absen undefined'),
//     //                       (changedAbsen) => updateAbsen(changedAbsen).fold(
//     //                           (_) => Println('Error saat update absen'),
//     //                           (updatedList) => saveInStorage(updatedList))))
//     //             });
//     //   });

//     //   const _key = 'savedlocation';

//     //   // 1. Check if data exist
//     //   final data = await _storage.read(key: _key);

//     //   Println("Storage is $data");
//     // }

//     // // This function is to be called when the location has changed.
//     // void _onLocationChanged(Location location) {
//     //   print('location: ${location.toJson()}');
//     //   // absen();
//     // }

//     // if (_geofenceService.isRunningService == false) {
//     //   _geofenceService.addLocationChangeListener(_onLocationChanged);
//     //   _geofenceService.addStreamErrorListener(_onError);
//     //   _geofenceService.start(_geofenceList).catchError(_onError);
//     // }

//     return Future.value(true);
//   });

//   return Future.value(true);
// }

// enum Absen { outAbsen, inAbsen, undefined }
