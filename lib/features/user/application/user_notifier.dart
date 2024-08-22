import 'dart:convert';
import 'package:face_net_authentication/utils/logging.dart';

import 'package:dartz/dartz.dart';

import 'package:face_net_authentication/shared/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/infrastructures/auth_repository.dart';
import '../../domain/auth_failure.dart';
import '../../domain/user_failure.dart';
import '../../domain/value_objects_copy.dart';

import 'user_model.dart';
import 'user_state.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_notifier.g.dart';

@riverpod
class UserHasStaff extends _$UserHasStaff {
  @override
  FutureOr<bool> build() async {
    final _staff = ref.watch(userNotifierProvider).user.staf;
    final _fullAkses = ref.watch(userNotifierProvider).user.fullAkses;

    bool fullAkses = false;
    bool staff = false;

    if (_fullAkses == null) {
      //
    } else {
      fullAkses = _fullAkses;
    }

    if (_staff == null) {
      return fullAkses;
    }

    final _list = _staff
        .split(',')
        .map((e) => e.trim())
        .where((element) => element.isNotEmpty)
        .toList();

    if (_list.length == 1 || _list.isEmpty) {
      staff = false;
    } else {
      staff = true;
    }
    Log.info("fullAkses $fullAkses staff $staff");

    return fullAkses || staff;
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier(
    this._repository,
  ) : super(UserState.initial());

  final AuthRepository _repository;

  Future<UserModelWithPassword> getUserString() async {
    final resp = await _repository.getUserString();
    final json = jsonDecode(resp) as Map<String, dynamic>;

    return UserModelWithPassword.fromJson(json);
  }

  Future<bool> getIsTester() async {
    final userString = await _repository.getUserString();

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

    state = state.copyWith(
      isGetting: true,
      failureOrSuccessOption: none(),
    );

    failureOrSuccess = await _repository.getSignedInCredentials();

    state = state.copyWith(
      isGetting: false,
      failureOrSuccessOption: optionOf(failureOrSuccess),
    );
  }

  Future<void> saveUserAfterUpdate(
      {required UserModelWithPassword user}) async {
    Either<AuthFailure, Unit?> failureOrSuccess;

    final userId = UserId(user.nama ?? '');
    final server = PTName(user.ptServer ?? '');
    final password = Password(user.password ?? '');

    state = state.copyWith(
      isGetting: true,
      failureOrSuccessOptionUpdate: none(),
    );

    failureOrSuccess = await _repository.saveUserAfterUpdate(
      password: password,
      userId: userId,
      server: server,
    );

    state = state.copyWith(
      isGetting: false,
      failureOrSuccessOptionUpdate: optionOf(failureOrSuccess),
    );
  }

  Future<Either<AuthFailure, Unit?>> saveUserAfterUpdateInline({
    required UserModelWithPassword user,
  }) async {
    Either<AuthFailure, Unit?> resp;

    if (user.password == null || user.nama == null || user.ptServer == null) {
      return left(const AuthFailure.server(
        404,
        'Tidak dapat melakukan query saveUserAfterUpdateInline, password / nama / ptserver null',
      ));
    }

    resp = await _repository.saveUserAfterUpdate(
      userId: UserId(user.nama!),
      password: Password(user.password!),
      server: PTName(user.ptServer!),
    );

    return resp;
  }

  setUser(UserModelWithPassword user) {
    state = state.copyWith(user: user);
    state = state.copyWith(user: user);
    state = state.copyWith(user: user);
  }

  setUserInitial() {
    state = UserState.initial();
  }

  Future<void> _onUserParsed({
    required Function initializeUser,
    required Function initializeDioRequest,
  }) async {
    await initializeUser();
    await initializeDioRequest();
  }

  Future<void> onUserParsedRaw({
    required Ref ref,
    required UserModelWithPassword user,
  }) async {
    return _onUserParsed(
      initializeUser: () => Future.delayed(
        Duration(seconds: 1),
        () => setUser(user),
      ),
      initializeDioRequest: () => Future.delayed(
        Duration(seconds: 1),
        () => ref.read(dioRequestProvider).addAll({
          "username": "${user.nama}",
          "password": "${user.password}",
          "server": "${user.ptServer}",
        }),
      ),
    );
  }

  Future<void> logout() async {
    Either<AuthFailure, Unit> failureOrSuccessOption;

    failureOrSuccessOption = await _repository.clearCredentialsStorage();

    state = state.copyWith(
      failureOrSuccessOptionUpdate: optionOf(failureOrSuccessOption),
    );
  }
}
