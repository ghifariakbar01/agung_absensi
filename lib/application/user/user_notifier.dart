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
import '../reminder/reminder_provider.dart';
import 'user_model.dart';
import 'user_state.dart';

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier(
    this._repository,
  ) : super(UserState.initial());

  final AuthRepository _repository;

  Future<String> getUserString() => _repository.getUserString();

  Future<void> getUser() async {
    Either<UserFailure, String?> failureOrSuccess;

    state = state.copyWith(isGetting: true, failureOrSuccessOption: none());

    failureOrSuccess = await _repository.getSignedInCredentials();

    state = state.copyWith(
        isGetting: false, failureOrSuccessOption: optionOf(failureOrSuccess));
  }

  Future<void> saveUserAfterUpdate(
      {required IdKaryawan idKaryawan,
      required UserId userId,
      required Password password,
      required PTName server}) async {
    Either<AuthFailure, Unit?> failureOrSuccess;

    state =
        state.copyWith(isGetting: true, failureOrSuccessOptionUpdate: none());

    failureOrSuccess = await _repository.saveUserAfterUpdate(
        idKaryawan: idKaryawan,
        password: password,
        userId: userId,
        server: server);

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

  setUser(UserModelWithPassword user) {
    debugger();
    state = state.copyWith(user: user);
  }

  Future<void> onUserParsed({
    required Function initializeUser,
    required Function initializeDioRequest,
    required Function checkReminderStatus,
    required Function checkAndUpdateStatus,
    required Function checkAndUpdateImei,
  }) async {
    await initializeUser();
    await initializeDioRequest();
    await checkReminderStatus();
    await checkAndUpdateStatus();
    await checkAndUpdateImei();
  }

  Future<void> onUserParsedRaw(
      {required WidgetRef ref,
      required UserModelWithPassword userModelWithPassword}) async {
    await onUserParsed(
        initializeUser: () async => await setUser(userModelWithPassword),
        initializeDioRequest: () {
          ref.read(dioRequestProvider).addAll({
            "kode": "${StringUtils.formatDate(DateTime.now())}",
            "username": "${userModelWithPassword.nama}",
            "password": "${userModelWithPassword.password}",
            "server": "${userModelWithPassword.ptServer}"
          });
        },
        checkReminderStatus: () async {
          if (userModelWithPassword.passwordUpdate!.isNotEmpty) {
            await Future.delayed(Duration(seconds: 1));
            DateTime passwordUpdate = ref
                .read(reminderNotifierProvider.notifier)
                .convertToDateTime(
                    passUpdate: userModelWithPassword.passwordUpdate ?? '');
            int daysLeft = ref
                .read(reminderNotifierProvider.notifier)
                .getDaysLeft(
                    passUpdate: DateTime(passwordUpdate.year,
                        passwordUpdate.month + 1, passwordUpdate.day));

            ref
                .read(reminderNotifierProvider.notifier)
                .changeDaysLeft(daysLeft);
          }
        },
        checkAndUpdateStatus: () async => await ref
            .read(authNotifierProvider.notifier)
            .checkAndUpdateAuthStatus(),
        checkAndUpdateImei: () async =>
            await ref.read(imeiNotifierProvider.notifier).checkAndUpdateImei());
  }

  Future<void> logout() async {
    Either<AuthFailure, Unit> failureOrSuccessOption;

    failureOrSuccessOption = await _repository.clearCredentialsStorage();

    state = state.copyWith(
        failureOrSuccessOptionUpdate: optionOf(failureOrSuccessOption));
  }

  setUserInitial() {
    state = UserState.initial();
  }

  resetUserImei() {
    state = state.copyWith(user: state.user.copyWith(imeiHp: ''));
  }
}
