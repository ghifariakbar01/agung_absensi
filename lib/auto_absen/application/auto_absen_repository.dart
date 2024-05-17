import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/domain/auto_absen_failure.dart';
import 'package:face_net_authentication/infrastructures/credentials_storage/credentials_storage.dart';
import 'package:flutter/services.dart';

import '../../background/application/recent_absen_state.dart';

class AutoAbsenRepository {
  final CredentialsStorage credentialsStorage;

  AutoAbsenRepository(this.credentialsStorage);

  Future<void> saveRecentAbsen(String recentAbsen) async {
    debugger(message: 'called');

    await credentialsStorage.save(recentAbsen);
  }

  Future<void> addRecentAbsen(String recentAbsen) async {
    debugger(message: 'called');

    try {
      final recents = await credentialsStorage.read();

      log('recents $recents');

      if (recents != null) {
        final savedRecentAbsens =
            await parseRecentAbsen(savedLocations: recents);

        final currentRecentAbsens =
            parseRecentAbsentSingle(location: recentAbsen);

        final processRecentAbsen =
            [...savedRecentAbsens, currentRecentAbsens].toSet().toList();

        debugger(message: 'called');

        log('processRecentAbsen currentRecentAbsens savedRecentAbsens $processRecentAbsen $currentRecentAbsens $savedRecentAbsens');

        await saveRecentAbsen(jsonEncode(processRecentAbsen));
      } else {
        debugger(message: 'called');

        await saveRecentAbsen(recentAbsen);
      }
    } catch (e) {
      debugger(message: 'called');

      log('error $e');
    }
  }

  Future<Either<AutoAbsenFailure, List<RecentAbsenState>>>
      getRecentAbsen() async {
    try {
      // debugger(message: 'called');

      final recents = await credentialsStorage.read();

      if (recents != null) {
        final savedRecentAbsens =
            await parseRecentAbsen(savedLocations: recents);

        // debugger(message: 'called');

        log('savedRecentAbsens $savedRecentAbsens');

        return right(savedRecentAbsens);
      } else {
        // debugger(message: 'called');

        return right([]);
      }
    } on PlatformException {
      return left(AutoAbsenFailure.storage());
    }
  }

  Future<List<RecentAbsenState>> parseRecentAbsen(
      {required String? savedLocations}) async {
    final parsedData = jsonDecode(savedLocations!);

    log('parsedData $parsedData ');

    if (parsedData is Map<String, dynamic>) {
      final location = RecentAbsenState.fromJson(parsedData);

      final List<RecentAbsenState> empty = [];

      empty.add(location);

      return empty;
    } else {
      return (parsedData as List<dynamic>)
          .map((locationData) => RecentAbsenState.fromJson(locationData))
          .toList();
    }
  }

  RecentAbsenState parseRecentAbsentSingle({required String location}) {
    return RecentAbsenState.fromJson(jsonDecode(location));
  }
}
