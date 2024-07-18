import 'dart:convert';
import 'package:face_net_authentication/utils/logging.dart';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/domain/auto_absen_failure.dart';
import 'package:face_net_authentication/infrastructures/credentials_storage/credentials_storage.dart';
import 'package:flutter/services.dart';

import '../../background/application/recent_absen_state.dart';

class AutoAbsenRepository {
  final CredentialsStorage credentialsStorage;

  AutoAbsenRepository(this.credentialsStorage);

  Future<void> saveRecentAbsen(String recentAbsen) async {
    await credentialsStorage.save(recentAbsen);
  }

  Future<void> addRecentAbsen(String recentAbsen) async {
    try {
      final recents = await credentialsStorage.read();

      Log.info('recents $recents');

      if (recents != null) {
        final savedRecentAbsens =
            await parseRecentAbsen(savedLocations: recents);

        final currentRecentAbsens =
            parseRecentAbsentSingle(location: recentAbsen);

        final processRecentAbsen =
            [...savedRecentAbsens, currentRecentAbsens].toSet().toList();

        Log.info(
            'processRecentAbsen currentRecentAbsens savedRecentAbsens $processRecentAbsen $currentRecentAbsens $savedRecentAbsens');

        await saveRecentAbsen(jsonEncode(processRecentAbsen));
      } else {
        await saveRecentAbsen(recentAbsen);
      }
    } catch (e) {
      Log.info('error $e');
    }
  }

  Future<Either<AutoAbsenFailure, List<RecentAbsenState>>>
      getRecentAbsen() async {
    try {
      //

      final recents = await credentialsStorage.read();

      if (recents != null) {
        final savedRecentAbsens =
            await parseRecentAbsen(savedLocations: recents);

        //

        Log.info('savedRecentAbsens $savedRecentAbsens');

        return right(savedRecentAbsens);
      } else {
        //

        return right([]);
      }
    } on PlatformException {
      return left(AutoAbsenFailure.storage());
    }
  }

  Future<List<RecentAbsenState>> parseRecentAbsen(
      {required String? savedLocations}) async {
    final parsedData = jsonDecode(savedLocations!);

    Log.info('parsedData $parsedData ');

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
