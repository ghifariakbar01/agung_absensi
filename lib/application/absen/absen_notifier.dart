import 'dart:developer';

import 'package:face_net_authentication/application/absen/absen_state.dart';
import 'package:face_net_authentication/infrastructure/remote_response.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../infrastructure/absen/absen_repository.dart';

class AbsenNotifier extends StateNotifier<AbsenState> {
  AbsenNotifier(this._absenRepository) : super(AbsenState.empty());

  final AbsenRepository _absenRepository;

  void changeAbsen(AbsenState absen) {
    state = absen;
  }

  Future<void> getAbsen({
    required DateTime date,
    required Function(AbsenState absen) onAbsen,
    required Function() onNoConnection,
  }) async {
    final response = await _absenRepository.getAbsen(date: date);

    response.when(
        withNewData: ((data) => onAbsen(data)),
        failure: (int? errorCode, String? message) =>
            errorCode == 500 ? onNoConnection() : null);
  }

  Future<void> getAbsenSaved(
      {required DateTime date,
      Function(RemoteResponse<AbsenState>)? onAbsen}) async {
    final response = await _absenRepository.getAbsen(date: date);

    if (onAbsen != null) await onAbsen(response);
  }
}
