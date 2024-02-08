import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/domain/auth_failure.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/infrastructure/auth_repository.dart';
import '../../domain/user_failure.dart';
import '../../domain/value_objects_copy.dart';

import 'user_model.dart';
import 'user_state.dart';

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier(
    this._repository,
  ) : super(UserState.initial());

  final AuthRepository _repository;

  Future<String> getUserString() => _repository.getUserString();

  Future<bool> getIsTester() async {
    // debugger();
    String userString = await getUserString();

    // PARSE USER SUCCESS / FAILURE
    if (userString.isNotEmpty) {
      final json = jsonDecode(userString) as Map<String, Object?>;
      final user = UserModelWithPassword.fromJson(json);

      if (user.nama != null) {
        return user.nama == 'Ghifar';
      }
    }

    return false;
  }

  Future<void> getUser() async {
    Either<UserFailure, String?> failureOrSuccess;

    state = state.copyWith(isGetting: true, failureOrSuccessOption: none());

    failureOrSuccess = await _repository.getSignedInCredentials();

    state = state.copyWith(
        isGetting: false, failureOrSuccessOption: optionOf(failureOrSuccess));
  }

  Future<void> saveUserAfterUpdate(
      {required UserModelWithPassword user}) async {
    Either<AuthFailure, Unit?> failureOrSuccess;

    final userId = UserId(user.nama ?? '');
    final server = PTName(user.ptServer ?? '');
    final password = Password(user.password ?? '');

    state =
        state.copyWith(isGetting: true, failureOrSuccessOptionUpdate: none());

    failureOrSuccess = await _repository.saveUserAfterUpdate(
        password: password, userId: userId, server: server);

    state = state.copyWith(
        isGetting: false,
        failureOrSuccessOptionUpdate: optionOf(failureOrSuccess));
  }

  setUser(UserModelWithPassword user) {
    // debugger();
    state = state.copyWith(user: user);
  }

  setUserInitial() {
    state = UserState.initial();
  }

  Future<void> onUserParsed({
    required Function initializeUser,
    required Function initializeDioRequest,
  }) async {
    await initializeUser();
    await initializeDioRequest();
  }

  Future<void> onUserParsedRaw(
          {required Ref ref,
          required UserModelWithPassword userModelWithPassword}) =>
      onUserParsed(
        initializeUser: () => Future.delayed(
            Duration(seconds: 2), () => setUser(userModelWithPassword)),
        initializeDioRequest: () => Future.delayed(
          Duration(seconds: 1),
          () => ref.read(dioRequestProvider).addAll({
            "username": "${userModelWithPassword.nama}",
            "server": "${userModelWithPassword.ptServer}",
            "password": "${userModelWithPassword.password}",
          }),
        ),
      );

  Future<void> logout() async {
    Either<AuthFailure, Unit> failureOrSuccessOption;

    failureOrSuccessOption = await _repository.clearCredentialsStorage();

    state = state.copyWith(
        failureOrSuccessOptionUpdate: optionOf(failureOrSuccessOption));
  }
}
