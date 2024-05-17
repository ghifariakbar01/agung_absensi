import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/auth_failure.dart';
import '../infrastructures/auth_repository.dart';

part 'auth_notifier.freezed.dart';
part 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(
    this._repository,
  ) : super(AuthState.initial());

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
