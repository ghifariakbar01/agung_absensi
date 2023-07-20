import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/domain/auth_failure.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/user_failure.dart';
import '../../domain/value_objects_copy.dart';
import '../../infrastructure/auth_repository.dart';
import 'user_model.dart';
import 'user_state.dart';

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier(this._repository) : super(UserState.initial());

  final AuthRepository _repository;

  Future<void> getUser() async {
    Either<UserFailure, String?> failureOrSuccess;

    state = state.copyWith(isGetting: true, failureOrSuccessOption: none());

    failureOrSuccess = await _repository.getSignedInCredentials();

    state = state.copyWith(
        isGetting: false, failureOrSuccessOption: optionOf(failureOrSuccess));
  }

  Future<void> saveUserAfterUpdate({
    required IdKaryawan idKaryawan,
    required UserId userId,
    required Password password,
  }) async {
    Either<AuthFailure, Unit?> failureOrSuccess;

    state =
        state.copyWith(isGetting: true, failureOrSuccessOptionUpdate: none());

    failureOrSuccess = await _repository.saveUserAfterUpdate(
        idKaryawan: idKaryawan, password: password, userId: userId);

    state = state.copyWith(
        isGetting: false,
        failureOrSuccessOptionUpdate: optionOf(failureOrSuccess));
  }

  Either<UserFailure, UserModelWithPassword> parseUser(String? user) {
    try {
      return right(UserModelWithPassword.fromJson(jsonDecode(user ?? '')));
    } on FormatException {
      return left(UserFailure.errorParsing('Error while parse'));
    }
  }

  void setUser(UserModelWithPassword user) {
    log('user ${user.noTelp1}');
    state = state.copyWith(user: user);
  }

  void onUserParsed({
    required UserModelWithPassword user,
    required Function checkAndUpdateStatus,
    required Function checkAndUpdateImei,
  }) {
    setUser(user);
    checkAndUpdateStatus();
    checkAndUpdateImei();
  }

  Future<void> logout(UserModelWithPassword user) async {
    final logout = await _repository.clearCredentialsStorage();

    logout.fold((_) => log('error logging out'), (_) => setUser(user));
  }
}
