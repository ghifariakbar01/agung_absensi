import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/user_failure.dart';
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

  Either<UserFailure, UserModel> parseUser(String? user) {
    try {
      return right(UserModel.fromJson(jsonDecode(user ?? '')));
    } on FormatException {
      return left(UserFailure.errorParsing('Error while parse'));
    }
  }

  void setUser(UserModel user) {
    state = state.copyWith(user: user);
  }

  Future<void> logout(UserModel user) async {
    final logout = await _repository.clearCredentialsStorage();

    logout.fold((_) => log('error logging out'), (_) => setUser(user));
  }
}
