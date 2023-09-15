import 'dart:developer';

import 'package:face_net_authentication/shared/providers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/auth_failure.dart';
import '../../infrastructure/auth/auth_repository.dart';

part 'auth_notifier.freezed.dart';
part 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(
    this._ref,
    this._repository,
  ) : super(AuthState.initial()) {
    _ref.listen(userNotifierProvider, (__, _) => checkAndUpdateAuthStatus());
  }

  final Ref _ref;
  final AuthRepository _repository;

  Future<void> checkAndUpdateAuthStatus() async {
    // debugger();
    final isSignedIn = await _repository.isSignedIn();

    if (isSignedIn) {
      state = const AuthState.authenticated();
    } else {
      state = const AuthState.unauthenticated();
    }
  }
}
