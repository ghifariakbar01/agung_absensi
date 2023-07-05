part of 'sign_in_form_notifier.dart';

@freezed
class SignInFormState with _$SignInFormState {
  const factory SignInFormState({
    required UserId userId,
    required Email email,
    required IdKaryawan idKaryawan,
    required Password password,
    required bool showErrorMessages,
    required bool isSubmitting,
    required bool isChecked,
    required Option<Either<AuthFailure, Unit>> failureOrSuccessOption,
  }) = _SignInFormState;

  factory SignInFormState.initial() => SignInFormState(
        userId: UserId(''),
        email: Email(''),
        idKaryawan: IdKaryawan(''),
        password: Password(''),
        showErrorMessages: false,
        isSubmitting: false,
        isChecked: false,
        failureOrSuccessOption: none(),
      );
}
