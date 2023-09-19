import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/domain/auth_failure.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/user_failure.dart';
import '../../domain/value_objects_copy.dart';

import '../../infrastructure/auth/auth_repository.dart';
import '../../utils/string_utils.dart';
import 'user_model.dart';
import 'user_state.dart';

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier(
    this._repository,
  ) : super(UserState.initial());

  final AuthRepository _repository;

  Future<String> getUserString() => _repository.getUserString();

  Future<void> getUser() async {
    debugger();

    Either<UserFailure, String?> failureOrSuccess;

    state = state.copyWith(isGetting: true, failureOrSuccessOption: none());

    failureOrSuccess = await _repository.getSignedInCredentials();

    state = state.copyWith(
        isGetting: false, failureOrSuccessOption: optionOf(failureOrSuccess));
  }

  Future<void> saveUserAfterUpdate(
      {required UserModelWithPassword user}) async {
    Either<AuthFailure, Unit?> failureOrSuccess;

    final idKaryawan = IdKaryawan(user.idKary ?? '');
    final userId = UserId(user.nama ?? '');
    final password = Password(user.password ?? '');
    final server = PTName(user.ptServer);

    state =
        state.copyWith(isGetting: true, failureOrSuccessOptionUpdate: none());
    debugger();
    failureOrSuccess = await _repository.saveUserAfterUpdate(
        idKaryawan: idKaryawan,
        password: password,
        userId: userId,
        server: server);

    debugger();

    state = state.copyWith(
        isGetting: false,
        failureOrSuccessOptionUpdate: optionOf(failureOrSuccess));
  }

  Either<UserFailure, UserModelWithPassword> parseUser(String? user) {
    try {
      if (user != null) {
        Map<String, Object?> userJson = jsonDecode(user);

        if (userJson.isNotEmpty) {
          return right(UserModelWithPassword.fromJson(userJson));
        }
      }
      return left(UserFailure.errorParsing('userJson is Empty'));
    } on FormatException catch (e) {
      return left(UserFailure.errorParsing('$e'));
    }
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
    required Function checkAndUpdateImei,
  }) async {
    await initializeUser();
    await initializeDioRequest();
    await checkAndUpdateImei();
  }

  Future<void> onUserParsedRaw(
      {required Ref ref,
      required UserModelWithPassword userModelWithPassword}) async {
    await onUserParsed(
        initializeUser: () => Future.delayed(
            Duration(seconds: 1), () => setUser(userModelWithPassword)),
        initializeDioRequest: () => Future.delayed(
              Duration(seconds: 1),
              () => ref.read(dioRequestProvider).addAll({
                "kode": "${StringUtils.formatDate(DateTime.now())}",
                "username": "${userModelWithPassword.nama}",
                "password": "${userModelWithPassword.password}",
                "server": "${userModelWithPassword.ptServer}"
              }),
            ),
        checkAndUpdateImei: () =>
            ref.read(imeiAuthNotifierProvider.notifier).checkAndUpdateImei());
  }

  Future<void> logout() async {
    Either<AuthFailure, Unit> failureOrSuccessOption;

    failureOrSuccessOption = await _repository.clearCredentialsStorage();

    state = state.copyWith(
        failureOrSuccessOptionUpdate: optionOf(failureOrSuccessOption));
  }
}
