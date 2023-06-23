import 'dart:developer';

import 'package:face_net_authentication/application/absen/absen_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../infrastructure/absen/absen_repository.dart';

class AbsenNotifier extends StateNotifier<AbsenState> {
  AbsenNotifier(this._absenRepository) : super(AbsenState.empty());

  final AbsenRepository _absenRepository;

  void changeAbsen(AbsenState absen) {
    state = absen;
  }

  Future<void> getAbsen() async {
    final response = await _absenRepository.getAbsen();

    log('getAbsen() response $response');

    response.when(
        withNewData: ((data) => changeAbsen(data)),
        failure: (int? errorCode, String? message) =>
            changeAbsen(AbsenState.failure()));
  }
}
